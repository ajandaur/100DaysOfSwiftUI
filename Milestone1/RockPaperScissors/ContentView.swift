//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Anmol  Jandaur on 9/6/20.
//  Copyright © 2020 Anmol  Jandaur. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var possibleMoves = ["🧗🏽‍♀️ Rock", "📃 Paper", "✂️ Scissors"]
    @State private var computerChoice = Int.random(in: 0...2)
    @State private var userMove = 1
    @State private var needtoWin = false
    @State private var score = 0
    @State private var roundOutcome = "Win"
    
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.green, .blue, .purple]), center: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    needtoWin ? Text("You need to win this game")
                        .font(.title)
                        .foregroundColor(.white)
                        
                        : Text("You need to lose this game")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Opponent: \(possibleMoves[computerChoice])")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0 ..< possibleMoves.count) { move in
                    Button(action: {
                        self.userMove(answer: move)
                    }) {
                        Text(self.possibleMoves[move])
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                
                VStack {
                    Text("Score: \(score)")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                VStack {
                    Text("Results: \(roundOutcome)") .foregroundColor(.red)
                                           .font(.title)
                                           
                }
            }
        }
    }
    
    func userMove(answer move: Int)
    {
        userMove = move
        
        //  thing A beats thing B if it’s one place to the right of it, taking into account wrapping around the end of the array. So, paper (position 1) beats rock (position 0), scissors (position 2) beats paper (position 1), and scissors (position 2) beats paper (wrap around to position 0. You go the other way for losing.
        
        guard possibleMoves[userMove] != possibleMoves[computerChoice] else {
            roundOutcome = "Draw"
            return
        }
        
        var playingRegularGame = false
        
        switch userMove {
        case 0:
            playingRegularGame = computerChoice == 1 ? false : true
        case 1:
            playingRegularGame = computerChoice == 2 ? false : true
        default:
            playingRegularGame = computerChoice == 0 ? true : false
        }
        
 
        
        if playingRegularGame == true && needtoWin {
            roundOutcome = "Win"
            score += 1
        } else if playingRegularGame == true && !needtoWin {
            roundOutcome = "Lose"
            score -= 1
        } else if playingRegularGame == false && !needtoWin {
            roundOutcome = "Win"
            score += 1
        } else if playingRegularGame == false && needtoWin  {
            roundOutcome = "Lose"
            score -= 1
        }
        
        
        // set bool for next time
        needtoWin = Bool.random()
        
        // new computer choice for next time
        computerChoice = Int.random(in: 0 ... 2)
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
