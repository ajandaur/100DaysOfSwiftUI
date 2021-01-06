//
//  ContentView.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/2/21.
//

//  goal is to build an app that asks users to import a picture from their photo library, then attach a name to whatever they imported. The full collection of pictures they name should be shown in a List, and tapping an item in the list should show a detail screen with a larger version of the picture.


import SwiftUI
import CoreLocation

struct ContentView: View {
    
    // hold all the contacts
    @State private var newFriends: [newFriend]
    
    // Boolean that tracks whether the imagePicker is shown
    @State private var showImagePicker = false
    
    // State property to check whether an image is present
    @State private var noImagePresent = false
    
    // the contact image
    @State private var inputImage: UIImage?
    
    // converted image
    @State private var image: Image?
    
    // first name of contact
    @State private var firstName: String = ""
    
    // last name of contact
    @State private var lastName: String = ""
    
    // SF symbol save icon
    let saveIcon = UIImage(systemName: "square.and.arrow.down.fill")
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showImagePicker = true
                }
                
                VStack {
                    TextField("First Name",text: $firstName)
                    TextField("First Name",text: $lastName)
                }
                
                HStack {
                    
                    Spacer()
                    
                    Image(uiImage: saveIcon!)
                    Button("Save")
                    {
                        // check to see if image is present
                        guard self.image != nil else {
                            self.noImagePresent = true
                            return
                        }
                        guard !firstName.isEmpty && !lastName.isEmpty else { return }
                        
                        // save the data
                        let saver = NewFriendSaver()
                        
                        saver.successHandler = {
                            print("Success")
                        }
                        
                        saver.errorHandler = {
                            print("Opps: \($0.localizedDescription)")
                        }
                        
                        save.writeToPhotoAlbum(image: image)
                        
                        }
                    }
                }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("New Friends")
            
            // alert when there is no image present
            .alert(isPresented: $noImagePresent) {
                Alert(title: Text("Error"), message: Text("Could not save - no image selected"), dismissButton: .default(Text("Continue")))
            }
            
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            
            } // NavView
        } // ContentView
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func save(_ userData: Data, withName name: String) {
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        
        do {
            try userData.write(to: filename, options: .atomicWrite)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(withName name: String) -> [Prospect]? {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        if let data = try? Data(contentsOf: url) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                return decoded
            }
        }
        return nil
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
    }
}
