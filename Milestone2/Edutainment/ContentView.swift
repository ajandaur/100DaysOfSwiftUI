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
    @State private var questions = [Question]()
    

    private var numberOfQuestions = ["5","10","20","All"]
    @State private var questionSelectedIndex = 0
    @State private var numberOfTables = 0
    @State private var gameisRunning = false
    
    
    
    var body: some View {
        if !gameisRunning {
            NavigationView {
                Form {
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
                        Picker(selection: $questionSelectedIndex, label: Text("\(numberOfQuestions[questionSelectedIndex])")) {
                            ForEach(0..<numberOfQuestions.count) {
                                Text(self.numberOfQuestions[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                    }
                } // Form
                .navigationBarTitle(Text("Game Settings"))
                
                // nav bar button to start the game
                .navigationBarItems(trailing: Button(action: {
                    self.startGame()
                }) {
                    Text("Start Game")
                })
                
                
            } // NavigationView
        } else {
            MainGameView(gameIsRunning: $gameisRunning, numberOfQuestions: Int(numberOfQuestions[questionSelectedIndex]) ?? 10, questions: questions)
        }
    } // body
    
    // function to start a new game
    func startGame() {
        // create question bank
        createQuestions()
        // change the view to start game
        gameisRunning = true
    }
    
    // generate all the questions depending on user input of numberOfTables
    func createQuestions() {
        for i in 1 ... numberOfTables {
            for j in 1 ... numberOfTables {
                let question = Question(text: "\(i) x \(j)", answer: "\(i * j)")
                questions.append(question)
            }
        }
    }
    
    
} // content view


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
