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
    //MARK: let, var
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTabsControllers()
  
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeViewController)))
        requestNotificationAuthorization()
        sendNotification()
    }
    
    //MARK: setTabsControllers
    func setTabsControllers() {
        let runningViewController = RunViewController()
        runningViewController.enableSwipeNavigation = {[weak self] enable in
            guard let self = self else {return}
            if enable {
                self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.swipeViewController)))
            }else {
                self.view.gestureRecognizers?.removeAll()
            }
        }
        let accountViewController = AccountViewController()
        
        viewControllers = [
            runningViewController,
            accountViewController,
        ]
    }
    
    //MARK: requestNotificationAuthorization
    func requestNotificationAuthorization() {
        self.userNotificationCenter.delegate = self
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    //MARK: sendNotification
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "Test"
        notificationContent.body = "Test body"
        notificationContent.badge = NSNumber(value: 1)

        if let url = Bundle.main.url(forResource: "batman",
                                        withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "batman",
                                                                url: url,
                                                                options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                        repeats: false)
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//
//        dateComponents.weekday = 3  // Tuesday
//        dateComponents.hour = 14  // 14:00 hours
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
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

extension ModesViewController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}



