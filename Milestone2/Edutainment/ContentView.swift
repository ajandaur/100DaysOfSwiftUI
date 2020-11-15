//
//  ContentView.swift
//  Edutainment
//
//  Created by Anmol  Jandaur on 11/12/20.
//

import SwiftUI


//The player needs to select which multiplication tables they want to practice. This could be pressing buttons, or it could be an “Up to…” stepper, going from 1 to 12

//The player should be able to select how many questions they want to be asked: 5, 10, 20, or “All”.

//You should randomly generate as many questions as they asked for, within the difficulty range they asked for. For the “all” case you should generate all possible combinations.


struct ContentView: View {
    @State private var answers = [String]()
    @State private var answer = ""
    
    @State private var questions = [String]()
    @State private var currentQuestion = 0
    
    private var numberOfQuestions = ["5","10","20","All"]
    @State private var numberOfQuestionSelected = 0
    
    
    @State private var correctAnswers = 0
    @State private var numberOfTables = 0
    
    
    
    
    @State private var gameisRunning = false
    @State private var displayAnswers = false
    
    
    var body: some View {
        NavigationView {
            Form {
                if (!gameisRunning) {
                    Group {
                        // asking the user for settings
                        Text("Select the number of tables")
                            .font(.headline)
                        
                        Stepper(value: $numberOfTables, in: 1...12) {
                            Text("\(numberOfTables)")
                        }
                        
                        Text("Select the number of questions: ")
                            .font(.headline)
                        
                        // Picker to decide the number of questions to ask
                        Picker(selection: $numberOfQuestionSelected, label: Text("\(numberOfQuestions[numberOfQuestionSelected])")) {
                            ForEach(0..<numberOfQuestions.count) {
                                Text(self.numberOfQuestions[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                    }
                    
                }
                
            } // Form
            
            .navigationBarTitle(Text("Multiplication Table"))
            
            // nav bar button to start the game
            .navigationBarItems(trailing: Button(action: {
                self.startGame()
            }) {
                Text("Start Game")
            })
            
        } // NavigationView
        
    } // body
    
    // function to start a new game
    func startGame() {
        questions.removeAll()
        answers.removeAll()
        correctAnswers = 0
        
    }
} // content view



struct Question {
    var tableNumber: Int
    var multipler: Int
    
    var questionText: String {
        return "What is \(tableNumber) x \(multipler) ?"
    }
    
    var answer: String {
        return String(tableNumber * multipler)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
