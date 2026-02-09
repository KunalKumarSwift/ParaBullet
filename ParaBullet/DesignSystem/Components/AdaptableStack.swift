//
//  AdaptableStack.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2023-09-12.
//

import SwiftUI

struct AdaptableStack<Content: View>: View {
    private let content: () -> Content
    private let proxy: GeometryProxy // Add a property to store the geometry proxy
    private let widthThreshold: CGFloat
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var HSizeClass
    @Environment(\.verticalSizeClass) var VSizeClass
    #endif
    @Environment(\.dynamicTypeSize) var typeSize

    init(_ proxy: GeometryProxy, widthThreshold: CGFloat = 300, @ViewBuilder content: @escaping () -> Content) {
        self.proxy = proxy // Initialize the geometry proxy
        self.content = content
        self.widthThreshold = widthThreshold
    }

    var body: some View {
        Group {
#if os(iOS)
            if HSizeClass == .compact || typeSize > .large {
                VStack(alignment: .leading) {
                    content()
                }
            } else {
                HStack {
                    content()
                }
            }
#else
            if proxy.size.width >= widthThreshold { // Use the passed geometry proxy
                HStack {
                    content()
                }
            } else {
                VStack(alignment: .leading) {
                    content()
                }
            }
#endif
        }
    }
}

struct AdaptableStack_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in // Wrap AdaptableStack in a GeometryReader
            AdaptableStack(proxy) { // Pass the geometry proxy to AdaptableStack
                Text("Hello")
                Text("Bello")
            }
        }
    }
}
