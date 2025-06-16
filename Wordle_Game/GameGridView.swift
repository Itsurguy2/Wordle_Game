//
//  GameGridView.swift
//  Wordle_Game
//
//  Created by Jesse Rosenthal on 6/15/25.
//

import SwiftUI
import Foundation 


struct GameGridView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(0..<6, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(0..<5, id: \.self) { column in
                        LetterCell(
                            letter: gameState.gameBoard[row][column],
                            state: gameState.letterStates[row][column]
                        )
                    }
                }
            }
        }
        .padding(.horizontal)
        .alert("Game Alert", isPresented: $gameState.showingAlert) {
            Button("OK") {
                if gameState.gameOver {
                    gameState.resetGame()
                }
            }
        } message: {
            Text(gameState.alertMessage)
        }
    }
}

struct LetterCell: View {
    let letter: Character
    let state: LetterState
    
    var backgroundColor: Color {
        switch state {
        case .empty:
            return Color.clear
        case .filled:
            return Color.gray.opacity(0.3)
        case .correct:
            return Color.green
        case .wrongPosition:
            return Color.yellow
        case .notInWord:
            return Color.gray
        }
    }
    
    var borderColor: Color {
        switch state {
        case .empty:
            return Color.gray.opacity(0.5)
        default:
            return Color.clear
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .overlay(
                    Rectangle()
                        .stroke(borderColor, lineWidth: 2)
                )
                .frame(width: 60, height: 60)
            
            Text(String(letter))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .animation(.easeInOut(duration: 0.3), value: state)
    }
}
