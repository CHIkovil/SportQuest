//
//  AccountService.swift
//  SportQuest
//
//  Created by Никита Бычков on 16.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import Charts

class AccountService {    
    func getChartData(callBack:(RadarChartData?) -> Void){
        let mult: UInt32 = 50
        let min: UInt32 = 50
        let cnt = 3
        
        let block: (Int) -> RadarChartDataEntry = { _ in return RadarChartDataEntry(value: Double(arc4random_uniform(mult) + min))}
        let entries = (0..<cnt).map(block)
        
        let set = RadarChartDataSet(entries: entries, label: "")
        set.setColor(UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1))
        set.fillColor = UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1)
        
        set.fillAlpha = 0.7
        set.lineWidth = 2
        set.drawHighlightCircleEnabled = true
        set.drawFilledEnabled = true
        set.setDrawHighlightIndicators(false)
        
        let data = RadarChartData()
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.white)
        data.dataSets = [set]
        
        callBack(data)
    }
}
