//
//  Color.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 14/12/21.
//

import Foundation
import SwiftUI


extension Color {
    
    static let theme = ColorTheme()
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let red = Color("RedColor")
    let green = Color("GreenColor")
    let secondaryText = Color("SecondaryTextColor")
}
