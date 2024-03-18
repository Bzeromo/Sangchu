//
//  CategoryItem.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/14/24.
//

import SwiftUI
import SwiftData

@Model
class Hashtag {
    
    @Attribute(.unique)
    var title : String
    
    var items : [BookMarkItem]?
    
    init(title: String = ""){
        self.title = title
    }
    
}
