//
//  Country+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Anmol  Jandaur on 12/20/20.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var shortName: String?
    // NSSet is the older, Objective-C data type that is equivalent to Swift’s Set, but we can’t use it with SwiftUI’s ForEach
    @NSManaged public var candy: NSSet?
    
    public var candyArray: [Candy] {
        // Convert it from an NSSet to a Set<Candy> – a Swift-native type where we know the types of its contents.
        let set = candy as? Set<Candy> ?? []
        // Convert that Set<Candy> into an array, so that ForEach can read individual values from there.
        // Sort that array, so the candy bars come in a sensible order.
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var wrappedShortName: String {
        shortName ?? "Unknown Country"
    }
    
    public var wrappedFullName: String {
        fullName ?? "Unknown Country"
    }

}

// MARK: Generated accessors for candy
extension Country {

    @objc(addCandyObject:)
    @NSManaged public func addToCandy(_ value: Candy)

    @objc(removeCandyObject:)
    @NSManaged public func removeFromCandy(_ value: Candy)

    @objc(addCandy:)
    @NSManaged public func addToCandy(_ values: NSSet)

    @objc(removeCandy:)
    @NSManaged public func removeFromCandy(_ values: NSSet)

}

extension Country : Identifiable {

}
