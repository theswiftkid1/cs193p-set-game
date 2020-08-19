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
            HStack {
                Spacer()
                Text("SET")
                Spacer()
                Text(String(game.points))
                Spacer()
            }
            .font(.title)
            .padding()

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

    var bottomBar: some View {
        HStack {
            Spacer()
            makeActionButton(text: "New Game", action: self.newGame)
            Spacer()
            makeActionButton(text: "Deal More Cards",
                             action: self.dealMoreCards,
                             borderColor: game.deckCardsNumber == 0 ? disabledButtonColor : Color(red: 52 / 255, green: 199 / 255, blue: 89 / 255))
                .disabled(game.deckCardsNumber == 0)
            Spacer()
        }
    }

    func makeActionButton(text: String,
                          action: @escaping () -> Void,
                          borderColor: Color = Color.blue) -> some View {
        Button(action: {
            action()
        }) {
            Text(text)
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

    private func dealCards(delay: Double = 0) {
        withAnimation(Animation.easeOut(duration: 0.5).delay(delay)) {
            self.game.dealCards()
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
        withAnimation(.easeOut(duration: 0.5)) {
            self.game.dealCards(3)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GameViewModel()
        return GameView(game: model)
    }
}
