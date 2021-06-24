//
//  Skills.swift
//  SportQuest
//
//  Created by Никита Бычков on 14.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation

public enum Skills: String, CaseIterable {
    case first = "Ловкость"
    case second = "Выносливость"
    case third = "Сила"

    init?(id : Int) {
        switch id {
        case 0: self = .first
        case 1: self = .second
        case 2: self = .third
        default: return nil
        }
    }
}
