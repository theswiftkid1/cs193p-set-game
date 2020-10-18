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
            if game.isGameOver {
                endGame
                    .transition(
                        .asymmetric(
                            insertion: AnyTransition.scale(scale: 10).animation(.spring()),
                            removal: AnyTransition.opacity.animation(.easeIn(duration: 1))
                        )
                    )
            } else {
                topBar
                board.zIndex(1)
                bottomBar
            }
        }
    }

    // MARK: - END GAME

    var endGame: some View {
        EndGame()
    }

    // MARK: - BOARD

    var board: some View {
        Grid(game.dealtCards) { card, index, layout in
            buildCardView(card: card, index: index, layout: layout)
        }.onAppear {
            dealCards()
        }
    }

    func buildCardView(card: GameModel.Card,
                       index: Int,
                       layout: GridLayout) -> some View {
        CardView(card: card)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.1)) {
                    game.pickCard(card: card)
                }
            }
            .onAppear {
                withAnimation(Animation.easeOut(duration: 1)) {
                    game.flipCard(card: card)
                }
            }
            .padding([.bottom])
            .transition(AnyTransition.asymmetric(
                insertion: dealCardTransition(
                    cardPositionX: layout.location(ofItemAt: index).x,
                    cardPositionY: layout.location(ofItemAt: index).y,
                    cardHeight: layout.itemSize.height,
                    cardWidth: layout.itemSize.width,
                    boardHeight: layout.size.height
                ),
                removal: .offset(randomOffset)
            ))
    }

    private func dealCardTransition(cardPositionX: CGFloat,
                                    cardPositionY: CGFloat,
                                    cardHeight: CGFloat,
                                    cardWidth: CGFloat,
                                    boardHeight: CGFloat) -> AnyTransition {
        return AnyTransition.offset(findDeckOffset(
            cardPositionX: cardPositionX,
            cardPositionY: cardPositionY,
            boardHeight: boardHeight
        ))
    }

    private func findDeckOffset(cardPositionX: CGFloat,
                            cardPositionY: CGFloat,
                            boardHeight: CGFloat) -> CGSize {
        print("-----------------")
        print("DECK Y \(deckViewData.deckPositionY)")
        print("CARD Y \(cardPositionY)")
        print("UI BOUNDS \(UIScreen.main.bounds.size.height)")
        print("DECK CONTAINER HEIGHT \(deckViewData.deckContainerHeight)")
        print("BOARD HEIGHT Y \(boardHeight)")
        //          print("GRID HEIGHT \(layout.size.height)")
        //        print("Offset \((deckViewData.deckPositionY - cardPositionY) - (UIScreen.main.bounds.size.height - deckViewData.deckContainerHeight - boardHeight)) ")
        return CGSize(
            width: (deckViewData.deckPositionX - cardPositionX),
            height: (deckViewData.deckPositionY - cardPositionY) -
                (UIScreen.main.bounds.size.height - deckViewData.deckContainerHeight - boardHeight)
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
            makeActionButton(
                text: "New Game",
                borderColor: newGameButtonColor
            ) {
                newGame()
            }

            Spacer()

            GeometryReader { geo in
                DeckView(numberOfCards: game.deckCardsNumber)
                    .onAppear {
                        deckViewData = DeckViewData(
                            deckPositionX: geo.frame(in: .global).midX,
                            deckPositionY: geo.frame(in: .global).midY,
                            deckCardSize: geo.frame(in: .global).size,
                            deckContainerHeight: geo.frame(in: .named("bottomBar")).height,
                            deckContainerWidth: geo.frame(in: .named("bottomBar")).width
                        )
                    }
                    .onTapGesture {
                        deckViewData = DeckViewData(
                            deckPositionX: geo.frame(in: .global).midX,
                            deckPositionY: geo.frame(in: .global).midY,
                            deckCardSize: geo.frame(in: .global).size,
                            deckContainerHeight: geo.frame(in: .named("bottomBar")).height,
                            deckContainerWidth: geo.frame(in: .named("bottomBar")).width
                        )
                        dealCards(numberOfCards: 3)
                    }
            }
            .frame(minWidth: 100, minHeight: 100)

            Spacer()

            makeActionButton(
                text: "Cheat",
                borderColor: game.deckCardsNumber == 0 ? disabledButtonColor : cheatButtonColor
            ) {
                dealCards(numberOfCards: 12)
            }
                .disabled(game.deckCardsNumber == 0)
        }
        .coordinateSpace(name: "bottomBar")
        .frame(maxWidth: .infinity, maxHeight: 70)
        .padding([.leading, .trailing])
    }


    func makeActionButton(text: String,
                          borderColor: Color,
                          action: @escaping () -> Void) -> some View {
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

    // MARK: - ACTIONS

    private func dealCards(numberOfCards: Int = 12) {
        withAnimation(Animation.easeOut(duration: 0.5)) {
            game.dealCards(numberOfCards)
        }
    }

    // TODO: - Use AnimatableModifier to make a custom animation, which is triggered
    // when the previous animation is finished
    private func newGame() {
        withAnimation(.easeIn(duration: 0.5)) {
            game.clearGame()
        }
        dealCards()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GameViewModel()
        return GameView(game: model)
    }
}
