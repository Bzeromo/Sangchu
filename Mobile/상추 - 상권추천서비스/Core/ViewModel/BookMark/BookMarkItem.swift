//
//  BookMarkItem.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/14/24.
//

import Foundation
import SwiftData

@Model
final class BookMarkItem {
    
    // 상권코드 하나당 고유한 북마크
    @Attribute(.unique)
    var cdCode : String
    
    var userMemo : String
    var timestamp : Date
    var cdTitle : String
    var cdInfo : String
    var isImportant : Bool
    
    // inverse는 데이터 무결성을 보장함
    // cascade를 하면 북마크를 삭제하면 카테고리도 삭제된다
    @Relationship(deleteRule : .nullify, inverse: \Hashtag.items)
    var hashtag : Hashtag?
    
    init(cdCode : String = "", userMemo : String = "", timestamp : Date = .now, cdTitle : String = "", cdInfo : String = "", isImportant : Bool = false ){
        self.cdCode = cdCode
        self.userMemo = userMemo
        self.timestamp = timestamp
        self.cdTitle = cdTitle
        self.cdInfo = cdInfo
        self.isImportant = isImportant
    }
    
    
}
