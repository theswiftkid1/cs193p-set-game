//
//  Array+Identifiable.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/10/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(of element: Element) -> Int? {
        for index in 0..<self.count {
            if (self[index].id == element.id) {
                return index
            }
        }
        return nil
    }
}
