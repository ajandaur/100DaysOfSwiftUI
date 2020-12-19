//
//  DetailView.swift
//  Bookworm
//
//  Created by Anmol  Jandaur on 12/18/20.
//

import SwiftUI
import CoreData

struct DetailView: View {
    let book: Book
    
    // last feature to our app that deletes whatever book the user is currently looking at. To do this we need to show an alert asking the user if they really want to delete the book, then delete the book from the current managed object context if that’s what they want.
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    // Challenge 3: formate the date: Date using DateFormatter()
    
    func formatedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        
        return formatter.string(from: date)
    }
  
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                // That places the genre name in the bottom-right corner of the ZStack, with a background color, bold font, and a little padding to help it stand out
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Rectangle())
                        .offset(x: -5, y: -5)
                }
                
                // Challenge 3: display the date
                Text(formatedDate(date: self.book.date ?? Date()))
                
                // add the author, review, and rating, plus a spacer so that everything gets pushed to the top of the view
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(self.book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        
        //  add a navigation bar item that starts the deletion process – this just need to flip the showingDeleteAlert Boolean, because our alert() modifier is already watching it
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
        
        // add an alert() modifier that watches showingDeleteAlert, along with an Alert view inside it asking the user to confirm the action
        .alert(isPresented: $showingDeleteAlert) {
            // .destructive takes a title and action closure and is shown in red to warn users it will destroy data, and .cancel() will just cause the alert to be dismissed
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                        self.deleteBook()
                    }, secondaryButton: .cancel()
            )
        }
    }
    
   //  method that deletes the current book from our managed object context, and dismisses the current view
    func deleteBook() {
        moc.delete(book)
        
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct DetailView_Previews: PreviewProvider {
    // Previously this was easy to fix because we just sent in an example object, but with Core Data involved things are messier: creating a new book also means having a managed object context to create it inside
    
    // we can update our preview code to create a temporary managed object context, then use that to create our book. Once that’s done we can pass in some example data to make our preview look good, then use the test book to create a detail view preview
    
    // which thread do you plan to access your data using?”
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This is a great book; I really enjoyed it."
        
        return NavigationView {
            DetailView(book: book)
        }
    }
    
    
}
