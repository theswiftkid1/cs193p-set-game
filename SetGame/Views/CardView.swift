//
//  CardView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/13/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var card: SetGame.Card

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.init(red: 10, green: 132, blue: 255), lineWidth: 2)
        )
            .foregroundColor(.init(red: 0, green: 122, blue: 255))
            .aspectRatio(contentMode: .fit)
            .padding()

    }
}
