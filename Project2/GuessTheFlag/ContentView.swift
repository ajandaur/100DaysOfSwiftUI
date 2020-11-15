//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Anmol  Jandaur on 8/28/20.
//  Copyright © 2020 Anmol  Jandaur. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // If you are changing properties of a view, you need to mark it with @State
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland","Italy","Nigeria","Poland","Russia","Spain","UK","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var incorrectAnswer: Int?
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    // Challenge: when you tap the correct flag, make it spin around 360 degrees on the Y axis.
    @State private var spinYaxis = 0.0
    @State private var buttonTapped = 0
    
    // Challenge: Make the other two buttons fade out to 25% opacity
    @State private var opacity = 1.0
    
    // Challenge: what if you tap the wrong flag?
    @State private var isCorrect = true
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                    
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(image: self.countries[number])
                    }
                    // Challenge 1
                    .rotation3DEffect(.degrees(self.spinYaxis),axis: (x: 0, y: self.correctAnswer == number ? 1: 0, z:0))
                    // Challenge 2
                    .animation(Animation.easeOut).opacity(self.correctAnswer != number ? self.opacity : 1.0)
                    .animation(Animation.interpolatingSpring(stiffness: 5, damping: 1)).scaleEffect(!self.isCorrect && self.buttonTapped == number ? 0.5 : 1.0)
                }
                VStack {
                    Text("Score: \(userScore)")
                        .foregroundColor(.white)
                        .font(.title)
                }
                
                Spacer()
                
            }
        }
            //end of outer Z-Stack
            
            
            .alert(isPresented: $showingScore) {
                if scoreTitle == "Correct" {
                    return Alert(title: Text(scoreTitle), message: Text("Good Job! \nYour score is \(userScore)"), dismissButton:
                        .default(Text("Continue")) {
                            self.askQuestion()
                        })
                } else {
                    return Alert(title: Text(scoreTitle), message: Text("Wrong! That's the flag of \(countries[incorrectAnswer!]) \nYour score is \(userScore)"), dismissButton:
                        .default(Text("Continue")) {
                            self.askQuestion()
                        })
                }
        }
    }
    
    // when user tap a flag
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 10
            self.buttonTapped = number
            withAnimation {
                self.spinYaxis += 360
                self.opacity -= 0.75
            }
            self.spinYaxis = 0
        } else {
            scoreTitle = "Wrong"
            userScore -= 10
            incorrectAnswer = number
            self.buttonTapped = number
            withAnimation {
                self.isCorrect.toggle()
            }
        }
        showingScore = true
    }
    
    // reset the game after each flag question
    func askQuestion() {
        isCorrect = true
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        self.opacity = 1.0
    }
    
}

struct FlagImage: View {
    
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black,lineWidth: 2))
            .shadow(color: .black, radius: 2)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
