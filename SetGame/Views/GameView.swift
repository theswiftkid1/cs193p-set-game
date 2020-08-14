//
//  GameView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("SET")
                Spacer()
                Text(String(self.viewModel.points))
                Spacer()
            }
            .font(.title)

            ZStack {
                Grid(items: viewModel.dealtCards) { card in
                    CardView(card: card)
                        .scaleEffect(card.isSelected ? 1.15 : 1)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                self.viewModel.pickCard(card: card)
                            }
                    }
                    .transition(.offset(self.randomOffset))
                }
                .padding()
            }.onAppear {
                self.newGame()
            }

            HStack {
                Spacer()
                makeActionButton(text: "New Game", action: self.newGame)
                Spacer()
                makeActionButton(text: "Deal More Cards", action: self.dealMoreCards)
                Spacer()
            }
        }
    }

    func makeActionButton(text: String,
                          action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .font(.headline)
                .foregroundColor(Color.black)
                .padding()
                .overlay(buttonOverlay)
        }

    }

    private var buttonOverlay: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 3)
            .foregroundColor(Color.blue)
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

    // TODO: - Use AnimatableModifier to make a custom animation, which is triggered
    // when the previous animation is finished
    private func newGame() {
        withAnimation(Animation.easeIn(duration: 0.5)) {
            self.viewModel.clearGame()
        }
        withAnimation(Animation.easeOut.delay(0.5)) {
            self.viewModel.dealCards()
        }
    }

    private func dealMoreCards() {
        withAnimation(.easeOut(duration: 0.5)) {
            self.viewModel.dealCards(3)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GameViewModel()
        return GameView(viewModel: model)
    }
}
