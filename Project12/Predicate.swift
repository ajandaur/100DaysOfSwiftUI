//
//  Predicate.swift
//  CoreDataProject
//
//  Created by Anmol  Jandaur on 12/20/20.
//

import Foundation

// MARK: Modify the predicate string parameter to be an enum such as .beginsWith, then make that enum get resolved to a string inside the initializer.

enum predicateMethod: String {
    case beginsWith
    case beginsWithAnyCase
    case contains
    case containsAnyCase
}
