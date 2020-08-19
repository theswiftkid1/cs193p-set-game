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
    private static let setSize = 3
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
        var isMatched: Bool = false
    }

    // MARK: - Initialization

    private let maxNumberOfShapes = 3
    private let colors: [UIColor] = [
        UIColor.init(red: 255 / 255, green: 55 / 255, blue: 95 / 255, alpha: 1),
        UIColor.init(red: 10 / 255, green: 132 / 255, blue: 255 / 255, alpha: 1),
        UIColor.init(red: 52 / 255, green: 199 / 255, blue: 89 / 255, alpha: 1)
    ]
    private let shapes: [SetShape] = [.Circle, .Diamond, .Rectangle]
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

    mutating func dealCards(_ numberOfCards: Int = setSize) {
        for _ in 0..<numberOfCards {
            if let randomCard = cards.randomElement(),
                let randomCardIndex = cards.firstIndex(of: randomCard) {
                dealtCards.append(randomCard)
                cards.remove(at: randomCardIndex)
            }
        }
    }

    private func isSet(_ selectedCards: [Card]) -> Bool {
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

        return selectedCards.count == GameModel.setSize &&
            checkNumber(of: selectedCards) &&
            checkColor(of: selectedCards) &&
            checkShape(of: selectedCards) &&
            checkShading(of: selectedCards)
    }

    mutating func pickCard(card: Card) {
        func clearMatchedSet() {
            let matchedSet = dealtCards.firstIndex { $0.isMatched }
            dealtCards.removeAll { $0.isMatched == true }
            if matchedSet != nil {
                dealCards(3)
            }
        }

        func selectCard(cardIndex: Int, card: Card) {
            dealtCards[cardIndex].isSelected = true
            let selectedCards = dealtCards.filter { $0.isSelected }

            if selectedCards.count > GameModel.setSize {
                clearMatchedSet()

                for index in dealtCards.indices {
                    if (index != cardIndex) {
                        dealtCards[index].isSelected = false
                    }
                }
            } else if isSet(selectedCards) {
                for index in dealtCards.indices {
                    dealtCards[index].isMatched = dealtCards[index].isSelected
                }
                points += 1
            } else if selectedCards.count == GameModel.setSize {
                points -= 1
            }
        }

        if let cardIndex = dealtCards.firstIndex(of: card) {
            if (card.isSelected && !card.isMatched) {
                dealtCards[cardIndex].isSelected = false
            } else {
                selectCard(cardIndex: cardIndex, card: card)
            }
        }
    }
}
