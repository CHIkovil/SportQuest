//
//  QuotesModel.swift
//  SportQuest
//
//  Created by Никита Бычков on 11.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation


struct QuotesModel: Codable {
    let text: String
    let author: String?
}

typealias Quotes = [QuotesModel]
