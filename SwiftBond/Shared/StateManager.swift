//
//  StateManager.swift
//  SwiftBond
//
//  Created by Bruce Colby on 6/21/18.
//  Copyright © 2018 Bruce Colby. All rights reserved.
//

import Foundation

class StateManager {
    // MARK: - Properties
    static let shared = StateManager()
    
    var person: Person? = Person.empty()
    
    private init() {}
}
