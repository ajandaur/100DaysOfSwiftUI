//
//  RatingView.swift
//  Bookworm
//
//  Created by Anmol  Jandaur on 12/18/20.
//

import SwiftUI

struct RatingView: View {
    
    // property to store an @Binding integer, so we can report back the user's selection to whatever is using the star rating.
    @Binding var rating: Int
    
    // What label should be placed before the rating (default: an empty string)
    var label = ""
    
    // The maximum integer rating (default: 5)
    var maximumRating = 5
    
    // The off and on images, which dictate the images to use when the star is highlighted or not
    // (default: nil for the off image, and a filled star for the on image if we find nil in the off image we’ll use the on image there too)
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    
    // The off and on colors, which dictate the colors to use when the star is highlighted or not (default: gray for off, yellow for on)
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        // if the label has any text use it, then use ForEach to count from 1 to the maximum rating plus 1 and call image(for:) repeatedly
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
    }
    

    func image(for number: Int) -> Image {
        // If the number that was passed in is greater than the current rating, return the off image if it was set, otherwise return the on image.
        if number > rating {
            return offImage ?? onImage
        } else {
        // If the number that was passed in is equal to or less than the current rating, return the on image.
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        //  Constant bindings are bindings that have fixed values, which on the one hand means they can’t be changed in the UI, but also means we can create them trivially – they are perfect for previews
        RatingView(rating: .constant(4))
    }
}
