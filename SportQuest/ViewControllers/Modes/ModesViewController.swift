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
    }
    
    //MARK: setTabsControllers
    func setTabsControllers() {
        let runningViewController = RunViewController()
        let exerciseViewController = ExerciseViewController()
        let accountViewController = AccountViewController()

        viewControllers = [
            runningViewController,
            exerciseViewController,
            accountViewController,
        ]
    }
}



