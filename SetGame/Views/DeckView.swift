//
//  DeckView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/24/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct DeckView: View {
    var numberOfCards: Int
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 2
    private let spacing: Int = 5
    private var displayedNumberOfCards: Int {
        numberOfCards > 4 ? 4 : numberOfCards
    }

    var body: some View {
        ZStack {
            ForEach(0..<self.displayedNumberOfCards) { index in
                CardBackView(
                    cornerRadius: self.cornerRadius,
                    edgeLineWidth: self.edgeLineWidth
                )
                    .offset(
                        x: 0 + CGFloat((self.displayedNumberOfCards - index) * self.spacing),
                        y: 0
                )
            }
            .frame(maxWidth: UIScreen.main.bounds.width,
                   maxHeight: UIScreen.main.bounds.width)
            .rotationEffect(.degrees(90))

            Image(systemName: "sparkles")
                .font(.largeTitle)
        }
        .offset(x: 0, y: 0 - CGFloat(self.displayedNumberOfCards * self.spacing / 2))
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(numberOfCards: 4)
    }
}
