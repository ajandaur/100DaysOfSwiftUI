//
//  Friend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Anmol  Jandaur on 12/22/20.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var user: NSSet?
    
    public var wrappedId: String {
        id ?? "Unknown Id"
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    static var test: Friend {
        let friend = Friend()
        friend.id = "12311413"
        friend.name = "Tome Tome"
        return friend
    }

}

// MARK: Generated accessors for user
extension Friend {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: User)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: User)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}

extension Friend : Identifiable {

}
