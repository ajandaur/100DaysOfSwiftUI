//
//  Result.swift
//  BucketList
//
//  Created by Anmol  Jandaur on 12/29/20.
//

import Foundation
 
// Wikipedia’s API sends back JSON data in a precise format, so we need to do a little work to define Codable structs capable of storing it all. The structure is this:

// The main result contains the result of our query in a key called “query”.
// Inside the query is a “pages” dictionary, with page IDs as the key and the Wikipedia pages themselves as values.
// Each page has a lot of information, including its coordinates, title, terms, and more.

struct Result: Codable {
    let query: Query
}
struct Query: Codable {
    let pages: [Int: Page]
}

// conform to Cmparable so that we can sort the results by title string
struct Page: Codable, Comparable {
    static func < (lhs: Page, rhs: Page) -> Bool {
        return lhs.title < rhs.title
    }
    
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    // computed property to return description if it exists or else, fixed string
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
}
