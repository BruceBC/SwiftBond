//
//  Person.swift
//  SwiftBond
//
//  Created by Bruce Colby on 6/21/18.
//  Copyright © 2018 Bruce Colby. All rights reserved.
//

import Foundation

struct Person: Codable {
    var name: String
    var age: String
    
    init(name: String, age: String) {
        self.name = name
        self.age = age
    }
    
    static func empty() -> Person {
        return Person(name: "", age: "")
    }
}
