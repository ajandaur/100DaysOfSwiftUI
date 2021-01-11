//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Anmol  Jandaur on 1/11/21.
//

import SwiftUI

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    // to determine which tab we are one
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    var body: some View {
        NavigationView {
            Text("Hello, World!")
                .navigationBarTitle(title)
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
