//
//  photoDetailView.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/5/21.
//

import SwiftUI

struct photoDetailView: View {
    
    var friend: NewFriend
    var imageUrl: URL

    
    
    
    
    var body: some View {
        VStack {
            Image(uiImage: friend.getImage()!)
                .resizable()
                .scaledToFit()
            
            Text("\(friend.firstName) \(friend.lastName)")
            // TODO: Add the MapView here
            
        }
        
    }
}

