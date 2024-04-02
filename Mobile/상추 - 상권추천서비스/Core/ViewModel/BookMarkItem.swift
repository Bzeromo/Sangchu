//
//  BookMarkItem.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/14/24.
//

import Foundation
import SwiftData

@Model
final class BookMarkItem {
    
    // 상권코드 하나당 고유한 북마크
    @Attribute(.unique)
    var cdCode : String // 상권코드
    var cdTitle : String // 상권명
    var latitude: Double
    var longitude: Double
    var userMemo : String // 사용자 메모
    var timestamp : Date // 수정된 날짜
    var cdInfo : String // 상권 정보 인구 수 같은 텍스트 정보
    
    @Attribute(.externalStorage) // 이진 코드로 저장해 외부에 데이터를 저장
    var image : Data? // 카테고리처럼 선택사항으로
    
//    var isImportant : Bool
    
    // inverse는 데이터 무결성을 보장함
    // cascade를 하면 북마크를 삭제하면 카테고리도 삭제된다
    @Relationship(deleteRule : .nullify, inverse: \Hashtag.items)
    var hashtag : Hashtag?
    
    init(cdCode : String = "", userMemo : String = "", timestamp : Date = .now, latitude : Double = 1.1, longitude : Double = 1.1, cdTitle : String = "", cdInfo : String = "", isImportant : Bool = false ){
        self.cdCode = cdCode
        self.userMemo = userMemo
        self.timestamp = timestamp
        self.cdTitle = cdTitle
        self.cdInfo = cdInfo
        self.latitude = latitude
        self.longitude = longitude
//        self.isImportant = isImportant
    }
    
    
}
