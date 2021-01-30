//
//  Result+CoreDataProperties.swift
//  DiceRoll
//
//  Created by Anmol  Jandaur on 1/24/21.
//
//

import Foundation
import CoreData


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var numberOfDice: Int16
    @NSManaged public var totalResult: Int16
    @NSManaged public var dice: NSSet?
    
    var wrappedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        
        if let wrapDate = date {
            return formatter.string(from: wrapDate)
        } else {
            return formatter.string(from: Date())
        }
    }
    
    var wrappedTime: String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "h:mm a"
        if let wrapDate = date {
            return formatter.string(from: wrapDate)
        } else {
            return formatter.string(from: Date())
        }
    }
    
    var wrappedTotalResult: Int {
        Int(totalResult)
    }
    
    var wrappedNumberOfDice: Int {
        Int(numberOfDice)
    }
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var diceArray: [CoreDataRoll] {
        let set = dice as? Set<CoreDataRoll> ?? []
        let array = set.sorted { $0.wrappedTotalSum > $1.wrappedTotalSum }
        
        return array

    }
    
}

extension Result : Identifiable {
    
    @objc(addDiceObject:)
    @NSManaged public func addToDice(_ value: CoreDataRoll)

    @objc(removeDiceObject:)
    @NSManaged public func removeFromDice(_ value: CoreDataRoll)

    @objc(addDice:)
    @NSManaged public func addToDice(_ values: NSSet)

    @objc(removeDice:)
    @NSManaged public func removeFromDice(_ values: NSSet)
}
