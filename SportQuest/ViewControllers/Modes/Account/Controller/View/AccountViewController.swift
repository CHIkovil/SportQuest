//
//  AccountViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView
import Charts

class AccountViewController: UIViewController, TabItem {
    
    var accountView:AccountView?
    private let accountPresenter = AccountPresenter(accountService: AccountService())
    
    //MARK: tabImage
    var tabImage: UIImage? {
      return UIImage(named: "account.png")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        accountPresenter.setViewDelegate(accountViewDelegate: self)
        accountView = AccountView(frame: view.frame)
        view.addSubview(accountView!)
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addTargetButton()
        accountPresenter.displayChartData()
    }
    
    //MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: extension
extension AccountViewController:AccountViewDelegate{
    func addTargetButton() {
        guard let accountView = accountView else {return}
        accountView.achieveButton.addTarget(self, action: #selector(showAchieve), for: .touchUpInside)
        accountView.logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    
    func setChartData(data: RadarChartData) {
        guard let accountView = accountView else {return}
        accountView.skillsChartView.xAxis.valueFormatter = self
        accountView.skillsChartView.data = data
        accountView.skillsChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
}

extension AccountViewController{
    
    //MARK: showAchieve
    @objc func showAchieve(){
        let viewController = AchieveViewController()
        self.present(viewController, animated: true)
    }
    
    //MARK: logOut
    @objc func logOut(){
        
    }
}

extension AccountViewController:IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = accountPresenter.getValueFormatter()
        return formatter[Int(value) % formatter.count].value
    }
}

