//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 14/12/21.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView{
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle()) //for ipad we need this
                .environmentObject(vm)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2) //this zstack is always on the top of navigation view, just so that while we're transitioning off of the screen, we still see the transition it doesn't go and hide behind the navigation view.
            }
        }
    }
}
