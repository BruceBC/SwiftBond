//
//  Cachable.swift
//  SwiftBond
//
//  Created by Bruce Colby on 6/22/18.
//  Copyright © 2018 Bruce Colby. All rights reserved.
//

import Foundation

// MARK: - Cases
enum Cachable {
    case person(Person)
}

// Mark: - Public
extension Cachable {
    func save() {
        switch self {
        case .person(let model):
            guard let encoded = try? encoder.encode(model) else { return }
            saveToCache(encoded, key: .person)
        }
    }
    
    func commit() {
        switch self {
        case .person:
            removeCacheItem(key: .person)
        }
    }
    
    func rollback() {
        rollbackFromCache(key: .person)
    }
}

// MARK: - Private
extension Cachable {
    private func saveToCache(_ data: Data, key: Key) {
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }
    
    private func removeCacheItem(key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    private func rollbackFromCache(key: Key) {
        switch self {
        case .person:
            if let cachedModel = cachedModel(key), let model = try? decoder.decode(Person.self, from: cachedModel) {
                Rollback.person(model).perform()
            }
        }
    }
    
    private func cachedModel(_ key: Key) -> Data? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? Data
    }
    
    private var encoder: JSONEncoder {
        return JSONEncoder()
    }
    
    private var decoder: JSONDecoder {
        return JSONDecoder()
    }
    
    private enum Key: String {
        case person = "person"
    }
    
    private enum Rollback {
        case person(Person)
        
        func perform() {
            switch self {
            case .person(let model):
                StateManager.shared.person = model
            }
            
            // Post notification
            NotificationCenter.default.post(name: .rollback, object: nil)
        }
    }
}
