//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Anmol  Jandaur on 12/16/20.
//

import SwiftUI

// we only want to proceed if the address is valid, then they move to checkout

struct AddressView: View {
    @ObservedObject var orderWrapper: OrderWrapper
    
    var body: some View {
            Form {
                Section {
                    TextField("Name", text: $orderWrapper.order.name)
                    TextField("Street Address", text: $orderWrapper.order.streetAddress)
                    TextField("City", text: $orderWrapper.order.city)
                    TextField("Zip", text: $orderWrapper.order.zip)
                }
                
                Section {
                    NavigationLink(destination: CheckoutView(orderWrapper: orderWrapper)) {
                        Text("Check out")
                    }
                }
                // check for valid input or else disable
                .disabled(!orderWrapper.order.hasValidAddress)
            }
            .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(orderWrapper: OrderWrapper())
    }
}
