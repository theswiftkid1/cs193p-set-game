//
//  CardView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/13/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var card: GameModel.Card

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.init(red: 10 / 255, green: 132 / 255, blue: 255 / 255), lineWidth: 4)
            .padding()
    }
}
