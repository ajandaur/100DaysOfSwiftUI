//
//  ContentView.swift
//  Bookworm
//
//  Created by Anmol  Jandaur on 12/18/20.
//

import SwiftUI
import CoreData



struct ContentView: View {
    // a managed object context we can pass into AddBookView
    @Environment(\.managedObjectContext) var moc
    
    // Fetch request sorting is performed using a new class called NSSortDescriptor, and we can create them from two values: the attribute we want to sort on, and whether it should be ascending or not. For example, we can alphabetically sort on the title attribute
    @FetchRequest(entity: Book.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true), NSSortDescriptor(keyPath: \Book.author, ascending: false)]) var books: FetchedResults<Book>
    // Note: Having a second or even third sort field has little to no performance impact unless you have lots of data with similar values.
    
    // Boolean that tracks whether the add screen is showing or not
    @State private var showingAddScreen = false
    
    // The final step is to to make the form dismiss itself when the user adds a book
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)

                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title")
                                .font(.headline)
                            
                            // Challenge 2: Use ternary operator for text color so that books rated as 1 star have their name shown in red.
                                .foregroundColor(book.rating == 1 ? Color.red : .primary)
            
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
                .navigationBarTitle("Bookworm")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    self.showingAddScreen.toggle()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddScreen) {
                    // You’ve already seen how we use the @Environment property wrapper to read values from the environment, but here we need to write values in the environment. This is done using a modifier of the same name, environment(), which takes two parameters: a key to write to, and the value you want to send in.
                    AddBookView().environment(\.managedObjectContext, self.moc)
                    // For the key we can just send in the one we’ve been using all along, \.managedObjectContext, and for the value we can pass in our own moc property – we’re effectively just forwarding it on. 
                }
        }
    }
    
    //  Use onDelete(perform:) modifier to ForEach, but rather than just removing items from an array we instead need to find the requested object in our fetch request then use it to call delete() on our managed object context.
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let book = books[offset]
            
            // delete it from the context
            moc.delete(book)
        }
        
        // save the context
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
