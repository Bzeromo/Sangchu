//
//  ItemsContainer.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/18/24.
//

import Foundation
import SwiftData

actor ItemsContainer{
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer{
        // 모델 컨테이너가 사용할 스키마를 정의하는 단계
        // 몇가지 기본 해시태그를 추가할거임
        let schema = Schema([BookMarkItem.self])
        // 해시태그 스키마는 지정할 필요가없음 why? BookMarkItem을 정의한 시점에서 자동으로 된다.
        let configuration = ModelConfiguration()
        // 모델을 자동적으로 구성해주는 역할
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults{
            
            // JSON파일을 디코드 해서 초기값을 설정하는 방법
            let hashtags = HashTagJSONDecoder.decode(from: "HashTagDefaults") // HashTagDefaults 파일을 디코드함
            // 비어있지않으면 루프만하고 실제로 컨텍스트에 삽입함
            if hashtags.isEmpty == false{
                // 1대1 매핑
                hashtags.forEach{ item in
                    let hashtag = Hashtag(title: item.title)
                    container.mainContext.insert(hashtag)
                }
            }
            shouldCreateDefaults = false
            
            // 해당 model에서 Extension으로 초기값을 구성하는 방법
            Hashtag.defaults.forEach{ container.mainContext.insert($0)}
        }
        
        return container
    }
}
