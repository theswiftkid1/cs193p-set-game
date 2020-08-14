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

    private var cardStroke: Color {
        if card.isSelected {
            return Color.init(red: 255 / 255, green: 55 / 255, blue: 95 / 255)
        } else {
            return Color.init(red: 10 / 255, green: 132 / 255, blue: 255 / 255)
        }
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(cardStroke, lineWidth: 4)
        )
            .padding()

    }
}
