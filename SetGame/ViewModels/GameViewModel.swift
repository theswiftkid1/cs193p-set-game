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

    // MARK: - Access to the Model

    var dealtCards: [GameModel.Card] {
        game.dealtCards
    }

    var deckCardsNumber: Int {
        game.cards.count
    }

    var points: Int {
        game.points
    }

    // MARK: - Intent

    func newGame() {
        clearGame()
        dealCards()
    }

    func clearGame() {
        game = GameViewModel.newGame()
    }

    func dealCards(_ numberOfCards: Int = 12) {
        game.dealCards(numberOfCards)
    }

    func pickCard(card: GameModel.Card) {
        game.pickCard(card: card)
    }
}
