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
    @State var deckViewData: DeckViewData = DeckViewData()

    struct DeckViewData {
        var deckPositionX: CGFloat = 0
        var deckPositionY: CGFloat = 0
        var deckCardSize: CGSize = CGSize(width: 0, height: 0)
        var deckContainerHeight: CGFloat = 0
        var deckContainerWidth: CGFloat = 0
    }

    let disabledButtonColor = Color.gray
    let newGameButtonColor = Color.blue
    let cheatButtonColor = Color(red: 52 / 255, green: 199 / 255, blue: 89 / 255)

    var body: some View {
        VStack(alignment: .center) {
            if self.game.isGameOver {
                self.endGame
                    .transition(
                        .asymmetric(
                            insertion: AnyTransition.scale(scale: 10).animation(.spring()),
                            removal: AnyTransition.opacity.animation(.easeIn(duration: 1))
                        )
                )
            } else {
                self.topBar
                self.board.zIndex(1)
                self.bottomBar
            }
        }
    }

    // MARK: - END GAME

    var endGame: some View {
        EndGame()
    }

    // MARK: - BOARD

    var board: some View {
        Grid(self.game.dealtCards) { card, index, layout in
            self.card(card: card, index: index, layout: layout)
        }.onAppear {
            self.dealCards()
        }
    }

    @State var scale: CGFloat = 1

    func card(card: GameModel.Card, index: Int, layout: GridLayout) -> some View {
        CardView(card: card)
            .scaleEffect(scale)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.game.pickCard(card: card)
                }
        }
        .onAppear {
            withAnimation(Animation.easeOut(duration: 1)) {
                self.game.flipCard(card: card)
                let deckArea = self.deckViewData.deckCardSize.width * self.deckViewData.deckCardSize.height
                self.scale = deckArea / (layout.itemSize.height * layout.itemSize.width)
            }
        }

        .transition(AnyTransition.asymmetric(
            insertion: dealCard(
                cardPositionX: layout.location(ofItemAt: index).x,
                cardPositionY: layout.location(ofItemAt: index).y,
                cardHeight: layout.itemSize.height,
                cardWidth: layout.itemSize.width,
                boardHeight: layout.size.height
            ),
            removal: .offset(self.randomOffset)
        ))
    }

    private func dealCard(cardPositionX: CGFloat,
                          cardPositionY: CGFloat,
                          cardHeight: CGFloat,
                          cardWidth: CGFloat,
                          boardHeight: CGFloat) -> AnyTransition {
        let deckArea = self.deckViewData.deckCardSize.width * self.deckViewData.deckCardSize.height

        return AnyTransition.offset(self.deckOffset(
                cardPositionX: cardPositionX,
                cardPositionY: cardPositionY,
                boardHeight: boardHeight
            ))
//            .combined(with: AnyTransition.scale(
//                scale: deckArea / (cardHeight * cardWidth)
//            ))
    }

    private func deckOffset(cardPositionX: CGFloat,
                            cardPositionY: CGFloat,
                            boardHeight: CGFloat) -> CGSize { // layout.size.height
        print("-----------------")
        print("DECK Y \(self.deckViewData.deckPositionY)")
        print("CARD Y \(cardPositionY)")
        print("UI BOUNDS \(UIScreen.main.bounds.size.height)")
        print("DECK CONTAINER HEIGHT \(self.deckViewData.deckContainerHeight)")
        print("BOARD HEIGHT Y \(boardHeight)")
//                print("GRID HEIGHT \(layout.size.height)")
//        print("Offset \((self.deckViewData.deckPositionY - cardPositionY) - (UIScreen.main.bounds.size.height - self.deckViewData.deckContainerHeight - boardHeight)) ")
        return CGSize(
            width: (self.deckViewData.deckPositionX - cardPositionX),
            height: (self.deckViewData.deckPositionY - cardPositionY) - (UIScreen.main.bounds.size.height - self.deckViewData.deckContainerHeight - boardHeight)
        )
    }

    private var randomOffset: CGSize {
        let screenSize: CGSize = UIScreen.main.bounds.size
        let screenSide: [CGFloat] = [-1, 1]

        let x: CGFloat = .random(in: screenSize.width..<screenSize.width * 1.5) * screenSide.randomElement()!
        let y: CGFloat = .random(in: screenSize.height..<screenSize.height * 1.5) * screenSide.randomElement()!

        return CGSize(width: x, height: y)
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
            self.makeActionButton(text: "New Game", action: self.newGame, borderColor: self.newGameButtonColor)

            Spacer()

            GeometryReader { geo in
                DeckView(numberOfCards: self.game.deckCardsNumber)
                    .onAppear {
                        self.deckViewData = DeckViewData(
                            deckPositionX: geo.frame(in: .global).midX,
                            deckPositionY: geo.frame(in: .global).midY,
                            deckCardSize: geo.frame(in: .global).size,
                            deckContainerHeight: geo.frame(in: .named("bottomBar")).height,
                            deckContainerWidth: geo.frame(in: .named("bottomBar")).width
                        )
                    }
                    .onTapGesture {
                        self.deckViewData = DeckViewData(
                            deckPositionX: geo.frame(in: .global).midX,
                            deckPositionY: geo.frame(in: .global).midY,
                            deckCardSize: geo.frame(in: .global).size,
                            deckContainerHeight: geo.frame(in: .named("bottomBar")).height,
                            deckContainerWidth: geo.frame(in: .named("bottomBar")).width
                        )
                        self.dealMoreCards()
                }
            }
            .frame(minWidth: 100, minHeight: 100)

            Spacer()

            self.makeActionButton(text: "Cheat",
                                  action: self.dealMoreCards,
                                  borderColor: self.game.deckCardsNumber == 0 ? self.disabledButtonColor : self.cheatButtonColor)
                .disabled(self.game.deckCardsNumber == 0)
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
