//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 14/12/21.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
