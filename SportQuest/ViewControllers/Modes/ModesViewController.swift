//
//  ModesViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView

class ModesViewController: AMTabsViewController{
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTabsControllers()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeViewController)))
    }
    
    //MARK: setTabsControllers
    func setTabsControllers() {
        let runningViewController = RunViewController()
        let accountViewController = AccountViewController()

        viewControllers = [
            runningViewController,
            accountViewController,
        ]
    }
    
    //MARK: swipeViewController
    @objc func swipeViewController(_ sender: UIPanGestureRecognizer){
        if (sender.state == .ended) {
            let velocity = sender.velocity(in: self.view)
            if (velocity.x > 0) { // Coming from left
                selectedTabIndex = 0
            } else { // Coming from right
                selectedTabIndex = 1
            }
        }
    }
}



