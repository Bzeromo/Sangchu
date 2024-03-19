//
//  HashTagJSONDecoder.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/18/24.
//

import Foundation

struct HashTagResponse : Decodable{ // Decoding가능으로 표시해줘야함
    let title : String
}

struct HashTagJSONDecoder {
    static func decode(from fileName : String) -> [HashTagResponse]{
        // vkdlfdmf fhzjfdptj rkwudhsenl elzhelddmf godigka
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let hashtags = try? JSONDecoder().decode([HashTagResponse].self,from : data)else{
            return []
        }
        
        return hashtags
    }
}
