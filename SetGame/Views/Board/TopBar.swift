//
//  TopBar.swift
//  SetGame
//
//  Created by theswiftkid_ on 9/27/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct TopBar: View {
    @State var points: Int

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Set Card Game")
                    .font(.system(size: 22))
                    .bold()
                Spacer()
            }

            HStack {
                Text("Score: \(points)")
                    .bold()
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding([.leading, .trailing])
    }
}
