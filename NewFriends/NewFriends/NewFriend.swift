//
//  NewFriend.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/5/21.
//

import SwiftUI
import CoreImage

struct NewFriend: Identifiable, Comparable, Codable {
    var firstName = ""
    var lastName = ""
    var id = UUID()
    
    static func <(lhs: NewFriend, rhs: NewFriend) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    static func ==(lhs: NewFriend, rhs:NewFriend) -> Bool {
        lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
    }
}

