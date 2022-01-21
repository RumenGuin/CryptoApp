//
//  Color.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 14/12/21.
//

import Foundation
import SwiftUI
//color codes
/*
 //pink/accent -FACFFC
 //bg = white, black
 //green - light- 008F00, dark- 73FA79
 //red = light- 941651 , dark- FF2F92
 //secondary- light- 919191, dark- C0C0C0
 */

extension Color {
    
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let red = Color("RedColor")
    let green = Color("GreenColor")
    let secondaryText = Color("SecondaryTextColor")
}

struct LaunchTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
