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

    func cardShape() -> AnyView {
        switch card.shape {
        case .Circle: return AnyView(Circle())
        case .Ellipse: return AnyView(Ellipse())
        case .Rectangle: return AnyView(Rectangle())
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(card.color), lineWidth: 4)
            )
                .overlay(
                    ForEach(0..<card.number) { _ in
                        self.cardShape()
                            .foregroundColor(Color(self.card.color))
                            .padding()
                    }
            )
//                .shadow(color: Color.gray, radius: 10, x: 5, y: 5)
                .padding()
        }
    }
}
