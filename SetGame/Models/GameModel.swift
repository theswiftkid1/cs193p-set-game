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
    private let numberOfCards = 81
    private(set) var cards: [Card]
    private(set) var dealtCards: [Card]
    private(set) var points: Int

    struct Card: Identifiable {
        var id: UUID = UUID()
        var color: UIColor
        var number: Int
        var shape: SetShape
        var shading: SetShading
        var isSelected: Bool = false
    }

    // MARK: - Initialization

    private let maxNumberOfShapes = 3
    private let colors: [UIColor] = [
        UIColor.init(red: 255 / 255, green: 55 / 255, blue: 95 / 255, alpha: 1),
        UIColor.init(red: 10 / 255, green: 132 / 255, blue: 255 / 255, alpha: 1),
        UIColor.init(red: 52 / 255, green: 199 / 255, blue: 89 / 255, alpha: 1)
    ]
    private let shapes: [SetShape] = [.Circle, .Ellipse, .Rectangle]
    private let shadings: [SetShading] = [.Plain, .Open, .Striped]

    mutating private func generateCards() -> Void {
        for color in colors {
            for shape in shapes {
                for shading in shadings {
                    for number in 1...maxNumberOfShapes {
                        self.cards.append(Card(
                            color: color,
                            number: number,
                            shape: shape,
                            shading: shading
                        ))
                    }
                }
            }
        }
    }

    init() {
        points = 0
        cards = []
        dealtCards = []
        generateCards()
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
        func checkRules<T: Equatable & Hashable>(of array: [T]) -> Bool {
            return array.dropFirst().allSatisfy({ $0 == array.first }) ||
                array.count == Set(array).count
        }

        func checkNumber(of cards: [Card]) -> Bool {
            checkRules(of: cards.map { $0.number })
        }

        func checkColor(of cards: [Card]) -> Bool {
            checkRules(of: cards.map { $0.color })
        }

        func checkShape(of cards: [Card]) -> Bool {
            checkRules(of: cards.map { $0.shape })
        }

        func checkShading(of cards: [Card]) -> Bool {
            checkRules(of: cards.map { $0.shading })
        }

        return checkNumber(of: cards) &&
            checkColor(of: cards) &&
            checkShape(of: cards) &&
            checkShading(of: cards)
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
