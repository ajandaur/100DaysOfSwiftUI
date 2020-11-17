//
//  MainGameView.swift
//  Edutainment
//
//  Created by Anmol  Jandaur on 11/17/20.
//

import SwiftUI

struct MainGameView: View {
    @Binding var gameIsRunning: Bool
    
    var numberOfQuestions: Int
    @State var questions = [Question]()
    
    @State private var answer = ""
    @State private var score = 0
    @State private var displayAnswers = false
    @State private var answerResult = ""
    
    @State private var currentQuestion = Int.random(in: 0...11)
    @State private var currentQuestionIndex = 0
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 0) {
              
                Text("\(questions[currentQuestion].text)")
                    .font(.largeTitle)
                
                
                TextField("Answer:", text: $answer) {
                    print("Answer inputted")
                }
                .keyboardType(.numberPad)
                
                Button("Enter") {
                    self.checkAnswer(answer: answer)
                    self.answer = ""
                }
                .font(.headline)
                
                Text("Questions left: \(numberOfQuestions)")
                Text("Current Score: \(score)")
            }
            .padding()
            .navigationBarTitle(Text("Multiplication Game"))
        } //NavigationView
    } // body
    
    
    func checkAnswer(answer: String)
    {
        let correctAnswer = questions[currentQuestionIndex].answer
        if (answer == correctAnswer)
        {
            score += 1
            answerResult = "Correct!"
        } else {
            score -= 1
            answerResult = "Wrong!"
        }
    }
}

struct MainGameView_Previews: PreviewProvider {
    @State static var gameIsRunning = true
    @State static var questions = [Question]()
    static var previews: some View {

        MainGameView(gameIsRunning: $gameIsRunning, numberOfQuestions: 1, questions: questions)
    }
}
