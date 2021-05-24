//
//  AccountViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView

class AccountViewController: UIViewController, TabItem {
     //MARK: UIImageView
    
    
    
    //MARK: userImageView
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "unicorn.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 4
        return imageView
    }()
    
    
    //MARK: UITextField
    
    
    
    // MARK: setupDistanceTextField
    lazy var setupDistanceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "12000m"
        textField.font = UIFont(name: "Chalkduster", size: 12)
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.textColor = .gray
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 20
        return textField
    }()
    
    //MARK: UILabel
    
    
    
    
    // MARK: levelLabel
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lvl 1"
        label.font = UIFont(name: "Chalkduster", size: 17)
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor.clear.cgColor
        return label
    }()
    
    // MARK: lineCompleteLevelLabel
    lazy var lineCompleteLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .green
        label.layer.cornerRadius = 20
        return label
    }()
    
    // MARK: lineLevelLabel
    lazy var lineLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.layer.cornerRadius = 20
        return label
    }()
    
    // MARK: setupDistanceLabel
    lazy var setupDistanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Distance"
        label.font = UIFont(name: "Chalkduster", size: 12)
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor.clear.cgColor
        return label
    }()

    
    
    //MARK: UIButton
    
    
    
    
    //MARK: achieveButton
    lazy var achieveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"wreath.png"), for: .normal)
        button.addTarget(self, action: #selector(showAchieve), for: .touchUpInside)
        return button
    }()
    
    //MARK: logOutButton
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"logout.png"), for: .normal)
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return button
    }()
    
    //MARK: tabImage
    var tabImage: UIImage? {
      return UIImage(named: "account.png")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(userImageView)
        view.addSubview(levelLabel)
        view.addSubview(lineLevelLabel)
        view.addSubview(lineCompleteLevelLabel)
        view.addSubview(setupDistanceLabel)
        view.addSubview(setupDistanceTextField)
        view.addSubview(achieveButton)
        view.addSubview(logOutButton)
        
        createConstraintsUserImageView()
        createConstraintsLevelLabel()
        createConstraintsLineLevelLabel()
        createConstraintsLineCompleteLevelLabel()
        createConstraintsSetupDistanceLabel()
        createConstraintsSetupDistanceTextField()
        createConstraintsAchieveButton()
        createConstraintsLogOutButton()
    }
    
    //MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
     // MARK: CONSTRAINTS UIImageView
    
    
    
    
    //MARK: createConstraintsUserImageView
    func createConstraintsUserImageView() {
        userImageView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userImageView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
    }
    
    
    // MARK: CONSTRAINTS UITextField
    
    
    
    //MARK: createConstraintsSetupDistanceTextField
    func createConstraintsSetupDistanceTextField() {
        setupDistanceTextField.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: setupDistanceLabel.centerYAnchor).isActive = true
        setupDistanceTextField.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: setupDistanceLabel.trailingAnchor, constant: 10).isActive = true
        
    }
    
    
    
     // MARK: CONSTRAINTS UILabel
    
    
    
    //MARK: createConstraintsLevelLabel
    func createConstraintsLevelLabel() {
        levelLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: lineLevelLabel.leadingAnchor,constant: -10).isActive = true
        levelLabel.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: lineLevelLabel.centerYAnchor).isActive = true
    }
    
    //MARK: createConstraintsLineCompleteLevelLabel
    func createConstraintsLineCompleteLevelLabel() {
        lineCompleteLevelLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: lineLevelLabel.leadingAnchor).isActive = true
        lineCompleteLevelLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: lineLevelLabel.trailingAnchor,constant: -20).isActive = true
        lineCompleteLevelLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: lineLevelLabel.topAnchor).isActive = true
        lineCompleteLevelLabel.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: lineLevelLabel.bottomAnchor).isActive = true
    }
    
    //MARK: createConstraintsLineLevelLabel
    func createConstraintsLineLevelLabel() {
        lineLevelLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 10).isActive = true
        lineLevelLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor).isActive = true
        lineLevelLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50).isActive = true
        lineLevelLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    //MARK: createConstraintsSetupDistanceLabel
    func createConstraintsSetupDistanceLabel() {
        setupDistanceLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: levelLabel.leadingAnchor).isActive = true
        setupDistanceLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: levelLabel.bottomAnchor,constant: 10).isActive = true
    }
    
    
    
    
    //MARK: CONSTRAINTS UIButton
    
    
    
    
    //MARK: createConstraintsAchieveButton
    func createConstraintsAchieveButton() {
        achieveButton.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: lineLevelLabel.centerYAnchor).isActive = true
        achieveButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: lineLevelLabel.trailingAnchor, constant: 10).isActive = true
       achieveButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
       achieveButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK: createConstraintsLogOutButton
    func createConstraintsLogOutButton() {
        logOutButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        logOutButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        logOutButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
        logOutButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK: objc
    
    //MARK: showAchieve
    @objc func showAchieve(){
        
    }
    
    //MARK: logOut
    @objc func logOut(){
        
    }
}

