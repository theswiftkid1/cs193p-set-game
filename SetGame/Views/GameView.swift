//
//  GameView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct DeckViewModifier: ViewModifier {
    var geometry: GeometryProxy

    func body(content: Content) -> some View {
        let frame = self.geometry.frame(in: CoordinateSpace.local)
        let size = CGSize(width: frame.origin.x - 0, height: frame.origin.y - 100)
        return content.offset(size)
    }
}

extension AnyTransition {
    static func dealFromDeck(geometry: GeometryProxy) -> AnyTransition {
        .modifier(
            active: DeckViewModifier(geometry: geometry),
            identity: DeckViewModifier(geometry: geometry)
        )
    }
}

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

    // MARK: - END GAME

    var endGame: some View {
        EndGame()
    }

    // MARK: - GAME

    var gameTable: some View {
        VStack {
            ZStack {
                GeometryReader { geoProxy in
                    Grid(items: self.game.dealtCards) { card in
                        CardView(card: card)
                            .padding([.bottom])
                            .scaleEffect(card.isSelected ? 1.10 : 1)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    self.game.pickCard(card: card)
                                }
                        }
                        .transition(.asymmetric(
                            insertion: .offset(self.deckOffset(geo: geoProxy)),
                            removal: .offset(self.randomOffset)
                            )
                        )
                            .onAppear {
                                withAnimation(Animation.easeOut(duration: 1)) {
                                    self.flipCard(card: card)
                                }
                        }
                    }
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

            deck
                .aspectRatio(contentMode: .fill)
                .onTapGesture {
                    self.dealMoreCards()
            }

            makeActionButton(text: "Cheat",
                             action: self.dealMoreCards,
                             borderColor: game.deckCardsNumber == 0 ? disabledButtonColor : Color(red: 52 / 255, green: 199 / 255, blue: 89 / 255))
                .disabled(game.deckCardsNumber == 0)
        }
        .frame(maxHeight: 50)
        .padding()
    }

    // MARK: - ACTIONS

    func flipCard(card: GameModel.Card) {
        self.game.flipCard(card: card)
    }

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

    private func deckOffset(geo: GeometryProxy) -> CGSize {
        return CGSize(width: geo.size.width, height: geo.size.height)
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
