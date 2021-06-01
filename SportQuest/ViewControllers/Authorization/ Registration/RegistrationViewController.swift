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
    
    //MARK: let, var
    let race = ["human", "orc","elf", "gnome"]
    
    
    //MARK: PickerView
    lazy var racePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
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
    
    lazy var raceRegistrationField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Race"
        textField.placeholderColor = .lightGray
        textField.placeholderFontScale = 0.8
        textField.borderActiveColor = .black
        textField.borderInactiveColor = .lightGray
        textField.textColor = .lightGray
        textField.tintColor = .lightGray
        textField.delegate = self
        textField.tintColor = .clear
        return textField
    }()
    
    lazy var hobbyRegistrationField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Hobby"
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
        view.addSubview(raceRegistrationField)
        view.addSubview(nicknameRegistrationField)
        view.addSubview(passwordRegistrationField)
        view.addSubview(hobbyRegistrationField)
        raceRegistrationField.inputView = racePickerView
        createConstraintsUserImageView()
        createConstraintsRaceRegistrationField()
        createConstraintsNicknameRegistrationField()
        createConstraintsPasswordRegistrationField()
        createConstraintsHobbyRegistrationField()
    }
    
    //MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: ConstraintsImageView
    func createConstraintsUserImageView() {
        userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
    }
    
    //MARK: ConstraintsField
    func createConstraintsRaceRegistrationField() {
        raceRegistrationField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        raceRegistrationField.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20).isActive = true
        raceRegistrationField.widthAnchor.constraint(equalToConstant: 145).isActive = true
        raceRegistrationField.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsNicknameRegistrationField() {
        nicknameRegistrationField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nicknameRegistrationField.topAnchor.constraint(equalTo: raceRegistrationField.bottomAnchor, constant: 5).isActive = true
        nicknameRegistrationField.widthAnchor.constraint(equalToConstant: 145).isActive = true
        nicknameRegistrationField.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsPasswordRegistrationField() {
        passwordRegistrationField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordRegistrationField.topAnchor.constraint(equalTo: nicknameRegistrationField.bottomAnchor, constant: 5).isActive = true
        passwordRegistrationField.widthAnchor.constraint(equalToConstant: 145).isActive = true
        passwordRegistrationField.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsHobbyRegistrationField() {
        hobbyRegistrationField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hobbyRegistrationField.topAnchor.constraint(equalTo: passwordRegistrationField.bottomAnchor, constant: 5).isActive = true
        hobbyRegistrationField.widthAnchor.constraint(equalToConstant: 145).isActive = true
        hobbyRegistrationField.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
}

//MARK: extension
extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return race.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return race[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        raceRegistrationField.text = race[row]
        userImageView.image = UIImage(named: "\(race[row]).png")

        raceRegistrationField.resignFirstResponder()
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

