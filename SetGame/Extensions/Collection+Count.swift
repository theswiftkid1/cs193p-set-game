//
//  Collection+Count.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/14/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import Foundation

extension Collection {
    func count(_ predicate: (Element) throws -> Bool) rethrows -> Int {
        return try(self.filter(predicate)).count
    }
}
