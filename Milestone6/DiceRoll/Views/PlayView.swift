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
    
    // color array for dice
    private let colors = [Color.red, Color.blue, Color.green, Color.purple, Color.pink]
    
    
    // MARK: HAPTICS
    
    var haptics = Haptics()
    
    // Let the user customize the dice that are rolled: how many of them, and what type: 4-sided, 6-sided, 8-sided, 10-sided, 12-sided, 20-sided, and even 100-sided.
    
    @Environment(\.managedObjectContext) var moc

    // MARK: - Private properties
    
    @State private var diceOne: Int = 0
    @State private var diceTwo: Int = 0
    @State private var diceThree: Int = 0
    
    
    @State private var sideSelection = 0
    private let numberOfSides = ["4","6","8","10","12","20","100"]
    private let sidesMaxValue = [4,6,8,10,12,20,100]
    
    @State private var diceSelection = 0
    private let numberOfDice = ["1","2","3"]
    private let diceMaxValue = [1,2,3]
    
    // rotation Amount
    @State private var rotateAnimationAmount = Double(Int.random(in: -8...8))
    
    // CONSTANTS
    private var fontResultSize = 35
    private var widthValue: CGFloat = 250
    private var opacityValue = 0.8
    private var cornerRadiusValue: CGFloat = 10
    
    
    
    func selectDie(at number: Int) -> Int {
        switch number {
        case 1:
            return self.diceOne
        case 2:
            return self.diceTwo
        case 3:
            return self.diceThree
        default:
            return self.diceOne
        }
    }
    
    func countTotal(at number: Int) -> Int16 {
        switch number {
        case 1:
            return Int16(self.diceOne)
        case 2:
            return Int16(self.diceOne + diceTwo)
        case 3:
            return Int16(self.diceOne + self.diceTwo + self.diceThree)
        default:
            return Int16(0)
            
        }
    }
    
    func saveData() {
        // save the results
        let newResult = Result(context: self.moc)
        newResult.id = UUID()
        newResult.date = Date()
        newResult.totalResult = countTotal(at: self.diceMaxValue[diceSelection])
        
        // go through each of the die and save them to the newResult
        for i in 1...self.diceMaxValue[diceSelection] {
            
            // create new die
            let newDie = CoreDataRoll(context: self.moc)
            
            // date
            newDie.date = Date()
            
            // ID
            newDie.id = UUID()
            
            // number on die
            newDie.totalSum = Int16(selectDie(at: i))
            
            // number of sides
            newDie.numberOfSides = Int16(sidesMaxValue[sideSelection])
            
            newResult.addToDice(newDie)
            
        }
        newResult.numberOfDice = Int16(diceMaxValue[diceSelection])
        
        // haptic success activated
        haptics.complexSuccess()
        
        do {
            try self.moc.save()
        } catch {
            print("Error with save to Core Data")
        }

    }
    
    
    
    var body: some View {
        
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    HStack {
                        Text("Dice").font(.caption)
                        Spacer()
                        Picker(selection: self.$diceSelection, label: Text("Number of Dice")) {
                            ForEach(0..<self.numberOfDice.count) {
                                Text("\(self.numberOfDice[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: proxy.size.width * 0.8)
                        
                        // accessibility
                        .accessibility(label: Text("select the number of dice"))
                        
                        
                    }
                    .padding()
                    
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
                        
                        // accessibility
                        .accessibility(label: Text("select the number of sides ond ice"))
                    }
                    .padding()
                    
                    HStack {
                        // The .id(: \.self) part is required so that SwiftUI can identify each element in the array uniquely
                        
                        ForEach((1...self.diceMaxValue[diceSelection]), id: \.self) { number in
                            DieView(die: self.selectDie(at: number), width: 100, height: 100, cornerRadius: 25, backgroundColor: colors.randomElement() ?? Color.primary)
                        }
                        // animation
                        .animation(.easeInOut)
                    }
               
                    Spacer()
                    
                    Text("You rolled a \(self.countTotal(at: self.diceMaxValue[diceSelection]))")
                        .font(Font.system(size: CGFloat(fontResultSize), weight: .heavy, design: .default))
                    
                        Spacer()
            
                    
                    Button(action: {
                        
                        for i in 1...10 {
                            DispatchQueue.main.asyncAfter(deadline: .now()+(0.3 / Double(i))) {
                                
                                self.diceOne = Int.random(in: 1...self.sidesMaxValue[self.sideSelection])
                                
                                self.diceTwo = Int.random(in: 1...self.sidesMaxValue[self.sideSelection])
                                
                                self.diceThree = Int.random(in: 1...self.sidesMaxValue[self.sideSelection])
                                
                                print(self.diceOne, self.diceTwo, self.diceThree)
                                
                                // prepare haptics
                                haptics.prepare()
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.31) {
                            print("Saving...")
                            print(self.diceOne, self.diceTwo, self.diceThree)
                            
                            // save the data
                          saveData()
                        }
                        
                    }) {
                        Text("Roll")
                    }
                    .accentColor(Color.white)
                    .frame(minWidth: widthValue, maxWidth: widthValue)
                    .padding()
                    .background(Color.blue.opacity(opacityValue))
                    .cornerRadius(cornerRadiusValue)
                    .padding()
                    .font(.headline)
                    
                } // VStack
            } // GeometryReader
            
            .navigationBarTitle((Text("Dice Roll")))
        } // NavigationView
        
     
        .navigationViewStyle(StackNavigationViewStyle())
    } // Body 
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}
