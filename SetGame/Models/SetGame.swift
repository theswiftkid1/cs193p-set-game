//
//  SetGame.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import Foundation
import SwiftUI

struct SetGame {
    private(set) var cards: [Card]

    struct Card: Identifiable {
        var id: Int
        var color: UIColor
        var number: Int
        var shape: String
        var shading: String
    }


    init() {
        cards = [Card(id: 1, color: UIColor.init(), number: 1, shape: "Circle", shading: "Plain")]
    }

}
