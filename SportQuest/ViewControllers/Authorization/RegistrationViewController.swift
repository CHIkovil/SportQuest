//
//  Registration.swift
//  SportQuest
//
//  Created by Никита Бычков on 04.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    //MARK: ImageView
    lazy var userImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "camera.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 4
        return imageView
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(userImageView)
        createConstraintsUserImageView()
    }
    
    //MARK: ConstraintsImageView
    func createConstraintsUserImageView() {
        userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
    }
}
