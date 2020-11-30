//
//  SpecialEffects.swift
//  Drawing
//
//  Created by Anmol  Jandaur on 11/29/20.
//

import SwiftUI

struct SpecialEffects: View {
    var body: some View {
//        ZStack {
            Image("PaulHudson")

//            Rectangle()

                // we could draw an image inside a ZStack, then add a red rectangle on top that is drawn with the multiply blend
//                .blendMode(.multiply)
            
            // Using multiply with a solid color applies a really common tint effect: blacks stay black (because they have the color value of 0, so regardless of what you put on top multiplying by 0 will produce 0), whereas lighter colors become various shades of the tint.
                .colorMultiply(.red)
        }
//        .frame(width: 400, height: 500)
//        .clipped()
//    }
}


// Another popular effect is called screen, which does the opposite of multiply: it inverts the colors, performs a multiply, then inverts them again, resulting in a brighter image rather than a darker image.
struct ScreenView: View {
    @State private var amount: CGFloat = 0.0

    var body: some View {
        VStack {
            ZStack {
                
                // With that code, having the slider at 0 means the image is blurred and colorless, but as you move the slider to the right it gains color and becomes sharp – all rendered at lightning-fast speed.
                
                Image("PaulHudson")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .saturation(Double(amount))
                    .blur(radius: (1 - amount) * 20)
                
                
                // If you’re particularly observant, you might notice that the fully blended color in the center isn’t quite white – it’s a very pale lilac color. The reason for this is that Color.red, Color.green, and Color.blue aren’t fully those colors; you’re not seeing pure red when you use Color.red.
                
                Circle()
                    .fill(Color(red: 1, green: 0, blue: 0))
                    .frame(width: 200 * amount)
                    .offset(x: -50, y: -80)
                    .blendMode(.screen)

                Circle()
                    .fill(Color(red: 0, green: 1, blue: 0))
                    .frame(width: 200 * amount)
                    .offset(x: 50, y: -80)
                    .blendMode(.screen)

                Circle()
                    .fill(Color(red: 0, green: 0, blue: 1))
                    .frame(width: 200 * amount)
                    .blendMode(.screen)
            }
            .frame(width: 300, height: 300)

            Slider(value: $amount)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SpecialEffects_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
    }
}
