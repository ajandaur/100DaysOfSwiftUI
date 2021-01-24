//
//  PlayView.swift
//  DiceRoll
//
//  Created by Anmol  Jandaur on 1/20/21.
//

import SwiftUI

struct PlayView: View {
    
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
    }
    // Let the user customize the dice that are rolled: how many of them, and what type: 4-sided, 6-sided, 8-sided, 10-sided, 12-sided, 20-sided, and even 100-sided.
    
    @Environment(\.managedObjectContext) var moc
    
    // MARK: - Static properties
    
    // MARK: - Private properties
    
    //    @State private var diceSelection = 0
    @State private var sideSelection = 0
    
    @State private var diceOne: Int = 0
    @State private var diceTwo: Int = 0
    
    private let numberOfSides = ["4","6","8","10","12","20","100"]
    private let diceMaxValues = [4,6,8,10,12,20,100]
    
    @State private var date = Date()
    
    //    private let numberOfDice = ["1","2","3","4","5","6"]
    
    var body: some View {

        GeometryReader { proxy in
            VStack {
                //                HStack {
                //                    Text("Dice").font(.caption)
                //                    Spacer()
                //                    Picker(selection: self.$diceSelection, label: Text("Number of Dice")) {
                //                        ForEach(0..<self.numberOfDice.count) {
                //                            Text("\(self.numberOfDice[$0])")
                //                        }
                //                    }
                //                    .pickerStyle(SegmentedPickerStyle())
                //                    .frame(maxWidth: proxy.size.width * 0.8)
                //
                //                }
                //                .padding()
                
                HStack {
                    Text("Sides").font(.caption)
                    Spacer()
                    Picker(selection: self.$sideSelection, label: Text("Number of Sides")) {
                        ForEach(0..<self.numberOfSides.count) {
                            Text("\(self.numberOfSides[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: proxy.size.width * 0.8)
                    
                }
                .padding()
                
                HStack {
                    if self.diceOne == 0 {
                        Image(systemName: "questionmark.square")
                            .font(.largeTitle)
                            .padding()
                        
                        Image(systemName: "questionmark.square")
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Image(systemName: "\(self.diceOne).square")
                            .font(.largeTitle)
                            .padding()
                        
                        Image(systemName: "\(self.diceTwo).square")
                            .font(.largeTitle)
                            .padding()
                    }
                }
                .padding()
                
                Text("You rolled a \(self.diceOne + diceTwo)")
                    .font(.headline)
                    .padding()
                
                Button(action: {
                                    
                                    for i in 1...10 {
                                        DispatchQueue.main.asyncAfter(deadline: .now()+(0.3 / Double(i))) {
                                            self.diceOne = Int.random(in: 1...self.diceMaxValues[self.sideSelection])
                                            self.diceTwo = Int.random(in: 1...self.diceMaxValues[self.sideSelection])
                                            
                                            print(self.diceOne, self.diceTwo)
                                        }
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.31) {
                                        print("Saving...")
                                        print(self.diceOne, self.diceTwo)
                                     
                                        // save the results
                                        let newRoll = CoreDataRoll(context: self.moc)
                                        newRoll.totalSum = Int16(diceOne + diceTwo)
                                        newRoll.date = date
                                        
                                        try? self.moc.save()
                                    }
                                    
                                    
                                }) {
                    Text("Roll")
                }
                .accentColor(Color.white)
                                    .frame(minWidth: 220, maxWidth: 220)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .padding()
                
            } // VStack
        }
        
        
        
        
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}
