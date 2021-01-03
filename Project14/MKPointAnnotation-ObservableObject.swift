//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Anmol  Jandaur on 12/29/20.
//

import MapKit

// these properties that are computed are not marked with @Published because we won't actually be reading the properties as they are being changed
extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }
        
        set {
            subtitle = newValue
        }
    }
}
