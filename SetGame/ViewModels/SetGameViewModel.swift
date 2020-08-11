//
//  SetGameModelView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import Foundation

class SetGameViewModel: ObservableObject {
    @Published private(set) var model: SetGame = SetGameViewModel.newGame()

    private static func newGame() -> SetGame {
        return SetGame()
    }

    // MARK: Access to the Model

    var dealtCards: [SetGame.Card] {
        model.dealtCards
    }

    // MARK: - Intent

    func newGame() {
        model = SetGameViewModel.newGame()
    }

    func dealCards() {
        model.dealCards()
    }

    func pickCard(card: SetGame.Card) {
        model.pickCard(card: card)
    }
}
