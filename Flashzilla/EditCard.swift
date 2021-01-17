//
//  EditCard.swift
//  Flashzilla
//
//  Created by Anmol  Jandaur on 1/16/21.
//

import SwiftUI

struct EditCard: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // Have its own Card array.
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        // Be wrapped in a NavigationView so we can add a Done button to dismiss the view.
        NavigationView {
            // Have a list showing all existing cards.
            List {
                // Have a section at the top of the list so users can add a new card.
                Section(header: Text("Add new card")) {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(self.cards[index].prompt)
                                .font(.headline)
                            Text(self.cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    // Add swipe to delete for those cards.
                    .onDelete(perform: removeCards)
                }
            
            }
            .navigationBarTitle("Edit Cards")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
            
            .listStyle(GroupedListStyle())
            .onAppear(perform: loadData)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    
    }
    
    // Have methods to load and save data from UserDefaults
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false &&  trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        saveData()
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }

}

struct EditCard_Previews: PreviewProvider {
    static var previews: some View {
        EditCard()
    }
}
