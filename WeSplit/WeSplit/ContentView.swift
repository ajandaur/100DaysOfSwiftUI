//
//  WeSplitView.swift
//  WeSplit
//
//  Created by Anmol  Jandaur on 8/27/20.
//  Copyright © 2020 Anmol  Jandaur. All rights reserved.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    // SwiftUI must use strings to store text field values
    
    // Sychronizatio happens because
    // 1. Text field has two-way binding to the checkAmount
    // 2. checkAmount property is marked with @State which automatically watches for changes in the value --> re-invoke the body property
    @State private var checkAmount = ""
    @State private var numberOfPeople = "2"
    @State private var tipPercentage = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        // nil-colaescing is awesome and sweet!!
        let people = Double(numberOfPeople) ?? 2
        let peopleCount = people > 0 ? people : 2
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount * (tipSelection / 100)
        let grandTotal = orderAmount + tipValue
        return grandTotal / peopleCount
    }
    
    var totalAmountWithCheck: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount * (tipSelection / 100)
        let grandTotal = orderAmount + tipValue
        return grandTotal
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text(verbatim: "Enter number of people sharing bill:")) {
                    TextField("Number of people", text: $numberOfPeople)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Section(header: Text("Total amount")) {
                    Text("$\(totalAmountWithCheck, specifier: "%.2f")")
                        .foregroundColor(tipPercentages[tipPercentage] == 0 ? Color.red : Color.white)
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            } // end of Form
            // navigation views are capable of showing many views, want it INSIDE the navigation view to allow iOS to change titles freely
            .navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


