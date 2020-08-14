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
    private(set) var hand: [Card]
    var points: Int

    struct Card: Identifiable {
        var id: Int
        var color: UIColor
        var number: Int
        var shape: String
        var shading: String
    }

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
        hand = []
        for i in 0..<numberOfCards {
            cards.append(generateCard(for: i))
        }
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
        true
    }

    mutating func pickCard(card: Card) {
        if let cardIndex = cards.firstIndex(of: card) {
            hand.append(card)
            dealtCards.remove(at: cardIndex)

            if hand.count == 3 && isSet(cards: hand) {
                points += 1
                // Show success picking set
                cards.removeAll()
                dealCards()
            } else {
                points -= 1
            }
        }
    }
}
