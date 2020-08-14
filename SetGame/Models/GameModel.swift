//
//  SetGame.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import Foundation
import SwiftUI

struct GameModel {
    private static let maxHandSize = 3
    private let numberOfFeatures = 3
    private let numberOfCards = 81
    private(set) var cards: [Card]
    private(set) var dealtCards: [Card]
//    private(set) var hand: [(index: Int, card: Card)]
    var points: Int

    struct Card: Identifiable {
        var id: Int
        var color: UIColor
        var number: Int
        var shape: String
        var shading: String
        var isSelected: Bool = false
    }

    // MARK: - Initialization

    private let colors = [UIColor.red, UIColor.blue, UIColor.green]
    private let shapes = ["Circle", "Square", "Star"]
    private let shading = ["Plain", "Empty", "Striped"]

    private func generateCard(for index: Int) -> Card {
        Card(
            id: index,
            color: colors[index % numberOfFeatures],
            number: index % numberOfFeatures,
            shape: shapes[index % numberOfFeatures],
            shading: shading[index % numberOfFeatures]
        )
    }

    init() {
        points = 0
        cards = []
        dealtCards = []
        for i in 0..<numberOfCards {
            cards.append(generateCard(for: i))
        }
        cards.shuffle()
    }

    // MARK: - Mutations

    mutating func dealCards(_ numberOfCards: Int = maxHandSize) {
        for _ in 0..<numberOfCards {
            if let randomCard = cards.randomElement(),
                let randomCardIndex = cards.firstIndex(of: randomCard) {
                dealtCards.append(randomCard)
                cards.remove(at: randomCardIndex)
            }
        }
    }

    private func isSet(cards: [Card]) -> Bool {
        false
    }

    mutating func pickCard(card: Card) {
        func selectCard(cardIndex: Int, card: Card) {
            dealtCards[cardIndex].isSelected = true
            let nbOfSelectedCards = dealtCards.count { $0.isSelected }

            if isSet(cards: dealtCards) {
                dealtCards.removeAll { $0.isSelected == true }
                points += 1
                dealCards(3)
            } else if nbOfSelectedCards > GameModel.maxHandSize {
                for index in dealtCards.indices {
                    dealtCards[index].isSelected = false
                }
                dealtCards[cardIndex].isSelected = true
                points -= 1
            }
        }


        if let cardIndex = dealtCards.firstIndex(of: card) {
            if (card.isSelected) {
                dealtCards[cardIndex].isSelected = false
            } else {
                selectCard(cardIndex: cardIndex, card: card)
            }
        }
    }
}
