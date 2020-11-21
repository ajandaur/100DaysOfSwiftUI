//
//  addView.swift
//  iExpense
//
//  Created by Anmol  Jandaur on 11/21/20.
//

import SwiftUI

// add text fields for the expense name and amount, plus a picker for the type, all wrapped up in a form and a navigation view

struct addView: View {
    // add property to store an Expenses object
    // We don’t want to create a second instance of the Expenses class
    @ObservedObject var expenses: Expenses
    
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
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                }
            })
        } // NavigationView
    }
}

struct addView_Previews: PreviewProvider {
    static var previews: some View {
        addView(expenses: Expenses())
    }
}
