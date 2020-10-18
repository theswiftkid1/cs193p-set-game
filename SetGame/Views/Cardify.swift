//
//  Cardify.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/24/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var aspectRatio: CGFloat
    private var rotation: Double
    private var sideRotation: Double
    private var isFaceUp: Bool { rotation < 90 }

    internal var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }

    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 2

    private func cardFront(content: Content) -> some View {
        Group {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)

            content

            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color.black, lineWidth: edgeLineWidth)
        }
            .opacity(isFaceUp ? 1 : 0)
    }

    init(isFaceUp: Bool, aspectRatio: CGFloat) {
        rotation = isFaceUp ? 0 : 180
        sideRotation = isFaceUp ? 0 : 90
        self.aspectRatio = aspectRatio
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
        .aspectRatio(aspectRatio, contentMode: ContentMode.fit)
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
        .rotation3DEffect(Angle.degrees(sideRotation), axis: (0,0,1))
    }
}
