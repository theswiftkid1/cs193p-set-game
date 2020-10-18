//
//  Squiggle.swift
//  SetGame
//
//  Created by theswiftkid_ on 10/17/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct Squiggle: Shape {

    private let xOffset1: CGFloat = 0.05
    private let yOffset1: CGFloat = 0.2
    private let xOffset2: CGFloat = 0.2
    private let controlOffset: CGFloat = 0.3

    func path(in rect: CGRect) -> Path {
        let height = rect.maxX - rect.minX
        let width = rect.maxY - rect.minY

        // MARK: Corners

        let bottomLeft = CGPoint(
            x: rect.minX + width * xOffset1,
            y: rect.maxY - height * yOffset1
        )
        let topLeft = CGPoint(
            x: rect.minX + width * xOffset2,
            y: rect.minY + height * yOffset1
        )
        let topRight = CGPoint(
            x: rect.maxX - width * xOffset1,
            y: rect.minY + height * yOffset1
        )
        let bottomRight = CGPoint(
            x: rect.maxX - width * xOffset2,
            y: rect.maxY - height * yOffset1
        )

        // MARK: Control Top

        let controlTop1 = CGPoint(
            x: topLeft.x + (topRight.x - topLeft.x) / 2,
            y: topLeft.y + height * controlOffset
        )
        let controlTop2 = CGPoint(
            x: topLeft.x + (topRight.x - topLeft.x) / 2,
            y: topLeft.y - height * controlOffset
        )

        // MARK: Control Bottom

        let controlBottom1 = CGPoint(
            x: bottomLeft.x + (bottomRight.x - bottomLeft.x) / 2,
            y: bottomLeft.y - height * controlOffset
        )
        let controlBottom2 = CGPoint(
            x: bottomLeft.x + (bottomRight.x - bottomLeft.x) / 2,
            y: bottomLeft.y + height * controlOffset
        )

        // MARK: Path

        var path = Path()
        path.move(to: topRight)
        path.addLine(to: bottomRight)
        path.addCurve(to: bottomLeft, control1: controlBottom1, control2: controlBottom2)
        path.addLine(to: topLeft)
        path.addCurve(to: topRight, control1: controlTop1, control2: controlTop2)
        return path
    }
}

struct Squiggle_Previews: PreviewProvider {
    static var previews: some View {
        Squiggle()
            .frame(width: 200, height: 300, alignment: .center)
    }
}
