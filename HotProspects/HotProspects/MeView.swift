//
//  MeView.swift
//  HotProspects
//
//  Created by Anmol  Jandaur on 1/11/21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    
    // properties to store an active Core Image context
    // and instance of Core Image's QR code generator
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        // input is a string, convert it to Data
       
        
        // if conversion fails, send back SF symbol X mark
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        // else return an empty UIImage
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Name", text: $name)
                    //  tells iOS what kind of information we’re asking the user for
                    // allow iOS to provide autocomplete data on behalf of the user
                    .textContentType(.name)
                    .font(.title)
                    .padding(.horizontal)
                
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                    .padding([.horizontal, .bottom])
                
                Spacer()
                
                // using the name and email address entered by the user, separated by a line break
                Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                    // To remove the fuzzy look that isc aused by SwiftUI trying to smooth out the pixels as we scale it up
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                
            }
            .navigationBarTitle("Your code")
        }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
