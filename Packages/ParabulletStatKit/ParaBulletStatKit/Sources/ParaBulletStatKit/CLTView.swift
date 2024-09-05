//
//  CLTView.swift
//
//
//  Created by Kunal Kumar on 2024-08-30.
//

import SwiftUI
import Charts

struct CLTView: View {
    @EnvironmentObject var statisticsCalculator: StatisticsCalculator
    @StateObject var cltCalculator: CLTStatisticsCalculator
    @State private var isLoading: Bool = false

    init(statisticsCalculator: StatisticsCalculator) {
        _cltCalculator = StateObject(
            wrappedValue: CLTStatisticsCalculator(
                statisticsCalculator: statisticsCalculator,
                n: 250,
                k: 50
            )
        )
    }

    var StatCalculatorFromCLT: StatisticsCalculator {
        return StatisticsCalculator(data: cltCalculator.sampleMeans)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                inputView

                if isLoading {
                    ProgressView("Calculating...")
                        .padding()
                } else {
                    HistogramView(
                        calculator: StatCalculatorFromCLT
                    )
                    .padding(.top)
                }
            }
            .padding()
            .onAppear {
                Task {
                    isLoading = true
                    await cltCalculator.calculateCentralLimitTheorem()
                    isLoading = false
                }
            }
        }
    }

    var inputView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Number of Samples (n)")
                Spacer()
                TextField("n", value: $cltCalculator.n, formatter: NumberFormatter())
                    .textFieldStyle(PlainTextFieldStyle())
                #if os(iOS)
                    .keyboardType(.numberPad)
                #endif
                    .onChange(of: cltCalculator.n) { newValue in
                        cltCalculator.updateParameters(n: newValue, k: cltCalculator.k)
                    }
                    .multilineTextAlignment(.trailing)
            }
            .cardStyle()

            HStack {
                Text("Sample Size (k)")
                Spacer()
                TextField("k", value: $cltCalculator.k, formatter: NumberFormatter())
                    .textFieldStyle(PlainTextFieldStyle())
#if os(iOS)
                    .keyboardType(.numberPad)
                #endif
                    .onChange(of: cltCalculator.k) { newValue in
                        cltCalculator.updateParameters(n: cltCalculator.n, k: newValue)
                    }
                    .multilineTextAlignment(.trailing)
            }
            .cardStyle()

            Button("Calculate CLT") {
                Task {
                    isLoading = true
                    await cltCalculator.calculateCentralLimitTheorem()
                    isLoading = false
                }
            }
            .padding()
        }
        .padding(.horizontal) // Ensures the input view is aligned properly within the scroll view
    }
}

struct CLTView_Previews: PreviewProvider {

    static var previews: some View {
        CLTView(statisticsCalculator: statisticsCalculator)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
