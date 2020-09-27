//
//  CardBackView.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/24/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct CardBackView: View {
    var cornerRadius: CGFloat
    var edgeLineWidth: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(Color.gray)

            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color.black, lineWidth: edgeLineWidth)
        }
        .aspectRatio(2/3, contentMode: ContentMode.fit)
    }
}

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        CardBackView(cornerRadius: 10, edgeLineWidth: 4)
    }
}
