//
//  ImageSaver.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/6/21.
//
// Credit to: https://github.com/plr-100daysOfSwiftUI/Whatsaname/tree/main/Whatsaname for help with this NSObject class
// Something I learned from their code is that:
// When you’re writing protocols and protocol extensions, there’s a difference between Self (capital S) and self (lowercase s). When used with a S, Self refers to the type that conform to the protocol, e.g. String or Int. When used with a s, self refers to the value inside that type, e.g. “hello” or 556.

import UIKit

class NewFriendSaver: NSObject {

    
    func saveData(image: UIImage, firstName: String, lastName: String, latitude: Double, longitude: Double) {
        let friend = NewFriend(firstName: firstName, lastName: lastName, id: UUID(), latitude: latitude, longitude: longitude)
        writeToJSON(friend)
        saveImage(image: image, id: friend.id)
    }
    
    func writeToJSON(_ friend: NewFriend) {
        
        let filename = Self.getDocumentsDirectory().appendingPathComponent("newfriends.json")
        var friends = [NewFriend]()
       
        do {
            if let decoded = try? Data(contentsOf: filename) {
                friends = try! JSONDecoder().decode([NewFriend].self, from: decoded)
            }
            friends.append(friend)
            
            let encoded = try! JSONEncoder().encode(friends)
            // iOS to ensure the file is written with encryption so that it can only be read once the user has unlocked their device. This is in addition to requesting atomic writes
            try encoded.write(to: filename, options: [.atomicWrite, .completeFileProtection])
         
        } catch {
            print("Unable to save data.")
        }
    }
        
    
    func saveImage(image: UIImage, id: UUID) {
        let url = Self.getDocumentsDirectory().appendingPathComponent("\(id).jpeg")
        
        // Save the image
        do {
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                
                // convert your UIImage to Data by calling its jpegData()
                // compressionQuality parameter can be any value between 0 (very low quality) and 1 (maximum quality); something like 0.8 gives a good trade off between size and quality
                
                try jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    static func loadData() -> [NewFriend] {
        
        
        // getDocumentsDirectory().appendingPathComponent() to create new URLs that point to a specific file in the documents directory.
        let filename = self.getDocumentsDirectory().appendingPathComponent("newfriends.json")
        
        // friends to load
        var friends = [NewFriend]()
        
        do {
            // use Data(contentsOf:) and JSONDecoder() to load our data
            let data = try Data(contentsOf: filename)
            friends = try JSONDecoder().decode([NewFriend].self, from: data)
            
        } catch {
            print("Unable to load saved data")
        }
        
        return friends
    }
    
    static func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func clearAllFile() {
            let fileManager = FileManager.default

            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

            print("Directory: \(paths)")

            do
            {
                let fileName = try fileManager.contentsOfDirectory(atPath: paths)

                for file in fileName {
                    // For each file in the directory, create full path and delete the file
                    let filePath = URL(fileURLWithPath: paths).appendingPathComponent(file).absoluteURL
                    try fileManager.removeItem(at: filePath)
                }
            }catch let error {
                print(error.localizedDescription)
            }
        }
    
    
   
    
}
