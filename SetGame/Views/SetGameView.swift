//
//  SetGameView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var model: SetGameViewModel

    var body: some View {
        VStack {
            Text("Points: \(model.model.points)")

            Grid(items: model.dealtCards) { card in
                CardView(card: card).onTapGesture {
                    self.model.pickCard(card: card)
                }
            }

            HStack {
                Button(action: {
                    self.model.dealCards()
                }) {
                    Text("Add more cards")
                }
            }
        }
    }
}

struct CardView: View {
    var card: SetGame.Card

    var body: some View {
        Rectangle().stroke()
    }
}

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let model = SetGameViewModel()
        return SetGameView(model: model)
    }
}
