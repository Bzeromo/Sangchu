//
//  GeoJSONLoader.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/19/24.
//

import Foundation

// 서울 자치구 25개의 경계에 관한 SeoulBoroughOutlineGeoJSON을 불러오는 클래스
class SeoulBoroughOutlineGeoJSONLoader {
    // SeoulBoroughOutlineGeoJSON 파일을 로드하고 파싱하는 메서드 // fileName으로 Bundle을 통해 프로젝트 내부에서 파일을 찾아 Codable한 SeoulBoroughOutlineGeoJSON 데이터로 변환!
    static func loadGeoJSONFile(named fileName: String) -> SeoulBoroughOutlineGeoJSON? {
        // filename과 파일형식(withExtension)으로 파일 주소를 찾고 해당 데이터를 Data 클래스를 통해 처리
        // Data 바이트 버퍼를 추상화한 것, 데이터의 원시 형태를 나타내며, 파일, 네트워크 데이터, 메모리 내 데이터 등 다양한 형태의 데이터를 처리
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ".geojson"),
              let data = try? Data(contentsOf: url) // 데이터 객체 생성 실패시 nil 반환
                        else {
                                print("서울 자치구에 대한 GeoJSON 파일을 찾을 수 없습니다.")
                                return nil
                             }
        // Bundle로 프로젝트 내에서 해당 이름을 가진 파일을 
        do {
            let decoder = JSONDecoder()
            let geoJSONData = try decoder.decode(SeoulBoroughOutlineGeoJSON.self, from: data)
            // JSON 파일을 decode 해서 SeoulBoroughOutlineGeoJSON화
            return geoJSONData
        } 
        catch {
            print("파싱 중 오류가 발생했습니다: \(error)")
            return nil
        }
    }
}

// 상권 경계에 관한 CommercialDistrictOutlineGeoJSON을 불러오는 클래스
class CommercialDistrictOutlineGeoJSONLoader {
    static func loadGeoJSONFile(named fileName: String) -> CommercialDistrictOutlineGeoJSON? {
        // filename과 파일형식(withExtension)으로 파일 주소를 찾고 해당 데이터를 Data 클래스를 통해 처리
        // Data 바이트 버퍼를 추상화한 것, 데이터의 원시 형태를 나타내며, 파일, 네트워크 데이터, 메모리 내 데이터 등 다양한 형태의 데이터를 처리
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ".geojson"),
              let data = try? Data(contentsOf: url) // 데이터 객체 생성 실패시 nil 반환
                        else {
                                print("상권에 관한 GeoJSON 파일을 찾을 수 없습니다.")
                                return nil
                             }
        // Bundle로 프로젝트 내에서 해당 이름을 가진 파일을
        do {
            let decoder = JSONDecoder()
            let geoJSONData = try decoder.decode(CommercialDistrictOutlineGeoJSON.self, from: data)
            // JSON 파일을 decode 해서 SeoulBoroughOutlineGeoJSON화
            return geoJSONData
        }
        catch {
            print("파싱 중 오류가 발생했습니다: \(error)")
            return nil
        }
    }
}
