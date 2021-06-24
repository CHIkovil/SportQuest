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
    
    var achieveView:AchieveView!
    private let achievePresenter = AchievePresenter(achieveService: AchieveService())
    
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
        achievePresenter.setViewDelegate(achieveViewDelegate: self)
        view.frame.size = CGSize(width: 300, height: 300)
        achieveView = AchieveView(frame: view.frame)
        view.addSubview(achieveView!)
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addTargetButton()
        setCollectionDelegate()
    }
}

//MARK: extension
extension AchieveViewController:AchieveViewDelegate{
    func addTargetButton() {
        achieveView.exitButton.addTarget(self, action: #selector(exitAchieve), for: .touchUpInside)
    }
    
    func setCollectionDelegate() {
        achieveView.achieveCollectionView.delegate = self
        achieveView.achieveCollectionView.dataSource = self
    }
}

extension AchieveViewController{
    //MARK: exitAchieve
    @objc func exitAchieve(){
        self.dismiss(animated: true)
    }
}

extension AchieveViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = achievePresenter.getCollectionData()
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        cell.clipsToBounds = true
        
        let data = achievePresenter.getCollectionData()
        
        let gif = UIImageView(frame: CGRect(x: 20, y: 10, width: 100, height: 100))
        gif.layer.cornerRadius = gif.frame.size.width / 2
        gif.layer.borderColor = UIColor.white.cgColor
        gif.layer.borderWidth = 2
        gif.layer.masksToBounds = true
        gif.loadGif(name: data[indexPath.row].gif)
        cell.contentView.addSubview(gif)
        
        let mask = UIImageView(frame: CGRect(x: 20, y: 10, width: 100, height: 100))
        mask.image = UIImage(named: "completed.png")
        mask.layer.cornerRadius = mask.frame.size.width / 2
        mask.clipsToBounds = true
        mask.layer.masksToBounds = true
        mask.layer.borderColor = UIColor.clear.cgColor
        mask.alpha = 0.6
        cell.contentView.addSubview(mask)
        
        let text = UILabel(frame: CGRect(x: 20, y: 100, width: 100, height: 50))
        text.textColor = .white
        text.font = UIFont(name: "Chalkduster", size: 13)
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.layer.borderColor = UIColor.clear.cgColor
        text.text = data[indexPath.row].text
        cell.contentView.addSubview(text)
        
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
