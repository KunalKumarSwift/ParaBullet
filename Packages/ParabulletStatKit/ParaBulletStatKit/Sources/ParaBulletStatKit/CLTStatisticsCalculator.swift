//
//  CLTStatisticsCalculator.swift
//
//
//  Created by Kunal Kumar on 2024-08-30.
//

import SwiftUI
import Combine

public class CLTStatisticsCalculator: ObservableObject {
    @ObservedObject private var statisticsCalculator: StatisticsCalculator

    @Published var sampleMeans: [Double] = []
    @Published var standardError: Double = 0.0
    @Published var n: Int
    @Published var k: Int
    @Published var meanOfMeans: Double = 0.0

    init(statisticsCalculator: StatisticsCalculator, n: Int, k: Int) {
        self.statisticsCalculator = statisticsCalculator
        self.n = n
        self.k = k
        Task {
            await calculateCentralLimitTheorem()
        }
    }

    public func updateParameters(n: Int, k: Int) {
        self.n = n
        self.k = k
        Task {
            await calculateCentralLimitTheorem()
        }
    }

    public func calculateCentralLimitTheorem() async {
        guard !statisticsCalculator.data.isEmpty, n > 0, k > 0 else {
            sampleMeans = []
            standardError = 0.0
            return
        }

        var means: [Double] = []
        await withTaskGroup(of: [Double].self) { group in
            for _ in 0..<n {
                group.addTask {
                    let sample = await self.sample(from: self.statisticsCalculator.data, size: self.k)
                    let mean = sample.reduce(0, +) / Double(sample.count)
                    return [mean]
                }
            }

            for await result in group {
                means.append(contentsOf: result)
            }
        }

        let meanOfMeans = means.reduce(0, +) / Double(means.count)
        let varianceOfMeans = means.map { pow($0 - meanOfMeans, 2) }.reduce(0, +) / Double(means.count)
        let stdDevOfMeans = sqrt(varianceOfMeans)
        let se = stdDevOfMeans / sqrt(Double(k))

        await MainActor.run {
            self.sampleMeans = means
            self.standardError = se
            self.meanOfMeans = meanOfMeans
        }
    }

    private func sample(from data: [Double], size: Int) -> [Double] {
        guard size <= data.count else { return data }
        let result = (0..<size).compactMap { _ in data.randomElement() }
        print(result)
        return result
    }
}
