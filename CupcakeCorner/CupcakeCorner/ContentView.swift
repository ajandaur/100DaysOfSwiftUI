//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Anmol  Jandaur on 12/15/20.
//

import SwiftUI


struct ContentView: View {
    // OBSERVED
    @ObservedObject var orderWrapper = OrderWrapper()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // picker letting users pick type of cake
                    Picker("Select your cake type", selection: $orderWrapper.order.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    // stepper for user to pick quantity of cake
                    Stepper(value: $orderWrapper.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(orderWrapper.order.quantity)")
                    }
                }
                
                Section {
                    // special request toggle
                    Toggle(isOn: $orderWrapper.order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    
                    // extra frosting
                    if orderWrapper.order.specialRequestEnabled {
                        Toggle(isOn: $orderWrapper.order.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                    // add sprinkles
                        Toggle(isOn: $orderWrapper.order.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                // NavigationLink to AddressView
                Section {
                    NavigationLink(destination: AddressView(orderWrapper: orderWrapper)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
