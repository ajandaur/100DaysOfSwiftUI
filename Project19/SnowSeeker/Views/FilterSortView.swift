//
//  FilterSortView.swift
//  SnowSeeker
//
//  Created by Anmol  Jandaur on 1/21/21.
//

import SwiftUI

struct FilterSortView: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    // filtering
    private let countries = ["All", "United States", "Italy", "France", "Canada", "Austria"]
    private let sizes = ["All", "Small", "Average", "Large"]
    private let prices = ["All", "$", "$$", "$$$"]
    
    
    // @Binding is for: it lets us create a property in the add user view that says “this value will be provided from elsewhere, and will be shared between us and that other place.”
    
    @Binding  var filterCountry: String
    @Binding  var filterSize: Int
    @Binding  var filterPrice: Int
    
    
    // dismiss function
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select country for filtering: ")) {
                    Picker(selection: $filterCountry, label: Text("Select country for filtering: ")) {
                        ForEach(countries) { country in
                            Text("\(country)")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(Color.red)
                }
                Section(header: Text("Select size for filtering")) {
                    Picker(selection: $filterSize
                    , label: Text("Select size for filtering")) {
                        ForEach(0 ..< self.sizes.count) { number in
                            Text("\(self.sizes[number])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(Color.green)
                }
                Section(header: Text("Select price for filtering: ")) {
                    Picker(selection: $filterPrice, label: Text("Select price for filtering")) {
                        ForEach(0 ..< self.prices.count){ number in
                            Text("\(self.prices[number])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(Color.blue)
                }
                
            }
            .navigationBarItems(trailing: Button(action: {
                self.dismiss()
            }, label: {
                Text("Done")
            }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}



extension String: Identifiable {
    public var id: String { self }
}
