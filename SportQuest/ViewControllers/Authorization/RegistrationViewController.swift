//
//  Registration.swift
//  SportQuest
//
//  Created by Никита Бычков on 04.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import TextFieldEffects

class RegistrationViewController: UIViewController {
    
    //MARK: ImageView
    lazy var userImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "unicorn.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 4
        return imageView
    }()
    
    //MARK: Field
    lazy var nicknameRegistrationField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Nickname"
        textField.placeholderColor = .lightGray
        textField.placeholderFontScale = 0.8
        textField.borderActiveColor = .black
        textField.borderInactiveColor = .lightGray
        textField.textColor = .lightGray
        textField.tintColor = .lightGray
        return textField
    }()
    
    lazy var passwordRegistrationField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Password"
        textField.placeholderColor = .lightGray
        textField.placeholderFontScale = 0.8
        textField.borderActiveColor = .black
        textField.borderInactiveColor = .lightGray
        textField.textColor = .lightGray
        textField.tintColor = .lightGray
        return textField
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(userImageView)
        view.addSubview(nicknameRegistrationField)
        view.addSubview(passwordRegistrationField)
        createConstraintsUserImageView()
        createConstraintsNicknameRegistrationField()
        createConstraintsPasswordRegistrationField()
    }
    
    //MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: ConstraintsImageView
    func createConstraintsUserImageView() {
        userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
    }
    
    //MARK: ConstraintsField
    func createConstraintsNicknameRegistrationField() {
        nicknameRegistrationField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nicknameRegistrationField.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20).isActive = true
        nicknameRegistrationField.widthAnchor.constraint(equalToConstant: 145).isActive = true
        nicknameRegistrationField.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsPasswordRegistrationField() {
        passwordRegistrationField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordRegistrationField.topAnchor.constraint(equalTo: nicknameRegistrationField.bottomAnchor, constant: 5).isActive = true
        passwordRegistrationField.widthAnchor.constraint(equalToConstant: 145).isActive = true
        passwordRegistrationField.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
}
