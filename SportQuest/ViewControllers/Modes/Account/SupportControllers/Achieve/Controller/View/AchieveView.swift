//
//  AchieveView.swift
//  SportQuest
//
//  Created by Никита Бычков on 17.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit

//MARK: protocol
protocol AchieveViewDelegate:NSObjectProtocol {
    func addTargetButton()
    func setCollectionDelegate()
}

class AchieveView: UIView {
    
    //MARK: UICollectionView
    
    
    
    //MARK: achieveCollectionView
    lazy var achieveCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.bounces = true
        collectionView.layer.cornerRadius = 45
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: UIButton
    
    
    
    //MARK: exitButton
    lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"exit.png"), for: .normal)
        return button
    }()
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 45
        self.backgroundColor = #colorLiteral(red: 0.2314966023, green: 0.2339388728, blue: 0.2992851734, alpha: 1)
        self.addSubview(achieveCollectionView)
        self.addSubview(exitButton)
        createConstraintsAchieveCollectionView()
        createConstraintsExitButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: CONSTRAINTS
    
    
    
    //MARK: CONSTRAINTS UICollectionView
    
    
    
    //MARK: createConstraintsAchieveCollectionView
    func createConstraintsAchieveCollectionView() {
        achieveCollectionView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    //MARK: CONSTRAINTS UIButton
    
    
    
    //MARK: createConstraintsExitButton
    func createConstraintsExitButton() {
        exitButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        exitButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        exitButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
        exitButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
