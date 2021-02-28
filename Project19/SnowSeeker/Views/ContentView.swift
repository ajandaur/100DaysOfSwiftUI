//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Anmol  Jandaur on 1/20/21.
//

import SwiftUI


extension View {
    // this uses Apple’s UIDevice class to detect whether we are currently running on a phone or a tablet, and if it’s a phone enables the simpler StackNavigationViewStyle approach. We need to use type erasure here because the two returned view types are different.
    
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}


enum SortingType {
    case none
    case name
    case country
}

struct ContentView: View {
    
    // MARK: Challenge 3 -  let the user sort and filter the resorts in ContentView. For sorting use default, alphabetical, and country, and for filtering let them select country, size, or price.
    
    // Help from https://github.com/PetroOnishchuk/100-Days-Of-SwiftUI
    
    // create Favorites instance and inject it into the environment so all the view can share it
    @ObservedObject var favorites = Favorites()
    
    
    // property that loads all our resorts into a single array
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
  
    
    // property to show sorting and filtering screen
    @State  var showingFilter = false
    @State  var showingSort = false
    
    // properties for filteringand sorting
    @State  var filterCountry = "All"
    @State  var filterSize = 0
    @State  var filterPrice = 0
    
    @State private var sortingType = SortingType.none
    
    // sortedResorts to show in list
    var sortedResorts: [Resort] {
        switch sortingType {
        case .none:
            return resorts
        case .name:
            return resorts.sorted{ $0.name < $1.name }
        case .country:
            return resorts.sorted { $0.country < $1.country }
        }
    }
    
    var filteredResorts: [Resort] {
        
        var tempResort = sortedResorts
        
        tempResort = tempResort.filter({ (resort) -> Bool in  resort.country == self.filterCountry || self.filterCountry == "All"
        })
        
        tempResort = tempResort.filter({ (resort) -> Bool in
            resort.size == self.filterSize || self.filterSize == 0
        })
        
        tempResort = tempResort.filter( { (resort) -> Bool in
            resort.price == self.filterPrice || self.filterPrice == 0
        })
        
        return tempResort
        
    }

    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                } // NavLink
            }
            
            // Code won't complie with .sheet unfortunately..
            
//            .sheet(isPresented: $showingFilter,content: {
//                FilterSortView(filterCountry: self.$filterCountry, filterPrice: self.$filterSize, filterPrice: self.$filterPrice)
//            })
            
            .navigationBarTitle("Resort")

            .navigationBarItems(leading: Button(action: {
                self.showingFilter.toggle()
            }, label: {
                Text("Filter")
            }), trailing: Button(action: {
                self.showingSort.toggle()
            }, label: {
                Text("Sort")
            }))



            .actionSheet(isPresented: $showingSort) {
                ActionSheet(title: Text("Sort Resorts By: "), buttons:
                                [.default(Text("Name"), action: {
                    self.sortingType = .name
                }),
                .default(Text("Country"), action: {
                    self.sortingType = .country
                }),
                .default(Text("Default"), action: {
                    self.sortingType = .none
                }),
                .destructive(Text("Cancel"))])
            }
            .animation(.easeOut)


            WelcomeView()
        }
        .environmentObject(favorites)
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

