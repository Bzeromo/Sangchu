//
//  GeoJSONModels.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/19/24.
//

import Foundation

// -[서울 자치구 경계선]--------------------------------------------------------------------------------------------------------------------------------------- //

// 서울 자치구 경계선용 구조체
struct SeoulBoroughOutlineGeoJSON: Codable {
    let type: String // JSON 타입
    let crs: CRS // 좌표계
    let features: [SBFeature] // JSON 구성 요소들
}

// 좌표계를 나타내는 구조체 // CRS - Coordinate Reference System
struct CRS: Codable {
    let type: String // 좌표계 식별 타입 // name 이면 해당 좌표계의 이름을 가지고 식별
    let properties: CRSProperties // 세계적으로 거의 무조건 urn:ogc:def:crs:OGC:1.3:CRS84 이어서 굳이 struct 안 만들어도 되지만 일단 확장성 위해 추가해 둠
}

// CRS의 properties를 나타내는 구조체
struct CRSProperties: Codable {
    let name: String // 거의 무조건 urn:ogc:def:crs:OGC:1.3:CRS84 이어서 굳이 struct 안 만들어도 되지만 일단 확장성 위해 추가해 둠
}

// 개별 Feature(자치구)를 나타내는 구조체
struct SBFeature: Codable {
    let type: String // Feature로 고정
    let properties: SBFeatureroperties // 추가 정보
    let geometry: SBGeometry // Feature의 형상을 나타내며, Point, LineString, Polygon 등의 GeoJSON 지오메트리 타입을 가질 수 있음
}

// Feature(자치구)의 속성들을 나타내는 구조체
struct SBFeatureroperties: Codable {
    let SIG_CD: String // "11110"과 같은 자치구 코드
    let SIG_ENG_NM: String // "Jongno-gu"와 같은 영문 자치구명
    let SIG_KOR_NM: String // "종로구"와 같은 한글 자치구명
}

// 자치구 경계선 관련 좌표들
struct SBGeometry: Codable {
    let type: String
    let coordinates: [[[Double]]] // 폴리곤 좌표 3차원 배열 // 1차 전체 자치구 / 2차 한 폴리곤 / 3차 위도 + 경도의 한 경계점
}

// -[상권 경계선]--------------------------------------------------------------------------------------------------------------------------------------- //

enum CoordinatesType: Codable {
    case polygon([[[Double]]])
    case multiPolygon([[[[Double]]]])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let multiPolygonCoordinates = try container.decode([[[[Double]]]].self)
            self = .multiPolygon(multiPolygonCoordinates)
        } catch {
            let polygonCoordinates = try container.decode([[[Double]]].self)
            self = .polygon(polygonCoordinates)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .polygon(let coordinates):
            try container.encode(coordinates)
        case .multiPolygon(let coordinates):
            try container.encode(coordinates)
        }
    }
}


// 서울 상권 경계선용 구조체
struct CommercialDistrictOutlineGeoJSON: Codable {
    let type : String
    let features: [CDFeature]
}

// 개별 Feature(상권)을 나타내는 구조체
struct CDFeature : Codable {
    let properties : CDProperties
    let geometry : CDGeometry
}

// Feature(상권)의 속성들을 나타내는 구조체
struct CDProperties : Codable {
    let TRDAR_SE_C : String //
    let TRDAR_SE_1 : String //
    let TRDAR_CD : String //
    let TRDAR_CD_N : String //
    let XCNTS_VALU : Double //
    let YDNTS_VALU : Double //
    let SIGNGU_CD : String // 자치구 코드
    let SIGNGU_CD_ : String // 자치구 이름
    let ADSTRD_CD : String // 행정동 코드
    let ADSTRD_CD_ : String // 행정동 이름
    let RELM_AR : Double //
}

// 상권 경계선 관련 좌표들
struct CDGeometry: Codable {
    let type: String
    let coordinates: CoordinatesType
}

//  [ 서울시 자치구 폴리곤]
/*
{
    "type": "FeatureCollection",
    "crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:OGC:1.3:CRS84" } },
    "features" : [
        {
            "type": "Feature",
            "properties": { "SIG_CD": "11110", "SIG_ENG_NM": "Jongno-gu", "SIG_KOR_NM": "종로구" },
            "geometry": {
                            "type": "Polygon",
                            "coordinates" : [
                                                // 폴리곤 1
                                                [
                                                    [위도, 경도], // 시작점
                                                    [위도, 경도],
                                                    .
                                                    .
                                                    .
                                                    [위도, 경도] // 끝점 (시작점과 동일)
                                                ],
                                                // 폴리곤 2
                                                [
                                                    [위도, 경도], // 시작점
                                                    [위도, 경도],
                                                    .
                                                    .
                                                    .
                                                    [위도, 경도] // 끝점 (시작점과 동일)
                                                ]
                                                .
                                                .
                                                .
                                                // 폴리곤 N
                                                [
                                                    [위도, 경도] // 시작점
                                                    [위도, 경도]
                                                    .
                                                    .
                                                    .
                                                    [위도, 경도] // 끝점 (시작점과 동일)
                                                ]
                                            ]
                        }
        }
    ]
}


*/

//  [ 서울시 상권 폴리곤]

/*
{
    "type" : "FeatureCollection",
    "features" : [
        "properties": { 
            "TRDAR_SE_C": "A",
            "TRDAR_SE_1": "골목상권",
            "TRDAR_CD": "3110031",
            "TRDAR_CD_N": "창신역 1번",
            "XCNTS_VALU": 201298.0,
            "YDNTS_VALU": 453314.0,
            "SIGNGU_CD": "11110",
            "SIGNGU_CD_": "종로구",
            "ADSTRD_CD": "11110690",
            "ADSTRD_CD_": "창신3동",
            "RELM_AR": 32878.0 },
            "geometry": {
                "type": "Polygon",
                "coordinates": [
                                    [
                                        [ 127.015455188128982, 37.580664405418219 ],
                                        [ 127.015557972365059, 37.580602153067801 ],
                                        .
                                        .
                                        .
                                        [ 127.015455188128982, 37.580664405418219 ]
                                    ]
                                ]
                        }
                ]
}
*/
