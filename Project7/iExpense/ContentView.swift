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
    
    // Challenge 2: make array of colors and font weights for different cost styles
    let colorStyles: [Color] = [.green, .blue, .red]
    let fontStyles: [Font.Weight] = [.light,.medium,.heavy]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        // show expense name and type on the left (.leading)
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        // show expense amount on the right with a Spacer()
                        Spacer()
                        Text("$\(item.amount)")
                        // MARK: Challenge 2 - Modify the expense amounts in ContentView to contain some styling depending on their value
                            .fontWeight(self.fontStyles[item.costStyleIndex])
                            .foregroundColor(self.colorStyles[item.costStyleIndex])
                            
                    }
                }
                .onDelete(perform: removeItems)
                
            } // List
            .navigationBarTitle("iExpense")
            
            // Challenge 1: add an Edit/Done button to ContentView so users can delete rows more easily
            .navigationBarItems(leading: EditButton(), trailing:
                               
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
