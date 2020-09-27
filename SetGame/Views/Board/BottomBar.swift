//
//  BottomBar.swift
//  SetGame
//
//  Created by theswiftkid_ on 9/27/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct DeckData {
    var deckCardsNumber: Int
    var deckPositionX: CGFloat = 0
    var deckPositionY: CGFloat = 0
    var deckCardSize: CGSize = CGSize(width: 0, height: 0)
    var deckContainerHeight: CGFloat = 0
    var deckContainerWidth: CGFloat = 0
}

struct BottomBar: View {
    private let disabledButtonColor = Color.gray
    private let newGameButtonColor = Color.blue
    private let cheatButtonColor = Color(red: 52 / 255, green: 199 / 255, blue: 89 / 255)
    @ObservedObject var game: GameViewModel
    @Binding var deckData: DeckData

    var body: some View {
        HStack {
            self.makeActionButton(text: "New Game", action: newGame, borderColor: newGameButtonColor)

            Spacer()

            GeometryReader { geo in
                DeckView(numberOfCards: deckData.deckCardsNumber)
                    .onAppear {
                        deckData = DeckData(
                            deckCardsNumber: game.dealtCards.count,
                            deckPositionX: geo.frame(in: .global).midX,
                            deckPositionY: geo.frame(in: .global).midY,
                            deckCardSize: geo.frame(in: .global).size,
                            deckContainerHeight: geo.frame(in: .named("bottomBar")).height,
                            deckContainerWidth: geo.frame(in: .named("bottomBar")).width
                        )
                    }
                    .onTapGesture {
                        deckData = DeckData(
                            deckCardsNumber: game.dealtCards.count,
                            deckPositionX: geo.frame(in: .global).midX,
                            deckPositionY: geo.frame(in: .global).midY,
                            deckCardSize: geo.frame(in: .global).size,
                            deckContainerHeight: geo.frame(in: .named("bottomBar")).height,
                            deckContainerWidth: geo.frame(in: .named("bottomBar")).width
                        )
                        dealCard()
                    }
            }
            .frame(minWidth: 100, minHeight: 100)

            Spacer()

            makeActionButton(text: "Cheat",
                             action: dealCard,
                             borderColor: deckData.deckCardsNumber == 0 ? disabledButtonColor : cheatButtonColor)
                .disabled(deckData.deckCardsNumber == 0)
        }
        .coordinateSpace(name: "bottomBar")
        .frame(maxWidth: .infinity, maxHeight: 70)
        .padding([.leading, .trailing])
    }

    // MARK: - ACTIONS

    func makeActionButton(text: String,
                          action: @escaping () -> Void,
                          borderColor: Color) -> some View {
        Button(action: action) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(text)
                    Spacer()
                }
                Spacer()
            }
            .font(.headline)
            .foregroundColor(Color.black)
            .overlay(buttonOverlay(borderColor: borderColor))
        }
    }

    private func buttonOverlay(borderColor: Color) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(borderColor, lineWidth: 3)
            .foregroundColor(borderColor)
    }

    private func dealCards(numberOfCards: Int = 12,
                           delay: Double = 0) {
        withAnimation(Animation.easeOut(duration: 0.5).delay(delay)) {
            game.dealCards(numberOfCards)
        }
    }

    // TODO: - Use AnimatableModifier to make a custom animation, which is triggered
    // when the previous animation is finished
    private func newGame() {
        withAnimation(.easeIn(duration: 0.5)) {
            game.clearGame()
        }
        dealCards(delay: 0.5)
    }

    private func dealCard() {
        withAnimation(Animation.easeOut(duration: 1)) {
            game.dealCard()
        }
    }
}
