//
//  ContentView.swift
//  BetterRest
//
//  Created by Anmol  Jandaur on 9/10/20.
//  Copyright © 2020 Anmol  Jandaur. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    // Default wake up time at & am
    // This is a static var, making it belong to the Content View struct itself rather than a single instacne of that struct
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("when do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep"))
                {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                    .accessibility(value: Text("\(sleepAmount) hours desired" ))
                }
                
                Section(header: Text("Daily coffee intake"))
                {
                    Picker("Daily coffee intake", selection: $coffeeAmount)
                    {
                        ForEach(1 ..< 21) {
                            Text($0 == 1 ? "1 cup" : "\($0) cups" )
                        }
                    }.labelsHidden()
                        .pickerStyle(WheelPickerStyle())
                    
                }
                
                Section(header: Text("Your best sleep time is:"))
                {
                    Text(calculateBedtime())
                }
                
          
            }
            .navigationBarTitle("BetterRest")
        }
    }
    
    func calculateBedtime() -> String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            // prediction contains how much sleep we actually need
            // we want to convert seconds int time the user should go to bed
            // subtract value in seconds from time they need to wake up
            let sleepTime = wakeUp - prediction.actualSleep
            
            // sleepTime is a Date, put it in a presentable string using DateFormatter
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
        } catch {
            return "There has been an error calculating your bedtime, sorry!"
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
