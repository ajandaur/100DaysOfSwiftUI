//
//  NewFriend.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/5/21.
//

import SwiftUI
import CoreImage

struct NewFriend: Identifiable, Comparable, Codable, Hashable {
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

// 
extension NewFriend {
    func getImage() -> UIImage? {
        
        let imageUrl = NewFriendSaver.getDocumentsDirectory().appendingPathComponent("\(self.id).jpeg")
        guard let data = try? Data(contentsOf: imageUrl) else { return nil }
        guard let uiImage = UIImage(data: data) else { return  nil }
            return uiImage
    }
}

