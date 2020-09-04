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
    let shapeStrokeWidth: CGFloat = 2
    var opacity: Double {
        card.shading == .Striped ? 0.5 : 1
    }
    var shadowColor: Color {
        switch card.matchStatus {
        case .Unmatched: return Color.black
        case .Matched: return Color(red: 255 / 255, green: 214 / 255, blue: 10 / 255)
        case .WrongMatch: return Color(red: 255 / 255, green: 59 / 255, blue: 48 / 255)
        }
    }

    var cardShape: some View {
        switch (card.shape, card.shading) {
        case (.Circle, .Open):
            return AnyView(Circle().stroke(lineWidth: shapeStrokeWidth))
        case (.Circle, _):
            return AnyView(Circle())
        case (.Diamond, .Open):
            return AnyView(Diamond().stroke(lineWidth: shapeStrokeWidth))
        case (.Diamond, _):
            return AnyView(Diamond())
        case (.Rectangle, .Open):
            return AnyView(Rectangle().stroke(lineWidth: shapeStrokeWidth))
        case (.Rectangle, _):
            return AnyView(Rectangle())
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(
                    color: self.shadowColor,
                    radius: self.card.isSelected ? 10 : 0,
                    x: 0,
                    y: 0
            )

            VStack {
                ForEach(0..<self.card.number) { _ in
                    self.cardShape
                        .foregroundColor(Color(self.card.color))
                        .opacity(self.opacity)
                }
            }
            .padding()
        }
        .cardify(isFaceUp: self.card.isFaceUp)
        .scaleEffect(self.card.isSelected ? 1.10 : 1)
    }
}

struct CardView_Previews: PreviewProvider {
    static let game = GameViewModel()

    static var previews: some View {
        game.dealCards(1)
        let card = game.dealtCards.first!
        return CardView(card: card)
            .previewLayout(.fixed(width: 200, height: 300))
    }
}
