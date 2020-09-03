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
    @State var deckPosition: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)

    let disabledButtonColor = Color.gray

    var body: some View {
        VStack(alignment: .center) {
            if self.game.isGameOver {
                self.endGame
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: AnyTransition.scale(scale: 10).animation(.spring()),
                            removal: AnyTransition.opacity.animation(.easeIn(duration: 1))
                        )
                )
            } else {
                self.topBar
                self.board
                self.bottomBar
            }
        }.overlay(
            ZStack {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 10, height: 10)
                    .position(x: self.deckPosition.minX, y: self.deckPosition.minY)
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 10, height: 10)
                    .position(x: self.deckPosition.minX, y: self.deckPosition.maxY)
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 10, height: 10)
                    .position(x: self.deckPosition.maxX, y: self.deckPosition.minY)
                Circle()
                    .foregroundColor(.yellow)
                    .frame(width: 10, height: 10)
                    .position(x: self.deckPosition.maxX, y: self.deckPosition.maxY)
            }.edgesIgnoringSafeArea(.all)
        )
    }

    // MARK: - END GAME

    var endGame: some View {
        EndGame()
    }

    // MARK: - GAME

    var board: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Grid(self.game.dealtCards) { card, index, layout in
                        CardView(card: card)
                            .padding([.bottom])
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    self.game.pickCard(card: card)
                                }
                        }
                        .onAppear {
                            withAnimation(Animation.easeOut(duration: 1)) {
                                self.game.flipCard(card: card)
                            }
                        }
                        .transition(AnyTransition.asymmetric(
                            insertion: AnyTransition.offset(self.deckOffset(
                                layout.location(ofItemAt: index).x,
                                layout.location(ofItemAt: index).y
                            )),
                            removal: AnyTransition.offset(self.randomOffset)
                        ))
                            .edgesIgnoringSafeArea(.all)
                    }
                }.onAppear {
                    self.dealCards()
                }
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

            HStack {
                Text("Score: \(game.points)")
                    .bold()
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding([.leading, .trailing])
    }

    // MARK: - BOTTOM BAR

    var bottomBar: some View {
        HStack {
            self.makeActionButton(text: "New Game", action: self.newGame)
                        .aspectRatio(contentMode: .fill)

            GeometryReader { geo in
            DeckView(numberOfCards: self.game.deckCardsNumber)
//                .frame(width: 100, height: 100, alignment: .center)
                .onTapGesture {
                    print("Red \(self.deckPosition.minX), \(self.deckPosition.minY) ")
                    print("Blue \(self.deckPosition.minX), \(self.deckPosition.maxY) ")
                    print("Green \(self.deckPosition.maxX), \(self.deckPosition.minY) ")
                    print("Yellow \(self.deckPosition.maxX), \(self.deckPosition.maxY) ")
                    self.dealMoreCards()
                }
                .onAppear {
                    self.deckPosition = geo.frame(in: CoordinateSpace.global)
                }
            }.aspectRatio(contentMode: .fit)



            self.makeActionButton(text: "Cheat",
                             action: self.dealMoreCards,
                             borderColor: self.game.deckCardsNumber == 0 ? self.disabledButtonColor : Color(red: 52 / 255, green: 199 / 255, blue: 89 / 255))
                .disabled(self.game.deckCardsNumber == 0)
        }
        .frame(maxHeight: 50)
        .padding()

    }

    // MARK: - ACTIONS

    func makeActionButton(text: String,
                          action: @escaping () -> Void,
                          borderColor: Color = Color.blue) -> some View {
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
            .padding([.top, .bottom])
        }
    }

    private func buttonOverlay(borderColor: Color) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(borderColor, lineWidth: 3)
            .foregroundColor(borderColor)
    }

    private func deckOffset(_ cardPositionX: CGFloat, _ cardPositionY: CGFloat) -> CGSize {
                print("Card position \(cardPositionX), \(cardPositionY) ")
        print("Deck position \(self.deckPosition.minX), \(self.deckPosition.minY) ")
        print("Offset \(-cardPositionX + self.deckPosition.minX), \(-cardPositionY + self.deckPosition.minY) ")
                print("-------")
        return CGSize(
            width: -cardPositionX + self.deckPosition.minX,
            height: -cardPositionY + self.deckPosition.minY
        )
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
        withAnimation(Animation.easeOut(duration: 1)) {
            self.game.dealCards(1)
        }

        //        dealCards(numberOfCards: 1)
        //        dealCards(numberOfCards: 1, delay: 0.5)
        //        dealCards(numberOfCards: 1, delay: 1)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GameViewModel()
        return GameView(game: model)
    }
}
