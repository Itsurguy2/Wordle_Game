//
//  GameState.swift
//  Wordle_Game
//
//  Created by Jesse Rosenthal on 6/15/25.
//

import SwiftUI
import Foundation

// MARK: - Letter State Enum
enum LetterState {
    case empty
    case filled
    case correct
    case wrongPosition
    case notInWord
}

// MARK: - Game State
class GameState: ObservableObject {
    @Published var currentRow = 0
    @Published var currentColumn = 0
    @Published var gameBoard: [[Character]] = Array(repeating: Array(repeating: " ", count: 5), count: 6)
    @Published var letterStates: [[LetterState]] = Array(repeating: Array(repeating: .empty, count: 5), count: 6)
    @Published var keyboardStates: [Character: LetterState] = [:]
    @Published var gameOver = false
    @Published var hasWon = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    private let wordGenerator = WordGenerator()
    private var targetWord: String
    
    init() {
        self.targetWord = wordGenerator.getRandomWord().uppercased()
        print("Target word: \(targetWord)") // For debugging
    }
    
    func addLetter(_ letter: Character) {
        guard !gameOver && currentColumn < 5 else { return }
        
        gameBoard[currentRow][currentColumn] = letter
        letterStates[currentRow][currentColumn] = .filled
        currentColumn += 1
    }
    
    func deleteLastCharacter() {
        guard !gameOver && currentColumn > 0 else { return }
        
        currentColumn -= 1
        gameBoard[currentRow][currentColumn] = " "
        letterStates[currentRow][currentColumn] = .empty
    }
    
    func submitWord() {
        guard currentColumn == 5 else {
            showAlert("Not enough letters")
            return
        }
        
        let currentWord = String(gameBoard[currentRow])
        
        // Check if word is valid (you could add dictionary check here)
        checkWord(currentWord)
        
        if currentWord == targetWord {
            hasWon = true
            gameOver = true
            showAlert("You won! 🎉")
        } else if currentRow == 5 {
            gameOver = true
            showAlert("Game Over! The word was \(targetWord)")
        } else {
            currentRow += 1
            currentColumn = 0
        }
    }
    
    private func checkWord(_ word: String) {
        let targetArray = Array(targetWord)
        let wordArray = Array(word)
        var targetLetterCounts = [Character: Int]()
        
        // Count letters in target word
        for letter in targetArray {
            targetLetterCounts[letter, default: 0] += 1
        }
        
        // First pass: mark correct positions
        for i in 0..<5 {
            if wordArray[i] == targetArray[i] {
                letterStates[currentRow][i] = .correct
                keyboardStates[wordArray[i]] = .correct
                targetLetterCounts[wordArray[i]]! -= 1
            }
        }
        
        // Second pass: mark wrong positions and not in word
        for i in 0..<5 {
            if letterStates[currentRow][i] != .correct {
                if let count = targetLetterCounts[wordArray[i]], count > 0 {
                    letterStates[currentRow][i] = .wrongPosition
                    if keyboardStates[wordArray[i]] != .correct {
                        keyboardStates[wordArray[i]] = .wrongPosition
                    }
                    targetLetterCounts[wordArray[i]]! -= 1
                } else {
                    letterStates[currentRow][i] = .notInWord
                    if keyboardStates[wordArray[i]] == nil {
                        keyboardStates[wordArray[i]] = .notInWord
                    }
                }
            }
        }
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
    
    func resetGame() {
        // Generate new word
        targetWord = wordGenerator.getRandomWord().uppercased()
        print("New target word: \(targetWord)") // For debugging
        
        // Reset all game state
        currentRow = 0
        currentColumn = 0
        gameBoard = Array(repeating: Array(repeating: " ", count: 5), count: 6)
        letterStates = Array(repeating: Array(repeating: .empty, count: 5), count: 6)
        keyboardStates = [:]
        gameOver = false
        hasWon = false
        showingAlert = false
        alertMessage = ""
    }
}
