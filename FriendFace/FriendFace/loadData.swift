//
//  Users.swift
//  FriendFace
//
//  Created by Anmol  Jandaur on 12/22/20.
//

//  Credit to https://github.com/PetroOnishchuk/100-Days-Of-SwiftUI/


import Foundation
import SwiftUI
import CoreData

class Users {

    static func loadData(moc: NSManagedObjectContext) {

        loadDataFromJSON { (users) in
            DispatchQueue.main.async {

                var tempUsers = [User]()

                //Convert to Core Data Entities
                for user in users {
                    let cdUser = User(context: moc)
                    cdUser.id = user.id
                    cdUser.name = user.name
                    cdUser.company = user.company
                    cdUser.isActive = user.isActive
                    cdUser.age = Int16(user.age)

                    //Create the friends and add them to the user
                    for friend in user.friends {
                        let cdFriend = Friend(context: moc)
                        cdFriend.id = friend.id
                        cdFriend.name = friend.name

                        //Make the relationship link to the user
                        cdUser.addToFriends(cdFriend)
                    }

                    print("User Loaded: \(user)\n\n")
                    tempUsers.append(cdUser)
                }

                //Save the users
                do {
                     try moc.save()
                } catch let error {
                    print("Could not save data: \(error.localizedDescription)")
                }
            }
        }

    }

    static func loadDataFromJSON(completion: @escaping ([LoadedUser]) -> ()) {
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }

        let urlRequest = URLRequest(url: url)
        print("Getting data...")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            if let error = error {
                print("Error: \(error.localizedDescription)")
            }

            guard let data = data else { return }

            print("Data Retrieved: \(data.count)")
            if let decodedUsers = try? JSONDecoder().decode([LoadedUser].self, from: data) {

                print("Users Parsed: \(decodedUsers.count)")

                completion(decodedUsers)

            } else {
                print("Error: Failed to parse data")
            }

        }.resume()
    }
}

