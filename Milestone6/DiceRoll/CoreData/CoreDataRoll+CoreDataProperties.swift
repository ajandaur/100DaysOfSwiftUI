//
//  CoreDataRoll+CoreDataProperties.swift
//  DiceRoll
//
//  Created by Anmol  Jandaur on 1/20/21.
//
//

import Foundation
import CoreData


extension CoreDataRoll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataRoll> {
        return NSFetchRequest<CoreDataRoll>(entityName: "CoreDataRoll")
    }

    @NSManaged public var totalSum: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var numberOfSides: Int16
    @NSManaged public var date: Date?
    @NSManaged public var mainResult: Result?

    var wrappedNumberOfSides: Int {
        Int(numberOfSides)
    }
    
    var wrappedTotalSum: Int {
        Int(totalSum)
    }
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedDate: Date {
        date ?? Date()
    }
    
}

