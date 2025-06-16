//
//  KeyboardView.swift
//  Wordle_Game
//
//  Created by Jesse Rosenthal on 6/15/25.
//

import Foundation
import SwiftUI

struct KeyboardView: View {
    @ObservedObject var gameState: GameState
    
    let keyboardRows = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["ENTER", "Z", "X", "C", "V", "B", "N", "M", "DELETE"]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<keyboardRows.count, id: \.self) { rowIndex in
                HStack(spacing: 6) {
                    ForEach(keyboardRows[rowIndex], id: \.self) { key in
                        KeyboardKey(
                            key: key,
                            state: getKeyState(for: key),
                            onTap: { tappedKey in
                                handleKeyTap(tappedKey)
                            }
                        )
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    private func getKeyState(for key: String) -> LetterState {
        if key == "ENTER" || key == "DELETE" {
            return .empty
        }
        
        guard let firstChar = key.first else { return .empty }
        return gameState.keyboardStates[firstChar] ?? .empty
    }
    
    private func handleKeyTap(_ key: String) {
        switch key {
        case "ENTER":
            gameState.submitWord()
        case "DELETE":
            gameState.deleteLastCharacter()
        default:
            if let letter = key.first {
                gameState.addLetter(letter)
            }
        }
    }
}

struct KeyboardKey: View {
    let key: String
    let state: LetterState
    let onTap: (String) -> Void
    
    @State private var isPressed = false
    
    var backgroundColor: Color {
        switch state {
        case .empty:
            return Color.gray.opacity(0.4)
        case .filled:
            return Color.gray.opacity(0.4)
        case .correct:
            return Color.green
        case .wrongPosition:
            return Color.yellow
        case .notInWord:
            return Color.gray.opacity(0.8)
        }
    }
    
    var keyWidth: CGFloat {
        switch key {
        case "ENTER", "DELETE":
            return 60
        default:
            return 35
        }
    }
    
    var body: some View {
        Button(action: {
            onTap(key)
        }) {
            Text(keyDisplayText)
                .font(.system(size: key.count > 1 ? 12 : 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: keyWidth, height: 40)
                .background(backgroundColor)
                .cornerRadius(6)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var keyDisplayText: String {
        switch key {
        case "DELETE":
            return "⌫"
        default:
            return key
        }
    }
}
