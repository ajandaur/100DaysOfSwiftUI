//
//  addView.swift
//  iExpense
//
//  Created by Anmol  Jandaur on 11/21/20.
//

import SwiftUI

// add text fields for the expense name and amount, plus a picker for the type, all wrapped up in a form and a navigation view

struct addView: View {
    // dismissing AddView is done by storing a reference to the view’s presentation mode, then calling dismiss() on it when the time is right.
    @Environment(\.presentationMode) var presentationMode
    
    // add property to store an Expenses object
    // We don’t want to create a second instance of the Expenses class so use a property wrapper
    @ObservedObject var expenses: Expenses
    
    // Challenge 2: state property for index position of style array
    @State private var styleIndex: Int?
    
    // Challenge 3: check for invalid cost amount
    @State private var isInvalidAmount = false
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            } // Form
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    // Challenge 2: decide the style to apply depending on cost
                    if actualAmount > 99 {
                        self.styleIndex = 2
                    } else if actualAmount > 9 {
                        self.styleIndex = 1
                    }
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount, costStyleIndex: self.styleIndex ?? 0)
                    self.expenses.items.append(item)
                    
                    // causes the showingAddExpense Boolean in ContentView
                    // to go back to false, and hides the AddView
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    // Challenge 3: toggle amountError state since actualAmount couldn't be converted to an Int
                    self.isInvalidAmount.toggle()
                }
            })
            
            // Show an alert to explain invalid input error
            .alert(isPresented: $isInvalidAmount) {
                Alert(title: Text("Input is invalid"), message: Text("The amount entered must be a number. Please try again"), dismissButton: .default(Text("Continue")))
            }
        } // NavigationView
    }
}

struct addView_Previews: PreviewProvider {
    static var previews: some View {
        addView(expenses: Expenses())
    }
}
