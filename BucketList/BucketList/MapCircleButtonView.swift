//
//  MapCircleButtonView.swift
//  BucketList
//
//  Created by Anmol  Jandaur on 12/31/20.
//

import SwiftUI
import MapKit

// MARK: Challenge 2 - rewrite it so that the MapView, Circle, and Button are part of their own view

struct MapCircleButtonView: View {
    
    // state to store current center coordinate of the map
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    @State private var locations = [CodableMKPointAnnotation]()
    
    // when the user adds a palce we want to edit immediately
    @State private var showingEditScreen = false
    
    // state properties to connect bindings from MapView
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    
    var body: some View {
        MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
            .edgesIgnoringSafeArea(.all)
        Circle()
            .fill(Color.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)
        
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    let newLocation = CodableMKPointAnnotation()
                    newLocation.title = "Example location"
                    newLocation.coordinate = self.centerCoordinate
                    self.locations.append(newLocation)
                    
                    // show edit screen whe user adds a new place to the map
                    
                    // set selectedPlace so code knows which place should be edited
                    self.selectedPlace = newLocation
                    self.showingEditScreen = true
                }) {
                    // MARK: Challenge 1 - Move all modifiers to the image inside the button
                    Image(systemName: "plus")
                        // make sure button is bigger before we add background color
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        // push away from the trailing edge
                        .padding(.trailing)
                }
                
            }
        }
        // load the data
        .onAppear(perform: loadData)
        
        .alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown"),message: Text(selectedPlace?.subtitle ?? "Missing place information."),primaryButton: .default(Text("OK")),secondaryButton: .default(Text("Edit")) {
                // edit this place
                self.showingEditScreen = true
            })
        }
        
        // bind showingEditScreen to a sheet, so our EditView gets presented
        // NOTE: can't use if let to unwrap selectedPlace  optional
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditView(placemark: self.selectedPlace!)
            }
        }
    }
   
    
    // accessing file storage using FileManager
    // provides us with document directory for the current user
    func getDocumentDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func loadData() {
        // getDocumentsDirectory().appendingPathComponent() to create new URLs that point to a specific file in the documents directory.
        let filename = getDocumentDirectory().appendingPathComponent("SavedPlaces")
        
        do {
            // use Data(contentsOf:) and JSONDecoder() to load our data
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
            
        } catch {
            print("Unable to load saved data")
        }
    }
    
    
    func saveData() {
        do {
            let filename = getDocumentDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            // iOS to ensure the file is written with encryption so that it can only be read once the user has unlocked their device. This is in addition to requesting atomic writes
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}

struct MapCircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MapCircleButtonView()
    }
}
