//
//  ProgressMapService.swift
//  SportQuest
//
//  Created by Никита Бычков on 22.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation

class ProgressMapService {
    let progress: Progress?
    
    init(data: Progress) {
        self.progress = data
    }
    
    func getRunProgress(callback:(Progress?)-> Void) {
        guard let progress = progress else {
            callback(nil)
            return
        }
        callback(progress)
    }
    
}
