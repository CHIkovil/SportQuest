//
//  AchievePresenter.swift
//  SportQuest
//
//  Created by Никита Бычков on 18.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation

class AchievePresenter {
    private let achieveService:AchieveService
    weak private var achieveViewDelegate : AchieveViewDelegate?
    
    init(achieveService:AchieveService){
        self.achieveService = achieveService
    }
    
    func setViewDelegate(achieveViewDelegate:AchieveViewDelegate?){
        self.achieveViewDelegate = achieveViewDelegate
    }
    
    func getCollectionData() -> [Achieve]{
        return achieveService.getAchieveData()
    }
    
}
