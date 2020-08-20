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
        VStack {
            topBar

            ZStack {
                Grid(items: game.dealtCards) { card in
                    CardView(card: card)
                        .aspectRatio(CGSize(width: 2.2, height: 3), contentMode: ContentMode.fit)
                        .scaleEffect(card.isSelected ? 1.15 : 1)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                self.game.pickCard(card: card)
                            }
                    }
                    .transition(.offset(self.randomOffset))
                }
                .padding([.horizontal, .bottom])
            }.onAppear {
                self.dealCards()
            }

            bottomBar
        }
    }

    var topBar: some View {
        VStack {
            HStack {
                Text("Set Card Game")
                    .font(.title)
                    .bold()
                    .padding([.top])
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            HStack {
                deck
                Text("Score: \(game.points)")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }
            .padding([.top])
        }
        .padding([.leading, .trailing])
    }

    var deck: some View {
        Text("Deck")
    }

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

    private var randomOffset: CGSize {
        let screenSize: CGSize = UIScreen.main.bounds.size
        let screenSide: [CGFloat] = [-1, 1]

        let x: CGFloat = .random(in: screenSize.width..<screenSize.width * 1.5) * screenSide.randomElement()!
        let y: CGFloat = .random(in: screenSize.height..<screenSize.height * 1.5) * screenSide.randomElement()!

        return CGSize(width: x, height: y)
    }

    private var randomDelay: Double {
        return Double.random(in: 0...1)
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
        withAnimation(Animation.easeIn(duration: 0.5)) {
            self.game.clearGame()
        }
        dealCards(delay: 0.5)
    }

    private func dealMoreCards() {
        dealCards(numberOfCards: 3)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GameViewModel()
        return GameView(game: model)
    }
}
