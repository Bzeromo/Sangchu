//
//  ConsumerNetworkManager.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/25/24.
//

import Foundation
import Alamofire

class ConsumerNetworkManager {
    static let shared = ConsumerNetworkManager()
    private let BASE_URL = "https://j10b206.p.ssafy.io/api"

    func fetch(endpoint: String?, commercialDistrictCode: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let endpoint {
            let urlString = "\(BASE_URL)\(endpoint)?commercialDistrictCode=\(commercialDistrictCode)"
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
