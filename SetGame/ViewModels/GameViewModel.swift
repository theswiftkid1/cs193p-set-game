//
//  SetGameModelView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published private(set) var game: GameModel = GameViewModel.newGame()

    private static func newGame() -> GameModel {
        return GameModel()
    }

    // MARK: Access to the Model

    var dealtCards: [GameModel.Card] {
        game.dealtCards
    }

    // MARK: - Intent

    func newGame() {
        game = GameViewModel.newGame()
        game.dealCards(12)
    }


    func dealCards() {
        game.dealCards(3)
    }

    func pickCard(card: GameModel.Card) {
        game.pickCard(card: card)
    }
}
