//
//  ResortDetailsView.swift
//  SnowSeeker
//
//  Created by Anmol  Jandaur on 1/20/21.
//

import SwiftUI

struct ResortDetailsView: View {
    let resort: Resort
    
    var size: String {
        switch resort.size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }
    
    // creates a new string by repeating a substring a certain number of times
    var price: String {
        String(repeating: "$", count: resort.price)
    }
    
    var body: some View {
        Group {
            // our text is important, and should be even increased priority when it comes to layout
            Text("Size: \(size)").layoutPriority(1)
            // tell the spacers we only want them to work in landscape mode – they shouldn’t try to add space vertically.
            Spacer().frame(height: 0)
            Text("Price: \(price)").layoutPriority(1)
        }
    }
}

struct ResortDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ResortDetailsView(resort: Resort.example)
    }
}
