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
    
    private let achieveGif = ["achieve1", "achieve2"]
    private let achieveText = ["First login", "First 100m"]
    private let achieveStore = [0, 150]
    
    var userImage: Data?
    var completedAchieve: [Int]?


    //MARK: UICollectionView
    
    
    
    
    //MARK: achieveCollectionView
    lazy var achieveCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.layer.cornerRadius = 45
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
    
    //MARK: init
     override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
         configure()
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 45
        view.backgroundColor = #colorLiteral(red: 0.2314966023, green: 0.2339388728, blue: 0.2992851734, alpha: 1)
        view.addSubview(achieveCollectionView)
        view.addSubview(exitButton)
        createConstraintsAchieveCollectionView()
        createConstraintsExitButton()
    }
    
    
    
    //MARK: CONSTRAINTS UICollectionView
    
    
    
    
    //MARK: createConstraintsAchieveCollectionView
     func createConstraintsAchieveCollectionView() {
        achieveCollectionView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
     }
    
 
    
    //MARK: CONSTRAINTS UIButton
    
    
    
    
      //MARK: createConstraintsExitButton
     func createConstraintsExitButton() {
         exitButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
         exitButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
         exitButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
         exitButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
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
        return achieveGif.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        cell.clipsToBounds = true
        
        let image = UIImageView(frame: CGRect(x: 20, y: 10, width: 100, height: 100))
        image.layer.cornerRadius = image.frame.size.width / 2
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        image.layer.masksToBounds = true
        image.loadGif(name: achieveGif[indexPath.row])
        
        let mask = UIImageView(frame: CGRect(x: 20, y: 10, width: 100, height: 100))
        mask.image = UIImage(named: "completed.png")
        mask.layer.cornerRadius = image.frame.size.width / 2
        mask.clipsToBounds = true
        mask.layer.masksToBounds = true
        mask.layer.borderColor = UIColor.clear.cgColor
        mask.alpha = 0.6
        
//        if let completedIndex = completedAchieve {
//            if completedIndex.contains(indexPath.row){
//                let mask = maskImageView
//                mask.frame = image.frame
//                image.mask = mask
//            }
//        }

        cell.contentView.addSubview(image)
        cell.contentView.addSubview(mask)
        
        let title = UILabel(frame: CGRect(x: 20, y: 100, width: 100, height: 50))
        title.text = achieveText[indexPath.row]
        title.textColor = .white
        title.font = UIFont(name: "Chalkduster", size: 13)
        title.textAlignment = .center
        title.backgroundColor = .clear
        title.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.addSubview(title)
        
        return cell
    }
    
}

extension AchieveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}

private extension AchieveViewController {
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}
