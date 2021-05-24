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
    
    // MARK: userLevelLabel
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lvl"
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
        label.textColor = .green
        return label
    }()
    
    // MARK: lineLevelLabel
    lazy var lineLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
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
    
    
    // MARK: achieveButton
    lazy var achieveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"exit.png"), for: .normal)
        button.addTarget(self, action: #selector(showAchieve), for: .touchUpInside)
        return button
    }()
    
    var tabImage: UIImage? {
      return UIImage(named: "account.png")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
    
    //MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: objc
    @objc func showAchieve(){
        
    }
}

