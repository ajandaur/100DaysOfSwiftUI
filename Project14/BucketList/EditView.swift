//
//  EditView.swift
//  BucketList
//
//  Created by Anmol  Jandaur on 12/29/20.
//

import SwiftUI
import MapKit

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placemark: MKPointAnnotation
    
    // enum to store the load state so that we can show "Loading" text view
    enum LoadingState {
        case loading, loaded, failed
    }
    
    // property to represent the loading state
    @State private var loadingState = LoadingState.loading
    
    // property to store array of Wikipedia pages once the fetch has completed
    @State private var pages = [Page]()
    
    // fetch data from Wikipedia, decodee into a Result, assign its pages to our pages property, then set loadStates properly
    func fetchNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // we got some data back!
                let decoder = JSONDecoder()
                
                if let items = try? decoder.decode(Result.self, from: data) {
                    // success - convert the array values to our pages array
                    // give array parameter-less sorted() via Comparable 
                    self.pages = Array(items.query.pages.values).sorted()
                    self.loadingState = .loaded
                    return
                }
            }
            
            // if we're still here it means the request failed somehow
            self.loadingState = .failed
        }.resume()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $placemark.wrappedTitle)
                    TextField("Description", text: $placemark.wrappedSubtitle)
                }
                
                // show pages if they have loaded or st atus text view otherwise
                Section(header: Text("Nearby…")) {
                    if loadingState == .loaded {
                        List(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                                
                                // "+" lets us create a larger text view that mix and match different kinds of formatting
                                + Text(": ") +
                                Text(page.description)
                                .italic()
                        }
                    } else if loadingState == .loading {
                        Text("Loading…")
                    } else {
                        Text("Please try again later.")
                    }
                }
                
                
            }
            .navigationBarTitle("Edit place")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
            
            .onAppear(perform: {
                fetchNearbyPlaces()
            })
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(placemark: MKPointAnnotation.example)
    }
}
