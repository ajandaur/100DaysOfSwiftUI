//
//  ContentView.swift
//  FriendFace
//
//  Created by Anmol  Jandaur on 12/22/20.
//

import SwiftUI

struct ContentView: View {
    // Retriving information using a fetch request
    // @FetchRequest takes entity we want to query and howe want it sorted
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var users: FetchedResults<User>
    
    // access managed object context to add and save objects
    @Environment(\.managedObjectContext) var moc
    
    
    //  Use onDelete(perform:) modifier to ForEach, but rather than just removing items from an array we instead need to find the requested object in our fetch request then use it to call delete() on our managed object context.
    func deleteUsers(at offsets: IndexSet) {
        for offset in offsets {
            // find the user in our fetch request
            let user = users[offset]
            
            // delete it from the context
            moc.delete(user)
        }
        
        // save the context
        try? moc.save()
    }
    
    // Cannot convert value of type 'FetchedResults<User>' to expected argument type '[User]'
    func getUsers() -> [User] {
        return users.sorted {(user1, user2) -> Bool in
            user2.wrappedName > user1.wrappedName
        }
    }
    
    func loadData() {
        if self.users.isEmpty {
            Users.loadData(moc: self.moc)
        } else {
            print("Data already loaded")
        }
    }
    
    var body: some View {
        NavigationView {
            List() {
                ForEach(users, id: \.id) { user in
                    NavigationLink(destination: UserDetailView(users: self.getUsers(), user: user)) {
                        HStack {
                            Text("\(user.checkIsActive)")
                            VStack(alignment: .leading) {
                                Text(user.wrappedName)
                                    .font(.headline)
                                Text("Age: \(user.wrappedAge)")
                                    .font(.subheadline)
                                Text("Company: \(user.wrappedCompany)")
                            }
                        }
                    }
                }
                .onDelete(perform: deleteUsers)
            }
            .navigationBarTitle("FriendFace")
            // want to run as soon as our list is shown
            .onAppear(perform: loadData)
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
