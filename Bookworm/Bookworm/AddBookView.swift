//
//  AddBookView.swift
//  Bookworm
//
//  Created by Anmol  Jandaur on 12/18/20.
//

import SwiftUI

struct AddBookView: View {
    
    // .managedObjectContext here is used as location in which to store the properties that are created
    
    @Environment(\.managedObjectContext) var moc
    
    //  we need @State properties for each of the book’s values except id, which we can generate dynamically.
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    // Challenge 3: property to set the date
    @State private var date = Date()
    
    // store all possible genre options
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Romance", "Thriller"]
    
    // MARK: Challenge 1: property observer to force a default and validate the form
    var noGenreSelected: Bool {
        return genre.isEmpty ? true : false
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id:\.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        // create an instance of the Book class using our managed object context, copy in all the values from our form (converting rating to an Int16 to match Core Data)
                        let newBook = Book(context: self.moc)
                        // Challenge 3: copy value of date
                        newBook.date = self.date
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review
                        // then save the managed object context
                        try? self.moc.save()
                        
                    }
                    // disabled modifier added to disable save button until genre is selected
                }.disabled(noGenreSelected)
            }
            .navigationBarTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
