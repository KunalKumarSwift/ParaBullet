//
//  HistogramView.swift
//
//
//  Created by Kunal Kumar on 2024-08-29.
//

import SwiftUI
import Charts

struct HistogramView: View {
    @ObservedObject var calculator: StatisticsCalculator

    @State private var binStart: Double = 0.0
    @State private var binEnd: Double = 10.0
    @State private var binStep: Double = 0.5
    @State private var frequencies: [(bin: Double, count: Int)] = []

    private var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1  // Adjust as needed
        return formatter
    }

    public var body: some View {
        VStack {
            // Input for bin configuration
            VStack(spacing: 20) {
                HStack {
                    Text("Mean")
                        .font(.headline)
                        .bold()
                    Spacer()
                    Text("\(calculator.mean)")
                        .multilineTextAlignment(.trailing)
                }
                .cardStyle(baseColor: Color.green)

                HStack {
                    Text("Bin Start")
                        .font(.headline)
                        .bold()
                    Spacer()
                    TextField("Bin Start", value: $binStart, formatter: NumberFormatter())
                        .textFieldStyle(PlainTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                        .onChange(of: binStart) { _ in calculateFrequencies() }
                }
                .cardStyle(baseColor: Color.blue)

                HStack {
                    Text("Bin End")
                        .font(.headline)
                        .bold()
                    Spacer()
                    TextField("Bin End", value: $binEnd, formatter: NumberFormatter())
                        .textFieldStyle(PlainTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                        .onChange(of: binEnd) { _ in calculateFrequencies() }
                }
                .cardStyle(baseColor: Color.blue)

                HStack {
                    Text("Bin Step")
                        .font(.headline)
                        .bold()
                    Spacer()
                    TextField("Bin Step", value: $binStep, formatter: decimalFormatter)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.subheadline)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: binStep) { _ in calculateFrequencies() }
                }
                .cardStyle()

            }
            //.padding()

            Button("Calculate Histogram") {
                calculateFrequencies()
            }
            .padding()

            // Histogram chart using Charts framework
            Chart($frequencies.wrappedValue, id: \.bin) { item in
                BarMark(
                    x: .value("Bin", item.bin),
                    y: .value("Count", item.count)
                )
                .foregroundStyle(colorForBin(item.bin))
            }
            .padding()
            .frame(height: 300)
            .chartYAxisLabel("Frequency")
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text("Bins")
            }
        }
        .onAppear {
            // Update binStart and binEnd based on data
            updateBinRange()
        }
        .padding()
    }

    private func calculateFrequencies() {
        frequencies = []
        for value in stride(from: binStart, through: binEnd, by: binStep) {
            let count = calculator.data.filter { $0 >= value && $0 < value + binStep }.count
            frequencies.append((bin: value, count: count))
        }
    }

    private func colorForBin(_ bin: Double) -> Color {
        let mean = calculator.mean
        let standardDeviation = calculator.standardDeviation

        // Define the range around the mean for highlighting
        let meanRange = mean...mean + binStep

        // Define the color ranges for standard deviations
        let lowRange = mean - 3 * standardDeviation...mean - 2 * standardDeviation
        let midLowRange = mean - 2 * standardDeviation...mean - standardDeviation
        let midHighRange = mean + standardDeviation...mean + 2 * standardDeviation
        let highRange = mean + 2 * standardDeviation...mean + 3 * standardDeviation

        // Check if the bin falls within the highlighted range around the mean
        if meanRange.contains(bin) {
            return .green  // Highlight the bin where the mean is present
        } else if lowRange.contains(bin) || highRange.contains(bin) {
            return .blue  // Highlight bins within ±2 to ±3 standard deviations
        } else if midLowRange.contains(bin) || midHighRange.contains(bin) {
            return .red  // Highlight bins within ±1 to ±2 standard deviations
        } else if bin >= mean - standardDeviation && bin < mean + standardDeviation {
            return .yellow  // Highlight bins within ±1 standard deviation
        }

        return .gray  // Default color for bins outside the ranges
    }

    private func updateBinRange() {
        guard !calculator.data.isEmpty else { return }
        binStart = calculator.data.min() ?? 0.0
        binEnd = calculator.data.max() ?? 10.0
    }
}

struct HistogramView_Previews: PreviewProvider {
    static var previews: some View {
        HistogramView(calculator: statisticsCalculator)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
