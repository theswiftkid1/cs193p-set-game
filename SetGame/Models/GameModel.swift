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

    struct Card: Identifiable, Hashable {
        var id: UUID = UUID()
        var color: UIColor
        var number: Int
        var shape: SetShape
        var shading: SetShading
        var isSelected: Bool = false
        var isFaceUp: Bool = false
        var matchStatus: MatchStatus = .Unmatched
    }

    // MARK: - Game Setup

    mutating private func generateCards(
        colors: [UIColor],
        shapes: [SetShape],
        shadings: [SetShading],
        numberOfShapes: Int
    ) -> Void {
        for color in colors {
            for shape in shapes {
                for shading in shadings {
                    for number in 1...numberOfShapes {
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

    init(
        colors: [UIColor],
        shapes: [SetShape],
        shadings: [SetShading],
        numberOfShapes: Int
    ) {
        points = 0
        cards = []
        dealtCards = []
        generateCards(
            colors: colors,
            shapes: shapes,
            shadings: shadings,
            numberOfShapes: numberOfShapes
        )
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
        dealtCards.updateAll({ $0.isFaceUp = true })
    }

    private func isMatch(_ selectedCards: Set<Card>) -> Bool {
        func checkRules<T: Equatable & Hashable>(of array: [T]) -> Bool {
            return array.dropFirst().allSatisfy({ $0 == array.first }) ||
                array.count == Set(array).count
        }

        func checkNumber(of cards: Set<Card>) -> Bool {
            checkRules(of: cards.map { $0.number })
        }

        func checkColor(of cards: Set<Card>) -> Bool {
            checkRules(of: cards.map { $0.color })
        }

        func checkShape(of cards: Set<Card>) -> Bool {
            checkRules(of: cards.map { $0.shape })
        }

        func checkShading(of cards: Set<Card>) -> Bool {
            checkRules(of: cards.map { $0.shading })
        }

        return selectedCards.count == GameModel.setSize &&
            checkNumber(of: selectedCards) &&
            checkColor(of: selectedCards) &&
            checkShape(of: selectedCards) &&
            checkShading(of: selectedCards)
    }

    mutating func flipCard(card: Card) {
        if let cardIndex = dealtCards.firstIndex(of: card) {
            dealtCards[cardIndex].isFaceUp.toggle()
        }
    }

    mutating func pickCard(card: Card) {
        func clearMatchStatuses() {
            if dealtCards.exists({ $0.matchStatus == .Matched }) {
                dealCards(3)
            }
            dealtCards.removeAll { $0.matchStatus == .Matched }
            dealtCards.updateAll { $0.matchStatus = .Unmatched }
        }

        func selectCard(at index: Int) {
            dealtCards[index].isSelected = true
            let selectedCards = Set(dealtCards.filter { $0.isSelected })

            if selectedCards.count > GameModel.setSize
                || dealtCards.exists({ $0.matchStatus == .WrongMatch }) {
                for dealtCardIndex in dealtCards.indices {
                    if dealtCardIndex != index {
                        dealtCards[dealtCardIndex].isSelected = false
                    }
                }
                clearMatchStatuses()
            } else if selectedCards.count == dealtCards.count {
                dealtCards.removeAll()
                points += 1
            } else if isMatch(selectedCards) {
                dealtCards.updateAll { $0.matchStatus = $0.isSelected ? .Matched : .Unmatched }
                points += 1
            } else if selectedCards.count == GameModel.setSize {
                dealtCards.updateAll { $0.matchStatus = $0.isSelected ? .WrongMatch : .Unmatched }
                points -= 1
            }
        }

        if card.matchStatus != .Matched,
            let cardIndex = dealtCards.firstIndex(of: card) {
            if (card.isSelected && card.matchStatus != .WrongMatch) {
                dealtCards[cardIndex].isSelected = false
            } else {
                selectCard(at: cardIndex)
            }
        }
    }
}
