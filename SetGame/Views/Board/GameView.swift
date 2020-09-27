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
    @State var deckData: DeckData = DeckData(deckCardsNumber: 4)

    var body: some View {
        VStack(alignment: .center) {
            if game.isGameOver {
                EndGame()
            } else {
                TopBar(points: game.points)
                board
                BottomBar(game: game, deckData: $deckData)
            }
        }
    }

    // MARK: - BOARD

    let layout = [
        GridItem(.adaptive(minimum: 70))
    ]

    var board: some View {
        ScrollView {
            LazyVGrid(columns: layout, spacing: 20) {
                ForEach(game.dealtCards, id:\.self) { card in
                    buildCardView(card: card)
                }
            }
            .onAppear {
                dealCards()
            }
        }
    }

    @State var cardSelection: Bool = false

    func cardTransition() -> AnyTransition {
        print("NOT Selected Transition")
        return AnyTransition.asymmetric(
            insertion: dealCardTransition(
                cardPositionX: 50,
                cardPositionY: 50,
                boardHeight: 100
            ),
            removal: .identity
        )
    }

    @ViewBuilder
    func buildCardView(card: GameModel.Card) -> some View {
        if card.isFaceUp == false {
            CardView(card: card)
                .transition(cardTransition())
                .onTapGesture {
                    game.flipCard(card: card)
                    game.pickCard(card: card)
                }
        } else {
            CardView(card: card)
                .transition(.identity)
                .scaleEffect(card.isSelected ? 1.10 : 1)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 1)) {
                        game.pickCard(card: card)
                    }
                }
        }
    }

    struct CardFlipModifier: ViewModifier {
        let yAmount: Double
        let zAmount: Double

        func body(content: Content) -> some View {
            content
                .rotation3DEffect(Angle.degrees(yAmount), axis: (0,1,0))
                .rotation3DEffect(Angle.degrees(zAmount), axis: (0,0,1))
        }
    }

    private func dealCardTransition(cardPositionX: CGFloat,
                                    cardPositionY: CGFloat,
                                    boardHeight: CGFloat) -> AnyTransition {
        //        let deckArea = deckData.deckCardSize.width * deckData.deckCardSize.height
        //            .combined(with: AnyTransition.scale(
        //                scale: deckArea / (cardHeight * cardWidth)
        //            ))

        return AnyTransition.offset(deckOffset(
            cardPositionX: cardPositionX,
            cardPositionY: cardPositionY,
            boardHeight: boardHeight
        )).combined(with: .modifier(
            active: CardFlipModifier(yAmount: 180, zAmount: 90),
            identity: CardFlipModifier(yAmount: 0, zAmount: 0)
        ))
    }

    private func deckOffset(cardPositionX: CGFloat,
                            cardPositionY: CGFloat,
                            boardHeight: CGFloat) -> CGSize { // layout.size.height
        //        print("-----------------")
        //        print("DECK Y \(self.deckData.deckPositionY)")
        //        print("CARD Y \(cardPositionY)")
        //        print("UI BOUNDS \(UIScreen.main.bounds.size.height)")
        //        print("DECK CONTAINER HEIGHT \(self.deckData.deckContainerHeight)")
        //        print("BOARD HEIGHT Y \(boardHeight)")
        //                print("GRID HEIGHT \(layout.size.height)")
        //        print("Offset \((self.deckData.deckPositionY - cardPositionY) - (UIScreen.main.bounds.size.height - self.deckData.deckContainerHeight - boardHeight)) ")
        return CGSize(
            width: (deckData.deckPositionX - cardPositionX),
            height: (deckData.deckPositionY - cardPositionY) - (UIScreen.main.bounds.size.height - deckData.deckContainerHeight - boardHeight)
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
            game.dealCards(numberOfCards)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GameViewModel()
        return GameView(game: model)
    }
}
