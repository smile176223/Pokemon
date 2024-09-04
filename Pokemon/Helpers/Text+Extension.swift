//
//  Text+Extension.swift
//  Pokemon
//
//  Created by Liam on 2024/9/4.
//

import SwiftUI

struct ThemeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16).bold())
            .padding([.top, .bottom], 4)
    }
}

extension View {
    func themeTextStyle() -> some View {
        self.modifier(ThemeTextStyle())
    }
}
