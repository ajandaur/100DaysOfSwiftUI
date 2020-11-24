//
//  Questions.swift
//  Edutainment
//
//  Created by Anmol  Jandaur on 11/17/20.
//

import Foundation

struct Question
{
    var tableNumber: Int
    var multiplier: Int
    
    var question: String {
        return "What is \(tableNumber) x \(multiplier) ?"
    }
    
    var answer: String {
        return String(tableNumber * multiplier)
    }

}
