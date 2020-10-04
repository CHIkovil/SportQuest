//
//  ViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 30.09.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import TextFieldEffects
import DWAnimatedLabel
import WCLShineButton

class AuthorizationViewController: UIViewController {
    
    //MARK: Button
    lazy var authorizationButton: WCLShineButton = {
        var param = WCLShineParams()
        param.shineCount = 0
        param.shineSize = 0
        let button = WCLShineButton(frame: .init(x: 0, y: 0, width: 85, height: 85), params: param)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.image = .custom(UIImage(named: "seal.png")!)
        button.color = .lightGray
        button.fillColor = .lightGray
        button.addTarget(self, action: #selector(userAuthorization), for: .valueChanged)
        return button
    }()
    
    lazy var registrationButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Registration", for: .normal)
        button.titleLabel?.font = UIFont(name: "Chalkduster", size: 12)
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(registration), for: .touchUpInside)
        return button
    }()
    
    //MARK: Label
    lazy var applicationTitleLabel: DWAnimatedLabel = {
        let label = DWAnimatedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SportQuest"
        label.font = UIFont(name: "Chalkduster", size: 50)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.animationType = .shine
        return label
    }()
    
    //MARK: Field
    lazy var nicknameField: YoshikoTextField = {
        let textField = YoshikoTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Nickname"
        textField.placeholderColor = .white
        textField.placeholderFontScale = 1.2
        textField.activeBackgroundColor = .white
        textField.activeBorderColor = .lightGray
        textField.inactiveBorderColor = .lightGray
        textField.borderSize = 0.5
        textField.textColor = .lightGray
        textField.tintColor = .lightGray
        return textField
    }()
    
    lazy var passwordField: YoshikoTextField = {
        let textField = YoshikoTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Password"
        textField.placeholderColor = .white
        textField.placeholderFontScale = 1.2
        textField.activeBackgroundColor = .white
        textField.activeBorderColor = .lightGray
        textField.inactiveBorderColor = .lightGray
        textField.borderSize = 0.5
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
        view.addSubview(applicationTitleLabel)
        view.addSubview(authorizationButton)
        view.addSubview(registrationButton)
        createConstraintsNicknameField()
        createConstraintsPasswordField()
        createConstraintsApplicationTitleLabel()
        createConstraintsAuthorizationButton()
        createConstraintsRegistrationButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        applicationTitleLabel.startAnimation(duration: 7, .none)
    }
    
    //MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: ConstraintsField
    func createConstraintsNicknameField() {
        nicknameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nicknameField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        nicknameField.widthAnchor.constraint(equalToConstant: 145).isActive = true
        nicknameField.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsPasswordField() {
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 5).isActive = true
        passwordField.widthAnchor.constraint(equalToConstant: 145).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    //MARK: ConstraintsLabel
    func createConstraintsApplicationTitleLabel() {
        applicationTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        applicationTitleLabel.bottomAnchor.constraint(equalTo: nicknameField.topAnchor).isActive = true
    }
    
    //MARK: ConstraintsButton
    func createConstraintsAuthorizationButton() {
        authorizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        authorizationButton.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 20).isActive = true
        authorizationButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        authorizationButton.heightAnchor.constraint(equalToConstant: 85).isActive = true
    }
    
    func createConstraintsRegistrationButton() {
        registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registrationButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 12).isActive = true
        registrationButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    //MARK: objc
    @objc func userAuthorization() {

    }
    
    @objc func registration() {

    }
}
