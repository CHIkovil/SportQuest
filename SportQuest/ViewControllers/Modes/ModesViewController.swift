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
    private func setTabsControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let graveViewController = storyboard.instantiateViewController(withIdentifier: "JoggingViewController")
        let bumpkinViewController = storyboard.instantiateViewController(withIdentifier: "ExerciseViewController")

        viewControllers = [
            SearchViewController,
            JoggingViewController,
            ExerciseViewController,
            AccountViewController,
          
        ]
    }
}



