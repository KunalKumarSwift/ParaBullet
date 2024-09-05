//
//  StatCard.swift
//
//
//  Created by Kunal Kumar on 2024-08-29.
//

import SwiftUI

struct StatCard<Value>: View {
    let title: String
    let value: Value
    let roundingDigits: Int

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .bold()
            Spacer()
            Text(formatValue(value))
                .font(.headline)
        }
#if os(iOS)
        .foregroundColor(Color(uiColor: UIColor.label))
#endif
        .cardStyle()
    }

    private func formatValue(_ value: Value) -> String {
        if let doubleValue = value as? Double {
            return String(format: "%.\(roundingDigits)f", doubleValue)
        } else if let doubleArray = value as? [Double] {
            let roundedValues = doubleArray.map { String(format: "%.\(roundingDigits)f", $0) }
            return roundedValues.joined(separator: ", ")
        }
        return ""
    }
}

struct StatCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StatCard(title: "Mean", value: 23.4567, roundingDigits: 2)
            StatCard(title: "Mode", value: [1.23, 4.56], roundingDigits: 3)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
