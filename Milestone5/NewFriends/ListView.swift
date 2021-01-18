//
//  ListView.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/7/21.
//

import SwiftUI

struct ListView: View {
    
    // pass in the friends array
    @State var friends: [NewFriend]
    
    
    func getImage(friend: NewFriend) -> UIImage? {
        
            let imageUrl = NewFriendSaver.getDocumentsDirectory().appendingPathComponent("\(friend.id).jpeg")
        guard let data = try? Data(contentsOf: imageUrl) else { return nil }
        guard let uiImage = UIImage(data: data) else { return  nil }
            return uiImage
    }
    
     func removeFriends(at offsets: IndexSet) {
        friends.remove(atOffsets: offsets)
    }
    
    var body: some View {
        List() {
            ForEach(friends.sorted(), id:\.self) { friend in
                NavigationLink(destination: photoDetailView(friend: friend, imageUrl: NewFriendSaver.getDocumentsDirectory().appendingPathComponent("\(friend.id).jpeg"))
                ) {
                    HStack {
                        Image(uiImage: friend.getImage()!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 5))
                            
                           
                            .padding()
                        Text("\(friend.lastName), \(friend.firstName)")
                            .font(.title)
                    }
                   
                }
                    
                                
            }
            .onDelete(perform: removeFriends)
            
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let friend = NewFriend(firstName: "Alex", lastName: "Alexander", id: UUID())
        let friends = [friend]
        ListView(friends: friends)
    }
}
