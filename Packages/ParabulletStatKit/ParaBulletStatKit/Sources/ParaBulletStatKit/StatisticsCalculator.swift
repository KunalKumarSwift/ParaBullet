//
//  StatisticsCalculator.swift
//
//
//  Created by Kunal Kumar on 2024-08-29.
//

import Foundation
import Combine

public class StatisticsCalculator: ObservableObject {
    @Published var data: [Double] = [] {
        didSet {
            calculateStatistics()
        }
    }

    @Published var mean: Double = 0.0
    @Published var mode: [Double] = []
    @Published var standardDeviation: Double = 0.0
    @Published var median: Double = 0.0
    @Published var variance: Double = 0.0

    init(data: [Double] = []) {
        self.data = data
        calculateStatistics()
    }

    func calculateStatistics() {
        guard !data.isEmpty else {
            resetStatistics()
            return
        }

        Task {
            async let meanValue = calculateMean(data)
            async let modeValue = calculateMode(data)
            async let stdDevValue = calculateStandardDeviation(data)
            async let medianValue = calculateMedian(data)
            async let varianceValue = calculateVariance(data)

            await updateStatistics(
                mean: meanValue,
                mode: modeValue,
                standardDeviation: stdDevValue,
                median: medianValue,
                variance: varianceValue
            )
        }
    }

    private func resetStatistics() {
        mean = 0.0
        mode = []
        standardDeviation = 0.0
        median = 0.0
        variance = 0.0
    }

    private func updateStatistics(mean: Double, mode: [Double], standardDeviation: Double, median: Double, variance: Double) async {
        await MainActor.run {
            self.mean = mean
            self.mode = mode
            self.standardDeviation = standardDeviation
            self.median = median
            self.variance = variance
        }
    }

    private func calculateMean(_ data: [Double]) async -> Double {
        let sum = data.reduce(0, +)
        return sum / Double(data.count)
    }

    private func calculateMode(_ data: [Double]) async -> [Double] {
        var frequency: [Double: Int] = [:]
        data.forEach { frequency[$0, default: 0] += 1 }
        let maxFrequency = frequency.values.max() ?? 0
        return frequency.filter { $0.value == maxFrequency }.map { $0.key }
    }

    private func calculateStandardDeviation(_ data: [Double]) async -> Double {
        let meanValue = await calculateMean(data)
        let variance = await calculateVariance(data, mean: meanValue)
        return sqrt(variance)
    }

    private func calculateMedian(_ data: [Double]) async -> Double {
        let sortedData = data.sorted()
        if sortedData.count % 2 == 0 {
            let middleIndex = sortedData.count / 2
            return (sortedData[middleIndex - 1] + sortedData[middleIndex]) / 2
        } else {
            return sortedData[sortedData.count / 2]
        }
    }

    private func calculateVariance(_ data: [Double], mean: Double? = nil) async -> Double {
        let meanValue: Double
        if let mean = mean {
            meanValue = mean
        } else {
            meanValue = await calculateMean(data)
        }

        let sumOfSquaredDifferences = data.map { pow($0 - meanValue, 2) }.reduce(0, +)
        return sumOfSquaredDifferences / Double(data.count)
    }
}

