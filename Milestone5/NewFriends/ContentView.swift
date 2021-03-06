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
    @State private var newFriends: [NewFriend] = NewFriendSaver.loadData()
    
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
    
    // locationFetcher
    let locationFetcher = LocationFetcher()
    
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
                        
                        
                        var lat: Double?
                        var long: Double?
                        
                        if let location = self.locationFetcher.lastKnownLocation {
                            lat = location.latitude
                            long = location.longitude
                                           print("Your location is \(location)")
                                       } else {
                                           print("Your location is unknown")
                                       }
                        
                        // check to see if image is present
                        guard self.image != nil else {
                            self.noImagePresent = true
                            return
                        }
                        guard let _ = self.image else { return }
                        guard !firstName.isEmpty && !lastName.isEmpty else { return }
                        
                        // save the data
                        let saver = NewFriendSaver()
                        
            
                
                        saver.saveData(image: inputImage!, firstName: firstName, lastName: lastName, latitude: lat!, longitude: long!)
                        newFriends = NewFriendSaver.loadData()
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("New Friends")
            .navigationBarItems(trailing: NavigationLink(destination: ListView(friends: newFriends), label: {
                Image(systemName: "list.dash")
            })
            )
            // alert when there is no image present
            .alert(isPresented: $noImagePresent) {
                Alert(title: Text("Error"), message: Text("Could not save - no image selected"), dismissButton: .default(Text("Continue")))
            }
            
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            
        } // NavView
        .onAppear(// start the locationFetcher
            perform: locationFetcher.start)
    } // ContentView
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
    }
}
