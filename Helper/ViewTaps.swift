//
//  ViewTaps.swift
//  Toe
//
//  Created by apple on 2023/9/3.
//

import Foundation
import SwiftUI

struct TapGestureModifier: ViewModifier {
    let onTapStart: () -> Void
    let onTapEnd: () -> Void

    func body(content: Content) -> some View {
        content
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    onTapStart()
                }
                .onEnded { _ in
                    onTapEnd()
                }
            )
    }
}

extension View {
    func onTapGesture(onTapStart: @escaping () -> Void, onTapEnd: @escaping () -> Void) -> some View {
        modifier(TapGestureModifier(onTapStart: onTapStart, onTapEnd: onTapEnd))
    }
}

