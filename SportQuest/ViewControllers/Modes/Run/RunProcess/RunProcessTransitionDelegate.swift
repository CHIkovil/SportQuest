//
//  RunProcessTransitionDelegate.swift
//  SportQuest
//
//  Created by Никита Бычков on 05.12.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//
import UIKit

class RunProcessTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return RunProcessPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
