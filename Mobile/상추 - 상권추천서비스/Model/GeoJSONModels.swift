//
//  GeoJSONModels.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/19/24.
//

import Foundation

// GeoJSON 형태 전반에 사용 가능한 구조체로 설계
struct GeoJSON: Codable {
    let type: String // JSON 타입
    let crs: CRS // 좌표계
    let features: [Feature] // JSON 구성 요소들
}

// 좌표계를 나타내는 구조체
struct CRS: Codable {
    let type: String // 좌표계 식별 타입 // name 이면 해당 좌표계의 이름을 가지고 식별
    let properties: CRSProperties // 거의 무조건 urn:ogc:def:crs:OGC:1.3:CRS84 이어서 굳이 struct 안 만들어도 되지만 일단 확장성 위해 추가해 둠
}

// CRS의 properties를 나타내는 구조체
struct CRSProperties: Codable {
    let name: String // 거의 무조건 urn:ogc:def:crs:OGC:1.3:CRS84 이어서 굳이 struct 안 만들어도 되지만 일단 확장성 위해 추가해 둠
}
// 개별 Feature(지역)을 나타내는 구조체
struct Feature: Codable {
    let type: String // Feature로 고정
    let properties: FeatureProperties // 추가 정보
    let geometry: Geometry // Feature의 형상을 나타내며, Point, LineString, Polygon 등의 GeoJSON 지오메트리 타입을 가질 수 있음
}

// Feature(지역)의 속성을 나타내는 구조체
struct FeatureProperties: Codable {
    let SIG_CD: String // "11110"과 같은 자치구 코드
    let SIG_ENG_NM: String // "Jongno-gu"와 같은 영문 자치구명
    let SIG_KOR_NM: String // "종로구"와 같은 한글 자치구명
}

struct Geometry: Codable {
    let type: String
    let coordinates: [[[Double]]] // 폴리곤 좌표 3차원 배열 // 1차 전체 자치구 / 2차 한 폴리곤 / 3차 위도 + 경도의 한 경계점
}







//{
//    "type": "FeatureCollection",
//    "crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:OGC:1.3:CRS84" } },
//    "features" : [
//        {
//            "type": "Feature",
//            "properties": { "SIG_CD": "11110", "SIG_ENG_NM": "Jongno-gu", "SIG_KOR_NM": "종로구" },
//            "geometry": {
//                            "type": "Polygon",
//                            "coordinates" : [
//                                                // 폴리곤 1
//                                                [
//                                                    [위도, 경도], // 시작점
//                                                    [위도, 경도],
//                                                    .
//                                                    .
//                                                    .
//                                                    [위도, 경도] // 끝점 (시작점과 동일)
//                                                ],
//                                                // 폴리곤 2
//                                                [
//                                                    [위도, 경도], // 시작점
//                                                    [위도, 경도],
//                                                    .
//                                                    .
//                                                    .
//                                                    [위도, 경도] // 끝점 (시작점과 동일)
//                                                ]
//                                                .
//                                                .
//                                                .
//                                                // 폴리곤 N
//                                                [
//                                                    [위도, 경도] // 시작점
//                                                    [위도, 경도]
//                                                    .
//                                                    .
//                                                    .
//                                                    [위도, 경도] // 끝점 (시작점과 동일)
//                                                ]
//                                            ]
//                        }
//        }
//    ]
//}
