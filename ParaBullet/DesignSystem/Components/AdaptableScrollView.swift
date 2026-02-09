//
//  AdaptableScrollView.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2023-09-12.
//

import SwiftUI

struct AdaptableScrollView<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        Group {
#if os(iOS)
            ScrollView {
                content()
            }
#else
            VStack {
                content()
            }
#endif
        }
        //.frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}


struct AdaptableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        AdaptableScrollView {
            Text("1")
            Text("1")
            Text("1")
            Text("1")
            Text("1")
            Text("1")
            Text("1")
            Text("1")
        }
    }
}
