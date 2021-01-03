//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Anmol  Jandaur on 12/16/20.
//

import SwiftUI

// we’re going to create a ScrollView with an image, the total price of their order, and a Place Order button to kick off the networking.

struct CheckoutView: View {
    @ObservedObject var orderWrapper: OrderWrapper
    
    // properties to show an alert containing details of our order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    // Challenge 2: Create alertTitle to hold the text of the alert
    @State private var alertTitle = ""
    
    var body: some View {
        // we’ll use a GeometryReader to make sure our cupcake image is sized correctly, a VStack inside a vertical ScrollView, then our image, the cost text, and button to place the order.
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                        
                    // hide the image from VoiceOver
                        .accessibility(hidden: true)
                    
                    Text("Your total is $\(self.orderWrapper.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        // alert() modifier to watch the Boolean and show an alert when its true
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("Check out", displayMode: .inline)
    }
    
    func placeOrder() {
        // Convert our current order object into some JSON data that can be sent.
        guard let encoded = try? JSONEncoder().encode(orderWrapper.order) else {
            print("Failed to encode order")
            return
        }
        // Prepare a URLRequest to send our encoded data as JSON.
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        // //MARK: https://reqres.in – it lets us send any data we want, and will automatically send it back
        var request = URLRequest(url: url)
        // The content type of a request determines what kind of data is being sent, which affects the way the server treats our data.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // The HTTP method of a request determines how data should be sent.
        // GET (“I want to read data”) and POST (“I want to write data”)
        request.httpMethod = "POST"
        request.httpBody = encoded
        // Run that request and process the response.
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            //Challenge 2 - Show a helpful error message if for when internet connection is down.
            if let error = error {
                self.alertTitle = "Error"
                self.confirmationMessage = "\(error.localizedDescription)"
                self.showingConfirmation = true
                
                return
            }
            
            // Makes sure that the data is recieving, otherwise show an error
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            // If we make it past that, it means we got some sort of data back from the server. Because we’re using the ReqRes.in, we’ll actually get back to the same order we sent, which means we can use JSONDecoder to convert that back from JSON to an object.
            
            // And now we can finish off our networking code: we’ll decode the data that came back, use it to set our confirmation message property, then set showingConfirmation to true so the alert appears
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.alertTitle = "Thank you!"
                self.confirmationMessage = "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
            }
            
        }.resume()
        
        
        
    }
}
    
    struct CheckoutView_Previews: PreviewProvider {
        static var previews: some View {
            CheckoutView(orderWrapper: OrderWrapper())
        }
    }
