//
//  ViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 30.09.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import TextFieldEffects

class AuthorizationViewController: UIViewController {
    //MARK: Field
    lazy var nicknameField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 21)
        textField.placeholder = "Enter nickname"
        textField.placeholderFontScale = 1
        textField.borderInactiveColor = .lightGray
        textField.borderActiveColor = .black
        textField.placeholderColor = .lightGray
        textField.textColor = .lightGray
        textField.tintColor = .lightGray
        return textField
    }()
    
    lazy var passwordField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 21)
        textField.placeholder = "Enter password"
        textField.placeholderFontScale = 1
        textField.borderInactiveColor = .lightGray
        textField.borderActiveColor = .black
        textField.placeholderColor = .lightGray
        textField.textColor = .lightGray
        textField.tintColor = .lightGray
        return textField
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(nicknameField)
        view.addSubview(passwordField)
        createConstraintsNicknameField()
        createConstraintsPasswordField()
    }
    //MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: ConstraintsField
    func createConstraintsNicknameField() {
        nicknameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nicknameField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        nicknameField.widthAnchor.constraint(equalToConstant: 195).isActive = true
        nicknameField.heightAnchor.constraint(equalToConstant: 50).isActive =  true
    }
    
    func createConstraintsPasswordField() {
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 20).isActive = true
        passwordField.widthAnchor.constraint(equalToConstant: 195).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive =  true
    }
}
