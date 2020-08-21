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
            topBar
            gameBar
            bottomBar
        }
    }

    // MARK: - GAME

    var gameBar: some View {
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
                .transition(.offset(self.randomOffset))
            }
        }.onAppear {
            self.dealCards()
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
                HStack {
                    self.deck
                    Spacer()
                }
                .frame(maxHeight: 100)
                //                .background(Color.yellow)


                Text("Score: \(game.points)")
                    .multilineTextAlignment(.trailing)
                //                    .background(Color.blue)
            }
        }
        .padding([.leading, .trailing])
        //        .background(Color.green)
    }

    // TODO: - Don't hardcode the offset
    @ViewBuilder
    var deck: some View {
        if game.dealtCards.first != nil {
            ZStack {
                ForEach(0..<4) { index in
                    CardView(card: self.game.dealtCards.first!, side: .Back)
                        .rotationEffect(.degrees(90))
                        .offset(x: 20, y: -10 + CGFloat((4 - index) * 5))
                }
            }
        } else {
            EmptyView()
        }
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
