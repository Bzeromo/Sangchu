//
//  Item.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/11/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
