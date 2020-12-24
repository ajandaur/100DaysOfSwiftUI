//
//  User+CoreDataProperties.swift
//  FriendFace
//
//  Created by Anmol  Jandaur on 12/22/20.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var company: String?
    @NSManaged public var age: Int16
    @NSManaged public var friends: NSSet?

    
    public var wrappedId: String {
        id ?? "Unknown"
    }
    
    public var wrappedName: String {
        name ?? "Unknown"
    }
    
    public var wrappedCompany: String {
        company ?? "Unknown"
    }
    
    public var wrappedAge: Int16 {
        age
    }
    
    public var wrappedIsActive: Bool {
        isActive
    }
    
    // convert from NSSet to Set<Friend>
    // convert set to an array so that ForEach can read values
    // Sort array in a sensible order
    public var friendsArray: [Friend] {
        let set = friends as? Set<Friend> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    var checkIsActive: String {
        return self.isActive ? "✅" : "🚫"
    }
    
    static var test: User {
        let user = User()
        user.id = "123"
        user.isActive = true
        user.age = 12
        user.company = "Apple"
        user.friends = [Friend.test]
        return user
    }
}

// MARK: Generated accessors for friends
extension User {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: Friend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: Friend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension User : Identifiable {

}
