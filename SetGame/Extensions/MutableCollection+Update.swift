//
//  Collection+Update.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/23/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import Foundation

extension MutableCollection {
    mutating func updateAll(_ update: (inout Element) -> Void) {
        for index in indices {
            update(&self[index])
        }
    }
}
