//
//  ViewController.swift
//  SwiftBond
//
//  Created by Bruce Colby on 6/21/18.
//  Copyright © 2018 Bruce Colby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var currentNameTextField: UITextField!
    @IBOutlet weak var currentAgeTextField: UITextField!
    
    @IBOutlet weak var cachedNameTextField: UITextField!
    @IBOutlet weak var cachedAgeTextField: UITextField!
    
    // MARK: - Properties
    lazy var personModel = PersonModel(name: person.name, age: String(person.age))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    // MARK: - Events
    @IBAction func save(_ sender: Any) {
        personModel.cachable.save()
    }
    
    @IBAction func commit(_ sender: Any) {
        personModel.cachable.commit()
    }
    
    @IBAction func rollback(_ sender: Any) {
        personModel.cachable.rollback()
    }
}

// MARK: - Setup
extension ViewController {
    func setupTextFields() {
        personModel.name.bidirectionalBind(to: nameTextField.reactive.text)
        personModel.age.bidirectionalBind(to: ageTextField.reactive.text)
        
        personModel.name.bind(to: currentNameTextField.reactive.text)
        personModel.age.bind(to: currentAgeTextField.reactive.text)
        
        NotificationCenter.default.reactive.notification(name: UserDefaults.didChangeNotification)
            .observeNext { notification in
                guard let person = StateManager.shared.person else { return }
                self.cachedNameTextField.text = person.name
                self.cachedAgeTextField.text = person.age
            }
            .dispose(in: bag)
        
        NotificationCenter.default.reactive.notification(name: Notification.Name.rollback)
            .observeNext { notification in
                guard let person = StateManager.shared.person else { return }
                self.nameTextField.text = person.name
                self.ageTextField.text = person.age
            }
            .dispose(in: bag)
    }
}

// MARK: StateManager
extension ViewController {
    var person : Person {
        guard let person = StateManager.shared.person else { return Person.empty() }
        return person
    }
}
