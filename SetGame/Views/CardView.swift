//
//  CardView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/13/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var card: GameModel.Card
    let strokeWidth: CGFloat = 2
    let stripeWidth: Int = 10
    var shadowColor: Color {
        switch card.matchStatus {
        case .Unmatched: return Color.black
        case .Matched: return Color(red: 255 / 255, green: 214 / 255, blue: 10 / 255)
        case .WrongMatch: return Color(red: 255 / 255, green: 59 / 255, blue: 48 / 255)
        }
    }
    private let aspectRatio: CGFloat = 2/3

    private func buildStripedShape<S>(shape: S) -> some View
        where S: Shape {
        ZStack {
            Stripes(stripesDistance: 10, incline: 10)
                .stroke(lineWidth: CGFloat(stripeWidth))
                .mask(shape)
            shape.stroke(lineWidth: strokeWidth)
        }
    }

    @ViewBuilder
    var cardShape: some View {
        switch (card.shape, card.shading) {
        case (.Circle, .Open):
            Circle().stroke(lineWidth: strokeWidth)
        case (.Circle, .Striped):
            buildStripedShape(shape: Circle())
        case (.Circle, _):
            Circle()
        case (.Diamond, .Open):
            Diamond().stroke(lineWidth: strokeWidth)
        case (.Diamond, .Striped):
            buildStripedShape(shape: Diamond())
        case (.Diamond, _):
            Diamond()
        case (.Squiggle, .Open):
            Squiggle().stroke(lineWidth: strokeWidth)
        case (.Squiggle, .Striped):
            buildStripedShape(shape: Squiggle())
        case (.Squiggle, _):
            Squiggle()
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(
                    color: shadowColor,
                    radius: card.isSelected ? 10 : 0,
                    x: 0,
                    y: 0
            )

            VStack {
                ForEach(0..<card.number) { _ in
                    cardShape
                        .foregroundColor(Color(card.color))
                }
            }
            .padding()
        }
        .cardify(isFaceUp: card.isFaceUp, aspectRatio: aspectRatio)
        .scaleEffect(card.isSelected ? 1.10 : 1)
    }
}

struct CardView_Previews: PreviewProvider {
    static let game = GameViewModel()

    static var previews: some View {
        game.dealCards(1)
        let card1 = game.dealtCards.first!
        game.flipCard(card: card1)
        let card = game.dealtCards.first!
        return CardView(card: card)
            .previewLayout(.fixed(width: 200, height: 300))
    }
}
