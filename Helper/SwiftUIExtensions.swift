//
//  SwiftUIExtensions.swift
//  Relic
//
//  Created by apple on 2024/1/19.
//

import Foundation
import SwiftUI


extension View{
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
