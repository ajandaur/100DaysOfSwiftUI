//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Anmol  Jandaur on 1/20/21.
//

import SwiftUI

struct ResortView: View {
    let resort: Resort
    
    // have both views be layout neutral – to have them automatically adapt to being placed in a HStack or VStack depending on the parent that places them.
    @Environment(\.horizontalSizeClass) var sizeClass
    
    //  every view the navigation view presents will also gain that Favorites instance to work with.
    @EnvironmentObject var favorites: Favorites
    
    // store currently selected facility name
    @State private var selectedFacility : Facility?

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                    .overlay(ImageOverlay(credits: resort.imageCredit), alignment: .bottomTrailing)
                Spacer()
                
                
                
                Group {
                    HStack {
                        if sizeClass == .compact {
                            Spacer()
                            VStack { ResortDetailsView(resort: resort) }
                            VStack { SkiDetailView(resort: resort) }
                            Spacer()
                        } else {
                            ResortDetailsView(resort: resort)
                            Spacer().frame(height: 0)
                            SkiDetailView(resort: resort)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                    
                    
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    // loops over each item in the facilities array, converting it to an icon and placing it into a HStack
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            facility.icon
                                .font(.title)
                                .onTapGesture {
                                    self.selectedFacility = facility
                                }
                        }
                        
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            
            Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                if self.favorites.contains(self.resort) {
                    self.favorites.remove(self.resort)
                } else {
                    self.favorites.add(self.resort)
                }
            }
            .padding()
            
        }
        
        .navigationBarTitle(Text("\(resort.name), \(resort.country)"), displayMode: .inline)
        
        // alert modifier showing correct alert whenever selectedFacility has a value
        
        
        //  We can’t just bind any @State property to the alert(item:) modifier – it needs to be something that conforms to the Identifiable protocol.
        //  If we set selectedFacility to some string an alert should appear, but if we then change it to a different string SwiftUI needs to be able to see that the value changed.

        .alert(item: $selectedFacility) { facility in
            facility.alert
        }
        
    }
}

// MARK: Challenge 1: Add a photo credit over the ResortView image.
struct ImageOverlay: View {
    let credits: String
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Photo by \(credits)")
                    .font(.callout)
                    .foregroundColor(Color.white.opacity(0.7))
                    .padding(4)
                    .padding([.bottom, .trailing], 8)
                    .background(Color.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
               
            }
        }

    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
    }
}
