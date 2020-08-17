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

    let strokeWidth: CGFloat = 4
    var opacity: Double {
        card.shading == .Striped ? 0.5 : 1
    }

    var cardShape: some View {
        switch (card.shape, card.shading) {
        case (.Circle, .Open):
            return AnyView(Circle().stroke(lineWidth: strokeWidth))
        case (.Circle, _):
            return AnyView(Circle())
        case (.Ellipse, .Open):
            return AnyView(Ellipse().stroke(lineWidth: strokeWidth))
        case (.Ellipse, _):
            return AnyView(Ellipse())
        case (.Rectangle, .Open):
            return AnyView(Rectangle().stroke(lineWidth: strokeWidth))
        case (.Rectangle, _):
            return AnyView(Rectangle())
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(color: .black, radius: card.isSelected ? 10 : 0, x: 0, y: 0)

            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(card.color), lineWidth: 4)
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
        .padding()
        
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
