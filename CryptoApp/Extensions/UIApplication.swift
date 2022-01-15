//
//  UIApplication.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 15/01/22.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        //dismissing the keyboard on taping x in search bar
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
