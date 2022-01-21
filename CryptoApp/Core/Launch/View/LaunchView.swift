//
//  LaunchView.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 21/01/22.
//

import SwiftUI

struct LaunchView: View {
    //mapping a single string into an array of string
    @State private var loadingText: [String] = "Loading your portfolio...".map{String($0)}
    @State private var showLoadingText: Bool = false
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            //we want the logo exactly on the middle of the screen and hence we are using offset to put the loadingText below the logo
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) { //spacing = 0 because the text looks dumb
                        ForEach(loadingText.indices) {index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.accent)
                                .offset(y: counter == index ? -5 : 0) //to move up little bit
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 70) //actually loadingText is in middle but we use offset to bring it down
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                let lastIndex = loadingText.count - 1 //count starts at 1, index at 0
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false //end the launch screen
                    }
                } else {
                    counter += 1
                }
                
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
