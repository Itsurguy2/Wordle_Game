//
//  ContentView.swift
//  Wordle_Game
//
//  Created by Jesse Rosenthal on 6/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("WORDLE")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            // Game Grid
            GameGridView(gameState: gameState)
            
            Spacer()
            
            // Keyboard
            KeyboardView(gameState: gameState)
            
            // New Game Button
            Button("New Game") {
                gameState.resetGame()
            }
            .foregroundColor(.white)
            .font(.headline)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.bottom, 20)
        }
        .background(Color.black)
        .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
