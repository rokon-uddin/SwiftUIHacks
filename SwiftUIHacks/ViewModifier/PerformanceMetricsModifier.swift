//
//  PerformanceMetricsModifier.swift
//  SwiftUIHacks
//
//  Created by Mohammed Rokon Uddin on 9/17/24.
//

import Darwin
import Foundation
import MachO
import SwiftUI

class PerformanceMetrics: ObservableObject {
  @Published var cpuUsage: Double = 0
  @Published var memoryUsage: Int64 = 0
  @Published var frameRate: Double = 0

  private var timer: Timer?
  private var displayLink: CADisplayLink?
  private var frameCount: Int = 0
  private var startTime: CFTimeInterval = 0

  init() {
    // Start the timer to update metrics
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.updateMetrics()
    }

    // Start the display link to calculate frame rate
    startFrameRateMeasurement()
  }

  private func updateMetrics() {
    cpuUsage = getCPUUsage()
    memoryUsage = getMemoryUsage()
  }

  private func getCPUUsage() -> Double {
    // Fetch CPU usage data
    var cpuInfo = host_cpu_load_info()
    var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size) / 4
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &cpuInfo) {
      $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
        host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
      }
    }

    if kerr == KERN_SUCCESS {
      let totalUsage = Double(cpuInfo.cpu_ticks.0 + cpuInfo.cpu_ticks.1 + cpuInfo.cpu_ticks.2 + cpuInfo.cpu_ticks.3)
      let userUsage = Double(cpuInfo.cpu_ticks.0 + cpuInfo.cpu_ticks.1)
      return (userUsage / totalUsage) * 100
    } else {
      return 0
    }
  }

  private func getMemoryUsage() -> Int64 {
    var taskInfo = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
      $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
        task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
      }
    }
    if kerr == KERN_SUCCESS {
      return Int64(taskInfo.resident_size)
    } else {
      return 0
    }
  }

  private func startFrameRateMeasurement() {
    displayLink = CADisplayLink(target: self, selector: #selector(updateFrameRate))
    displayLink?.add(to: .current, forMode: .default)
  }

  @objc private func updateFrameRate() {
    frameCount += 1
    if startTime == 0 {
      startTime = CACurrentMediaTime()
    }
    let elapsed = CACurrentMediaTime() - startTime
    if elapsed > 1.0 {
      frameRate = Double(frameCount) / elapsed
      frameCount = 0
      startTime = CACurrentMediaTime()
    }
  }

  deinit {
    timer?.invalidate()
    displayLink?.invalidate()
  }
}

struct PerformanceMetricsModifier: ViewModifier {
  @StateObject private var metrics = PerformanceMetrics()

  func body(content: Content) -> some View {
    content
      .overlay(
        VStack(alignment: .leading) {
          Text("CPU: \(String(format: "%.1f", metrics.cpuUsage))%")
          Text("Memory: \(ByteCountFormatter.string(fromByteCount: metrics.memoryUsage, countStyle: .memory))")
          Text("FPS: \(String(format: "%.1f", metrics.frameRate))")
        }
        .font(.caption)
        .padding(4)
        .background(Color.black.opacity(0.7))
        .foregroundColor(.white)
        .cornerRadius(4)
        .padding(4),
        alignment: .topLeading
      )
  }
}

extension View {
  func performanceMetrics() -> some View {
    self.modifier(PerformanceMetricsModifier())
  }
}
