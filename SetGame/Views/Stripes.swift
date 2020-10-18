//
//  Stripes.swift
//  SetGame
//
//  Created by theswiftkid_ on 10/18/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct Stripes: Shape {
    var stripesDistance: Int = 10
    var incline: Int = 0

    func path(in rect: CGRect) -> Path {
        let maxX = rect.maxX * 2
        let maxY = rect.maxY * 2
        let numberOfStripes = Int(maxX / CGFloat(stripesDistance))
        var path = Path()
        for i in 0...numberOfStripes {
            let x = i * stripesDistance * 2
            let start = CGPoint(x: x + incline, y: 0)
            let end = CGPoint(x: CGFloat(x - incline), y: maxY)
            path.move(to: start)
            path.addLine(to: end)
        }
        return path
    }
}

struct Stripes_Previews: PreviewProvider {
    static var previews: some View {
        let stripeWidth: CGFloat = 20
        Stripes(stripesDistance: 20, incline: 20)
            .stroke(lineWidth: stripeWidth)
    }
}
