//
//  GameView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var model: GameViewModel
    @State var scale: CGFloat = 1

    var body: some View {
        VStack {
            Text("SET")
                .font(.largeTitle)

            ZStack {
                Grid(items: model.dealtCards) { card in
                    CardView(card: card).onTapGesture {
                        self.model.pickCard(card: card)
                    }
                    .transition(.offset(self.randomOffset))
                }
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

        let x: CGFloat = .random(in: screenSize.width..<screenSize.width * 2) * screenSide.randomElement()!
        let y: CGFloat = .random(in: screenSize.height..<screenSize.height * 2) * screenSide.randomElement()!

        return CGSize(width: x, height: y)
    }

    private var randomDelay: Double {
        return Double.random(in: 0...1)
    }

    private func newGame() {
        withAnimation(Animation.linear(duration: 2)) {
            self.model.newGame()
        }
    }

    private func dealMoreCards() {
        withAnimation(.easeInOut(duration: 3)) {
            self.model.dealCards()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GameViewModel()
        return GameView(model: model)
    }
}
