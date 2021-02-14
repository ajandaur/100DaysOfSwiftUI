//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Anmol  Jandaur on 11/24/20.
//

import Foundation

// convert astronauts.json into an array of Astronaut instances

// document directory put into extension of FileManager for any T: Codable
extension FileManager {
    
    
    func getDocumentDirectory<T: Codable>(_ file: String) -> T {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let path = try? paths[0] else {
            fatalError("Failed to get documents directory")
        }
        return path as! T
    }
    
    
}


extension Bundle {
    
    // Be very careful: There is a big difference between T and [T]
    // Use constrains and gains here (CS193p babyyy!) -> we can tell Swift that T can be whatever we want, as long as that thing conforms to Codable. That way Swift knows it’s safe to use, and will make sure we don’t try to use the method with a type that doesn’t conform to Codable
    
    func decode<T: Codable>(_ file: String) -> T {
        // use Bundle to find the path to the file
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        // previously we used String(contentsOf:) to load files into a string
        // but because Codable uses Data we are instead going to use Data(contentsOf:)
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        // load that into an instance of Data, and pass it through a JSONDecoder
        
        let decoder = JSONDecoder()
        
        // use dateDecodingStrategy from JSONDecoder to fix the date format to "y-MM-dd" using dateFormatter (dsecribes how our dates are formatted)
        // Warning: Date formats are case sensitive! mm means “zero-padded minute” and MM means “zero-padded month.”
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        // this tells decoder to parse dates in the exact format we expect
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}

