//
//  SetGameApp.swift
//  SetGame
//
//  Created by theswiftkid_ on 9/26/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

@main
struct SetGameApp: App {
    var body: some Scene {
        WindowGroup {
            let game = GameViewModel()
            GameView(game: game)
        }
    }
}
