//
//  photoDetailView.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/5/21.
//

import SwiftUI
import CoreLocation

struct photoDetailView: View {
    
    @State var friend: NewFriend
    @State var imageUrl: URL

    var body: some View {
        VStack {
            Image(uiImage: friend.getImage()!)
                .resizable()
                .scaledToFit()
            
            Text("\(friend.firstName) \(friend.lastName)")
            if friend.latitude != nil {
                MapView(centerCoordinate: CLLocationCoordinate2D(latitude: friend.latitude!, longitude: friend.longitude!))
            }
        }
        
    }
}

