//
//  Cardify.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/24/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    var isFaceUp: Bool { rotation < 90 }

    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }

    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 2

    private func cardFront(content: Content) -> some View {
        Group {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)

            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color.black, lineWidth: edgeLineWidth)

            content
        }
            .opacity(isFaceUp ? 1 : 0)
    }

    private var cardBack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(Color.gray)

            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color.black, lineWidth: edgeLineWidth)
        }
            .opacity(isFaceUp ? 0 : 1)
    }

    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }

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
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
}
