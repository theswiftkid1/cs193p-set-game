//
//  Diamond.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/19/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addLines([
            CGPoint(x: rect.midX, y: rect.maxY),
            CGPoint(x: rect.minX, y: rect.midY),
            CGPoint(x: rect.midX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.midY),
            CGPoint(x: rect.midX, y: rect.maxY)
        ])

        return path
    }
}
