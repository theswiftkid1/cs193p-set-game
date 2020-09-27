//
//  View+Cardify.swift
//  SetGame
//
//  Created by theswiftkid_ on 8/24/20.
//  Copyright © 2020 theswiftkid. All rights reserved.
//

import SwiftUI

extension View {
    func cardify() -> some View {
        return self.modifier(Cardify())
    }
}
