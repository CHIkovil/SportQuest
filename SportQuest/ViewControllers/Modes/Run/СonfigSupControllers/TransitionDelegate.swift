//
//  TransitionDelegate.swift
//  SportQuest
//
//  Created by Никита Бычков on 05.12.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//
import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
