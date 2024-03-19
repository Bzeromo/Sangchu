//
//  GeoJSONLoader.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/19/24.
//

import Foundation

class GeoJSONLoader {
    // GeoJSON 파일을 로드하고 파싱하는 메서드
    static func loadGeoJSONFile(named fileName: String) -> GeoJSON? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ".geojson"),
              let data = try? Data(contentsOf: url) else {
                  print("GeoJSON 파일을 찾을 수 없습니다.")
                  return nil
              }
        
        do {
            let decoder = JSONDecoder()
            let geoJSONData = try decoder.decode(GeoJSON.self, from: data)
            return geoJSONData
        } catch {
            print("GeoJSON 파싱 중 오류가 발생했습니다: \(error)")
            return nil
        }
    }
}
