//
//  ExerciseViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView

class ExerciseViewController: UIViewController, TabItem {
    
    var tabImage: UIImage? {
      return UIImage(named: "muscle.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
}
