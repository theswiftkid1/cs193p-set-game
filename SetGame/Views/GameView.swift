//
//  GameView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var game: GameViewModel

    let disabledButtonColor = Color.gray

    var body: some View {
        VStack(alignment: .center) {
            if game.isGameOver {
                endGame
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: AnyTransition.scale(scale: 10).animation(.spring()),
                            removal: AnyTransition.opacity.animation(.easeIn(duration: 1))
                        )
                )
            } else {
                topBar
                gameTable
            }

            bottomBar
        }
    }

    // MARK - END GAME

    var endGame: some View {
        EndGame()
    }

    // MARK: - GAME

    var gameTable: some View {
        VStack {
            ZStack {
                Grid(items: game.dealtCards) { card in
                    CardView(card: card)
                        .padding([.bottom])
                        .scaleEffect(card.isSelected ? 1.10 : 1)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                self.game.pickCard(card: card)
                            }
                    }
                    .transition(.asymmetric(
                        insertion: .offset(self.deckPosition),
                        removal: .offset(self.randomOffset)
                        )
                    )
                }
            }.onAppear {
                self.dealCards()
            }
        }
    }

    // MARK: - TOP BAR

    var topBar: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Set Card Game")
                    .font(.system(size: 22))
                    .bold()
                Spacer()
            }
            //            .background(Color.orange)

            HStack {
                Group {
                    deck
                    Spacer()
                }
                .multilineTextAlignment(.leading)
                .frame(maxHeight: 100)

                Text("Score: \(game.points)")
                    .bold()
                    .multilineTextAlignment(.trailing)
                //                    .background(Color.blue)
            }
        }
        .padding([.leading, .trailing])
        //        .background(Color.green)
    }

    var deck: some View {
        DeckView(numberOfCards: game.deckCardsNumber)
    }

    // MARK: - BOTTOM BAR

    var bottomBar: some View {
        HStack {
            makeActionButton(text: "New Game", action: self.newGame)

            makeActionButton(text: "Deal Cards",
                             action: self.dealMoreCards,
                             borderColor: game.deckCardsNumber == 0 ? disabledButtonColor : Color(red: 52 / 255, green: 199 / 255, blue: 89 / 255))
                .disabled(game.deckCardsNumber == 0)
        }
        .padding([.leading, .trailing])
    }

    // MARK: - ACTIONS

    func flipCard(card: GameModel.Card) {
        self.game.flipCard(card: card)
    }

    func makeActionButton(text: String,
                          action: @escaping () -> Void,
                          borderColor: Color = Color.blue) -> some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text)
                Spacer()
            }
            .font(.headline)
            .foregroundColor(Color.black)
            .padding()
            .overlay(buttonOverlay(borderColor: borderColor))
        }
    }

    private func buttonOverlay(borderColor: Color) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(borderColor, lineWidth: 3)
            .foregroundColor(borderColor)
            .padding([.leading, .trailing])
    }

    private var deckPosition: CGSize {
        return CGSize(width: -1000, height: -1000)
    }

    private var randomOffset: CGSize {
        let screenSize: CGSize = UIScreen.main.bounds.size
        let screenSide: [CGFloat] = [-1, 1]

        let x: CGFloat = .random(in: screenSize.width..<screenSize.width * 1.5) * screenSide.randomElement()!
        let y: CGFloat = .random(in: screenSize.height..<screenSize.height * 1.5) * screenSide.randomElement()!

        return CGSize(width: x, height: y)
    }

    private func dealCards(numberOfCards: Int = 12,
                           delay: Double = 0) {
        withAnimation(Animation.easeOut(duration: 0.5).delay(delay)) {
            self.game.dealCards(numberOfCards)
        }
    }

    // TODO: - Use AnimatableModifier to make a custom animation, which is triggered
    // when the previous animation is finished
    private func newGame() {
        withAnimation(.easeIn(duration: 0.5)) {
            self.game.clearGame()
        }
        dealCards(delay: 0.5)
    }

    private func dealMoreCards() {
        dealCards(numberOfCards: 1)
        dealCards(numberOfCards: 1, delay: 0.5)
        dealCards(numberOfCards: 1, delay: 1)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GameViewModel()
        return GameView(game: model)
    }
}
