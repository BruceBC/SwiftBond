//
//  PersonModel.swift
//  SwiftBond
//
//  Created by Bruce Colby on 6/21/18.
//  Copyright © 2018 Bruce Colby. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

class PersonModel {
    var name = Observable<String?>("")
    var age = Observable<String?>("")
    
    init(name: String, age: String) {
        self.name.value = name
        self.age.value = age
        
        cachable.save()
        setupObservables()
    }
    
    func setupObservables() {
        _ = name.observeNext { text in
            StateManager.shared.person?.name = text ?? ""
        }
        _ = age.observeNext { text in
            StateManager.shared.person?.age = text ?? ""
        }
    }
}

extension PersonModel: Bondable {
    var cachable: Cachable {
        return .person(StateManager.shared.person ?? Person.empty())
    }
}
