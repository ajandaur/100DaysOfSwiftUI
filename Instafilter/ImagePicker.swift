//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Anmol  Jandaur on 12/23/20.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    // We’re presenting ImagePicker inside a sheet in our ContentView struct, so we want that to be given whatever image was selected, then dismiss the sheet
    // What we need here is SwiftUI’s @Binding property wrapper, which allows us to create a binding from ImagePicker up to whatever created it
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        // wrap the basic view controller
        let picker = UIImagePickerController()
        
        // tell the UIImagePickerController that when something happens it should tell our coordinator
        picker.delegate = context.coordinator
        // The line of code we just wrote tells Swift to use the coordinator that just got made as the delegate for the UIImagePickerController. This means any time something happens inside the image picker controller – i.e., when the user selects an image – it will report that action to our coordinator
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // UIImagePickerControllerDelegate protocol defines two optional methods that we can implement: one for when the user selected an image, and one for when they pressed cancel.
        
        // ather than just pass the data down one level, a better idea is to tell the coordinator what its parent is, so it can modify values there directly
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // we’re ready to actually read the response from our UIImagePickerController, which is done by implementing a method with a very specific name.
        // "didFinishPicking"
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    

}
    
    
