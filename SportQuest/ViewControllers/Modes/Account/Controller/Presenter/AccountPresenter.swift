//
//  AccountPresenter.swift
//  SportQuest
//
//  Created by Никита Бычков on 17.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import Charts

class AccountPresenter {
    private let accountService:AccountService
    weak private var accountViewDelegate : AccountViewDelegate?
    
    init(accountService:AccountService){
        self.accountService = accountService
    }
    
    func setViewDelegate(accountViewDelegate:AccountViewDelegate?){
        self.accountViewDelegate = accountViewDelegate
    }
    
    //MARK: displayChartData
    func setChartData(){
        accountService.getChartData {[weak self] data in
            guard let self = self else{return}
            if let data = data{
                self.accountViewDelegate!.displayChartData(data: data)
            }
        }
    }
}
