//
//  CardView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/13/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct CardView: View {
    enum CardSide {
        case Front
        case Back
    }

    var card: GameModel.Card
    var side: CardSide = .Front

    let shapeStrokeWidth: CGFloat = 2
    let cardStrokeWidth: CGFloat = 4
    let matchedColor: Color = Color(red: 255 / 255, green: 214 / 255, blue: 10 / 255)
    var opacity: Double {
        card.shading == .Striped ? 0.5 : 1
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
        cardView
            .padding(cardStrokeWidth)
            .aspectRatio(2/3, contentMode: ContentMode.fit)
    }

    @ViewBuilder
    var cardView: some View {
        if side == .Front {
            front
        } else {
            back
        }
    }

    var front: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(
                    color: card.isMatched ? matchedColor : .black,
                    radius: card.isSelected ? 10 : 0,
                    x: 0,
                    y: 0
            )

            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(card.color), lineWidth: cardStrokeWidth)
                .overlay (
                    VStack {
                        ForEach(0..<card.number) { _ in
                            self.cardShape
                                .foregroundColor(Color(self.card.color))
                                .opacity(self.opacity)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
            )
        }
    }

    var back: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(card.color).opacity(0.7))

            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(Color.black.opacity(0.2), lineWidth: cardStrokeWidth)
        }
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

struct CardBackView_Previews: PreviewProvider {
    static let game = GameViewModel()

    static var previews: some View {
        game.dealCards(1)
        let card = game.dealtCards.first!
        return CardView(card: card, side: .Back)
            .previewLayout(.fixed(width: 200, height: 300))
    }
}
