//
//  AchieveViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 01.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin

class AchieveViewController: UIViewController {
    private var customTransitioningDelegate = TransitionDelegate()
    
    private let achieveImage = ["achieve1.gif", "achieve2.gif"]
    private let achieveText = ["First login", "First 100m"]
    private let achieveStore = [0, 150]
    
    var userImage: Data?
    var completedAchieve: [Int]?


    //MARK: UICollectionView
    
    
    
    
    //MARK: achieveCollectionView
    lazy var achieveCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: UIImageView
    
    
    
    //MARK: maskImageView
    lazy var maskImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "completed.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 4
        imageView.alpha = 0.4
        return imageView
    }()
    
    //MARK: exitButton
    
    

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
        button.addTarget(self, action: #selector(exitAchieve), for: .touchUpInside)
        return button
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(achieveCollectionView)
        view.addSubview(exitButton)
        
        createConstraintsAchieveCollectionView()
        createConstraintsExitButton()
    }
    
    
    
    //MARK: CONSTRAINTS UICollectionView
    
    
    
    
    //MARK: createConstraintsAchieveCollectionView
     func createConstraintsAchieveCollectionView() {
        achieveCollectionView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
     }
    
 
    
    //MARK: CONSTRAINTS UIButton
    
    
    
    
      //MARK: createConstraintsExitButton
     func createConstraintsExitButton() {
         exitButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: achieveCollectionView.topAnchor, constant: 10).isActive = true
         exitButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: achieveCollectionView.trailingAnchor, constant: -10).isActive = true
         exitButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
         exitButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 454).isActive = true
     }
    
    //MARK: exitAchieve
    @objc func exitAchieve(){
        self.dismiss(animated: true)
    }
}


//MARK: extension
extension AchieveViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achieveImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        cell.clipsToBounds = true
        
        let image : UIImageView = UIImageView(frame: CGRect(x: 10, y: 2.5, width: 50, height: 50))
        image.image = UIImage(named:  achieveImage[indexPath.row])
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.borderWidth = 4
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        
        if let completedIndex = completedAchieve {
            if completedIndex.contains(indexPath.row){
                let mask = maskImageView
                mask.frame = image.frame
                image.mask = mask
            }
        }
        
        cell.addSubview(image)
   
        let title = UILabel(frame: CGRect(x: 10, y: 55, width: 100, height: 50))
        title.text = achieveText[indexPath.row]
        title.textColor = .white
        title.font = UIFont(name: "TrebuchetMS", size: 18)
        title.textAlignment = .center
        title.backgroundColor = .clear
        title.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.addSubview(title)
        
        return cell
    }
    
    
}

private extension AchieveViewController {
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}
