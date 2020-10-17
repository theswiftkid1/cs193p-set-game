//
//  SetGameModelView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private(set) var game: GameModel = GameViewModel.newGame()

    private static func newGame() -> GameModel {
        // Testing data
        // TODO: - Find a better way to test winning games
//        let numberOfShapes = 3
//        let colors: [UIColor] = [
//            UIColor.init(red: 255 / 255, green: 55 / 255, blue: 95 / 255, alpha: 1),
//        ]
//        let shapes: [SetShape] = [.Circle]
//        let shadings: [SetShading] = [.Plain]

        let colors: [UIColor] = [
            UIColor.init(red: 255 / 255, green: 55 / 255, blue: 95 / 255, alpha: 1),
            UIColor.init(red: 10 / 255, green: 132 / 255, blue: 255 / 255, alpha: 1),
            UIColor.init(red: 52 / 255, green: 199 / 255, blue: 89 / 255, alpha: 1)
        ]
        let shapes: [SetShape] = [.Circle, .Diamond, .Squiggle]
        let shadings: [SetShading] = [.Plain, .Open, .Striped]
        let numberOfShapes = 3

        return GameModel.init(
            colors: colors,
            shapes: shapes,
            shadings: shadings,
            numberOfShapes: numberOfShapes
        )
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

    var isGameOver: Bool {
        dealtCards.isEmpty && deckCardsNumber == 0
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

    func flipCard(card: GameModel.Card) {
        game.flipCard(card: card)
    }
}
