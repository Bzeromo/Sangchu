//
//  BookMarkNetworkManager.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/27/24.
//

import Foundation
import Alamofire

class BookMarkNetworkManager {
    static let shared = BookMarkNetworkManager()
    private let BASE_URL = "https://j10b206.p.ssafy.io/api/commdist/commercial?commercialDistrictCode="
    
    func fetch(endpoint: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        if let endpoint {
            let urlString = "\(BASE_URL)\(endpoint)"
            AF
                .request(urlString)
                .validate()
                .responseData { response in
                switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
        else {
            print("잘못된 엔드포인트 매개변수입니다.")
        }
    }
    
}
