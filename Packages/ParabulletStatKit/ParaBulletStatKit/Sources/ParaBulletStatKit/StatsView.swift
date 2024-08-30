//
//  StatisticsView.swift
//
//
//  Created by Kunal Kumar on 2024-08-29.
//


import SwiftUI

public struct StatisticsView: View {
    @ObservedObject var calculator: StatisticsCalculator
    @State private var roundingDigits: Int = 2

    public init(calculator: StatisticsCalculator) {
        self.calculator = calculator
    }

    public var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Rounding Digits:")
                Spacer()
                Picker("Digits", selection: $roundingDigits) {
                    ForEach(0..<5) { digit in
                        Text("\(digit)").tag(digit)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
            }
            .cardStyle(baseColor: Color.cyan)

            Section {
                Group {
                    StatCard(title: "Mean", value: calculator.mean, roundingDigits: roundingDigits)
                    StatCard(title: "Mode", value: calculator.mode, roundingDigits: roundingDigits)
                    StatCard(title: "Standard Deviation", value: calculator.standardDeviation, roundingDigits: roundingDigits)
                    StatCard(title: "Median", value: calculator.median, roundingDigits: roundingDigits)
                    StatCard(title: "Variance", value: calculator.variance, roundingDigits: roundingDigits)
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            Task {
                await calculator.calculateStatistics()
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(calculator: statisticsCalculator)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
