//
//  ContentView.swift
//  UnitConverter
//
//  Created by Anmol  Jandaur on 9/1/20.
//  Copyright © 2020 Anmol  Jandaur. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // create input TextField set to 1 and set picker set to first conversion option on the far left
    @State private var inputNum = "1"
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    
    // choices for picker
    var lengths = ["meters", "kilometers", "feet", "yards", "miles"]
    
    // computed property to obtain the correct conversion
    var conversion: Measurement<UnitLength> {
        let startingUnit = lengths[inputUnit]
        let endingUnit = lengths[outputUnit]
        let userInput = Double(inputNum)
        
        var measurement: Measurement<UnitLength>
        var convertedMeasurement: Measurement<UnitLength> = Measurement(value: 1, unit: UnitLength.meters)
        
        // create Measurement instance using switch statement for starting Unit
        switch startingUnit {
        case "meters":
            measurement = Measurement(value: userInput ?? 0,unit: UnitLength.meters)
        case "kilometers":
            measurement = Measurement(value: userInput ?? 0,unit: UnitLength.meters)
        case "feet":
            measurement = Measurement(value: userInput ?? 0,unit: UnitLength.meters)
        case "yards":
            measurement = Measurement(value: userInput ?? 0,unit: UnitLength.meters)
        case "miles":
            measurement = Measurement(value: userInput ?? 0,unit: UnitLength.meters)
        default:
            measurement = Measurement(value: 1,unit: UnitLength.meters)
        }
        
        // Do the actual conversion depending on case for startingUnit
        switch endingUnit {
        case "meters":
            convertedMeasurement = measurement.converted(to: UnitLength.meters)
        case "kilometers":
            convertedMeasurement = measurement.converted(to: UnitLength.kilometers)
        case "feet":
            convertedMeasurement = measurement.converted(to: UnitLength.feet)
        case "yards":
            convertedMeasurement = measurement.converted(to: UnitLength.yards)
        case "miles":
            convertedMeasurement = measurement.converted(to: UnitLength.miles)
        default:
            break
        }
        return convertedMeasurement
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("What is the unit of the beginning length?")) {
                    Picker("Units of Length", selection: $inputUnit.animation()) {
                        ForEach(0 ..< lengths.count) {
                            Text("\(self.lengths[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("How many units?")) {
                    TextField("Number to convert", text: $inputNum.animation())
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("What is the unit of the end length?")) {
                    Picker("Units of Length", selection: $outputUnit.animation()) {
                        ForEach(0 ..< lengths.count) {
                            Text("\(self.lengths[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                // Output the answer
                Section(header: Text("The result is: ")) {
                    Text("\(self.conversion.value, specifier: "%.3f")")
                }
            }.navigationBarTitle("Length Conversion")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
