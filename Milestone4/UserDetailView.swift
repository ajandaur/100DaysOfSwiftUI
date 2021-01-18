//
//  UserDetailView.swift
//  FriendFace
//
//  Created by Anmol  Jandaur on 12/24/20.
//
// credits to Cathal Farrell

import SwiftUI

struct UserDetailView: View {
    var users: [User]
    var user: User
    
    func getUsers(from friends: [Friend]) -> [User] {
        var usersFound = [User]()
        
        for friend in friends {
            if let match = users.first(where: {
                $0.wrappedId == friend.wrappedId
            }) {
                usersFound.append(match)
            }
        }
        
        return usersFound
    }
    
    var body: some View {
        Form {
            Section {
                Text("Name: \(user.wrappedName)")
                Text("Age: \(user.wrappedAge)")
                Text("Company: \(user.wrappedCompany)")
                Text("ID: \(user.wrappedId)")
            }
            
            Section(header: Text("Friends"))
            {
                List(getUsers(from: user.friendsArray), id: \.self) { userFriend in
                    // use where first in users array to find friend
                    NavigationLink(destination: UserDetailView(users: self.users, user: userFriend)) {
                        Text("\(userFriend.wrappedName)")
                    }                }
            }
        }
        .navigationBarTitle("User Details")
        .onAppear()
    }
    
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(users: [User](), user: User())
    }
}
