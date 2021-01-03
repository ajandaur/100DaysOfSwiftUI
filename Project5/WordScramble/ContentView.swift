//
//  ContentView.swift
//  WordScramble
//
//  Created by Anmol  Jandaur on 9/16/20.
//  Copyright © 2020 Anmol  Jandaur. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]() {
        // use didSet to execute code when a property has just been set
        didSet {
            calculateScore()
        }
    }
    @State private var rootWord = ""
    @State private var newWord = ""
    
    // Challenge 3: Calculate the score depending on length of word and number of words
    @State private var score = 0

    func calculateScore() {
        switch usedWords[0].count {
        case 8:
            score += 80
        case 7:
            score += 70
        case 6:
            score += 60
        case 5:
            score += 50
        case 4:
            score += 40
        default:
            score += 30
        }
        
        switch usedWords.count {
        case 5:
            score += 50
        case 10:
            score += 100
        case 15:
            score += 150
        case 20:
            score += 400
        default:
            score += 0
        }
    }
    
    
    // vars for error alert
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    // f(x) to check if the word was already used
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    // f(x) to check whether a random word can be made out of the letters of another randon word
    func isPossible(word: String) -> Bool {
        // create a variable copy of the root wrod
        var tempWord = rootWord
        // loop over each letter of user's input and see if that letter exists in tempWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                // if it does exist, remove it from the copy, then continue
                tempWord.remove(at: pos)
            } else {
                // if there is a letter that the copy doesn't have, return false
                return false
            }
        }
        return true
    }
    
    // use UITextChecker to scan for possibly misspelled words
    func isReal(word: String) -> Bool {
        
        // Challenge 1: disallow answers that are shorter than three letters or just the start word
        if (word.count < 3)  {
            return false
        }
        
        if (word.count == 3 && rootWord.hasPrefix(word)) {
            return false
        }
        
        let checker = UITextChecker()
        // in order to bridge Swift strings to Objective-C strings safely, create an instance of NSRange
        let range = NSRange(location: 0, length: word.utf16.count)
        // call rangeOfMisspelledWords() on text checker to look for wrong words
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    // f(x) to set title and message based on parameters it recieves + flips showingError to true
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    // f(x) to addo our entry to the list of used words
    func addNewWord()
    {
        // lowercase newWord and remove whitespaces
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // check that it has at least 1 character otherwise exit
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "The word must be a real word longer than 3 letters and not just the start word")
            return
        }
        // insert that word at position 0 in the usedWords array
        usedWords.insert(answer, at: 0)
    
        
        // reset the answer field
        newWord = ""
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "/n")
                // 4. Pick one random word or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // If we are here everything has worked, exit func
                return
            }
        }
        
        // if there is a problem, a crash is triggered
        //
        fatalError("Cound not load start.txt")
    }
    
    var body: some View {
        // NavigationView showing words they aer spelling from
        NavigationView {
            VStack {
                // where users enter answer
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                List(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                    // MARK: Accessibilty modification to group items into a single group where children are ignored by VoiceOver and label is added
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))
                }
                
                // Challenge 3: put a text view below the List so you can track and show player's score for given root word
                Text("Score \(score)")
                Spacer()
            }
            .navigationBarTitle(rootWord)
                
                //Challenge 2 - add left button to start new game
                .navigationBarItems(leading: Button(action: startGame)
                {Text("Start New Game") })
                .onAppear(perform: startGame)
                .alert(isPresented: $showingError) {
                    Alert(title: Text(errorTitle), message: Text(errorMessage))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
