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
    // user selects number of times tables
    @State private var numberOfTables = 0
    
    // store the question bank
    @State private var questions = [Question]()
    // question counter
    @State private var questionCounter = 0
    // choose the number of questions to ask
    private var amountOfQuestions = ["5","10","20","All"]
    // index that the user chos for amountOfQuestions
    @State private var questionSelectedIndex = 0
    // Turn string from amountOfQuestions to a number
    @State private var numberOfQuestions = 0
    
    
    // go between settings and game mode
    @State private var gameisRunning = true
    // display when game is over
    @State private var gameOver = false
    
    
    @State private var answer = ""
    @State private var score = 0
    @State var totalQuestions = 0
    
    
    @State private var currentQuestion = Question(tableNumber: 1, multiplier: 1)
    @State private var currentQuestionIndex = 0
    
    
    
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
                        Picker(selection: $questionSelectedIndex, label: Text("\(amountOfQuestions[questionSelectedIndex])")) {
                            ForEach(0..<amountOfQuestions.count) {
                                Text(self.amountOfQuestions[$0])
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
            NavigationView{
                VStack(alignment: .center, spacing: 0) {
                    // Question
                    Text(currentQuestion.question)
                        .font(.headline)
                        .padding()
                    
                    // User input
                    TextField("Answer", text: $answer)
                        .padding(5)
                        .multilineTextAlignment(.center)
                        .font(Font.system(size: 15, weight: .medium, design: .monospaced))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2))
                        .keyboardType(.decimalPad)
                        .padding()
                    
                    // button to check answer and load next question
                    Button(action: {
                        // check
                        self.checkAnswer()
                        // next question
                        self.nextQuestion()
                        // clear answer
                        answer = ""
                        
                        
                    }) {
                        Text("Submit")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(40)
                            .foregroundColor(.white)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.red, lineWidth: 5)
                            )
                    }
                    Spacer()
                    Text("Score \(score)")
                    Text("Questions remaining: \(numberOfQuestions - questionCounter)")
                    Spacer()
                    
                }
                .padding()
                .navigationBarTitle(Text("Multiplication Game"))
                .padding(.leading)
                .padding(.trailing)
                .navigationBarItems(trailing: Button(action: {
                    withAnimation {
                        gameisRunning.toggle()
                    }
                }) {
                    Text("Settings")
                }
                )
                
                // game over alert
                .alert(isPresented: $gameOver) {
                    Alert(title: Text("Game Over!"), message: Text("Your score: \(score)"), dismissButton: .default(Text("Continue")) {
                        withAnimation {
                            gameisRunning.toggle()
                        }
                        
                    })
                }
            } //NavigationView
        }
    } // body
    
    // function to start a new game
    func startGame() {
        // create question bank
        createQuestions()
        // load questions
        nextQuestion()
        // change the view to start game
        gameisRunning.toggle()
    }
    
    // generate all the questions depending on user input of numberOfTables
    func createQuestions() {
        // reset counter
        questionCounter = 0
        // remove the questions from last game
        questions.removeAll()
        score = 0 // reset score
        totalQuestions = 0 // reset total number of questions
        for i in 1 ... numberOfTables {
            for j in 1 ... numberOfTables {
                let question = Question(tableNumber: i, multiplier: j)
                questions.append(question)
            }
        }
        //shuffle the questions
        questions.shuffle()
        
        numberOfQuestions = Int(amountOfQuestions[questionSelectedIndex]) ?? questions.count
    }
    
    func nextQuestion()
    {
        if questionCounter < numberOfQuestions
        {
            currentQuestion = questions[questionCounter % questions.count]
            
            questionCounter += 1
            
            
        } else {
            gameOver.toggle()
        }
    }
    
    func checkAnswer()
    {
        let correctAnswer = currentQuestion.answer
        if (answer == correctAnswer)
        {
            score += 1
        } else {
            score -= 1
        }
    }
    
    
} // content view


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
