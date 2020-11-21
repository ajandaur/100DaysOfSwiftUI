//
//  ContentView.swift
//  iExpense
//
//  Created by Anmol  Jandaur on 11/19/20.
//

import SwiftUI

// NOTE: to use onDelete(), we need to use a ForEach in order to use the onDelete() modifier

struct ContentView: View {
    // using @ObservedObject here asks SwiftUI to watch the object for any change announcements, so any time one of our @Published properties changes the view will refresh its body.
    @ObservedObject var expenses = Expenses()
    
    // to add AddView as a new view, we need some state to track whether or not AddView is being shown, so add this property:
    @State private var showingAddExpenses = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
                
            } // List
            .navigationBarTitle("iExpense")
            
            // add trailing bar button to add example ExpenseItem instances
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.showingAddExpenses = true
                                    }) {
                                        Image(systemName: "plus")
                                    }
            )
            
        } // Navigation View
        
        // sheet for addView
        .sheet(isPresented: $showingAddExpenses) {
            addView(expenses: self.expenses)
        }
        
    } // Body
    
    // remove items from the list
    func removeItems(at offsets: IndexSet)
    {
        expenses.items.remove(atOffsets: offsets)
    }
    
} // View


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
