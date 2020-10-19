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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTabsControllers()
    }
    
    func setTabsControllers() {
        let searchViewController = SearchViewController()
        let joggingViewController = JoggingViewController()
        let exerciseViewController = ExerciseViewController()
        let accountViewController = AccountViewController()

        viewControllers = [
            searchViewController,
            joggingViewController,
            exerciseViewController,
            accountViewController,
        ]
    }
}



