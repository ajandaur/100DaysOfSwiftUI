//
//  ImageSaver.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/6/21.
//

import UIKit

class NewFriendSaver: NSObject {
    
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    // convert your UIImage to Data by calling its jpegData()
    // compressionQuality parameter can be any value between 0 (very low quality) and 1 (maximum quality); something like 0.8 gives a good trade off between size and quality
    if let jpegData = yourUIImage.jpegData(compressionQuality: 0.8) {
        try? jpegData.write(to: yourURL, options: [.atomicWrite, .completeFileProtection])
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
    
}
