//
//  LaunchScreenView.swift
//  Wordle_Game
//
//  Created by Jesse Rosenthal on 6/15/25.
//

import Foundation
import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var scale = 0.8
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // App Icon Grid (mini Wordle grid)
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            ForEach(0..<5) { _ in
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(width: 12, height: 12)
                                    .cornerRadius(2)
                            }
                        }
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(Color.yellow)
                                .frame(width: 12, height: 12)
                                .cornerRadius(2)
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 12, height: 12)
                                .cornerRadius(2)
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 12, height: 12)
                                .cornerRadius(2)
                            Rectangle()
                                .fill(Color.yellow)
                                .frame(width: 12, height: 12)
                                .cornerRadius(2)
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 12, height: 12)
                                .cornerRadius(2)
                        }
                    }
                    .scaleEffect(scale)
                    .opacity(opacity)
                    
                    Text("WORDLE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    opacity = 1.0
                    scale = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}
