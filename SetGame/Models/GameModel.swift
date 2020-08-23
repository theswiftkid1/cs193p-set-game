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
        var matchStatus: MatchStatus = .Unmatched
    }

    // MARK: - Game Setup

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
                clearMatchStatuses()
                for dealtCardIndex in dealtCards.indices {
                    if dealtCardIndex != index {
                        dealtCards[dealtCardIndex].isSelected = false
                    }
                }
            } else if isMatch(selectedCards) {
                dealtCards.updateAll { $0.matchStatus = $0.isSelected ? .Matched : .Unmatched }
                points += 1
            } else if selectedCards.count == GameModel.setSize {
                dealtCards.updateAll { $0.matchStatus = $0.isSelected ? .WrongMatch : .Unmatched }
                points -= 1
            }
        }

        if let cardIndex = dealtCards.firstIndex(of: card) {
            if (card.matchStatus == .Matched) {
                return
            } else if (card.isSelected && card.matchStatus != .WrongMatch) {
                dealtCards[cardIndex].isSelected = false
            } else {
                selectCard(at: cardIndex)
            }
        }
    }
}
