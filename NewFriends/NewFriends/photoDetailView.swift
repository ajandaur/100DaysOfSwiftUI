//
//  photoDetailView.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/5/21.
//

import SwiftUI

struct photoDetailView: View {
    
    var newFriend: NewFriend
    var imageUrl: URL
    var uiImage: UIImage? {
        guard let data = try? Data(contentsOf: imageUrl) else { return nil}
        guard let uiImage = UIImage(data: data) else { return nil}
        return uiImage
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct photoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        photoDetailView(newFriend: NewFriend(firstName: "Tom", lastName: "Lark", id: UUID()))
    }
}
