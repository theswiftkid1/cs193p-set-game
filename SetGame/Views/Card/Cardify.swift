//
//  Cardify.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/24/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    @State var isFaceUp: Bool
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 2

    func body(content: Content) -> some View {
        ZStack {
            cardFront(content: content)
            CardBackView(
                cornerRadius: cornerRadius,
                edgeLineWidth: edgeLineWidth
            ).opacity(isFaceUp ? 0 : 1)
        }
        .padding(edgeLineWidth)
        .aspectRatio(2/3, contentMode: ContentMode.fit)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: {
                isFaceUp = true
            })
        })
    }

    private func cardFront(content: Content) -> some View {
        Group {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)

            content

            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color.black, lineWidth: edgeLineWidth)
        }
    }

    struct CardOpacityModifier: ViewModifier {
        let opacity: Double

        func body(content: Content) -> some View {
            content.opacity(opacity)
        }
    }
}
