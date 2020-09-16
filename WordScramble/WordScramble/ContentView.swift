//
//  ContentView.swift
//  WordScramble
//
//  Created by Anmol  Jandaur on 9/16/20.
//  Copyright © 2020 Anmol  Jandaur. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    // f(x) to addo our entry to the list of used words
    func addNewWord()
    {
        // lowercase newWord and remove whitespaces
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        // check that it has at least 1 character otherwise exit
        guard answer.count > 0 else {
            return
        }
        // insert that word at position 0 in the usedWords array
        usedWords.insert(answer, at: 0)
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
        
            }
        }
        
        // if there is a problem, a crash is triggered
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
                
                List(usedWords, id: \.self) {
                    Text($0)
                }
            }
            .navigationBarTitle(rootWord)
        .onAppear(perform: startGame)
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
