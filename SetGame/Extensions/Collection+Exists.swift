//
//  Collection+Exists.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/23/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import Foundation

extension Collection {
    func exists(_ element: (Element) throws -> Bool) rethrows -> Bool {
        try self.firstIndex(where: element) != nil
    }
}
