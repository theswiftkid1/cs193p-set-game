//
//  EndGame.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/23/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct EndGame: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Congratulations! 🎉")
                .font(.largeTitle)
            Spacer()
        }
        .transition(
            .asymmetric(
                insertion: AnyTransition.scale(scale: 10).animation(.spring()),
                removal: AnyTransition.opacity.animation(.easeIn(duration: 1))
            )
        )
    }
}

struct EndGame_Previews: PreviewProvider {
    static var previews: some View {
        EndGame()
    }
}
