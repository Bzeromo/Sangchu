//
//  SwiftUIView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/27/24.
//

//CommercialDistrictInfo

import SwiftUI
import Alamofire

struct CommercialDistrictCardView: View {
    var district: CommercialDistrictInfo
    var index: Int
    var topColors: [Color]
    var numberTop: [Color]
    var numberBottom: [Color]

    var body: some View {
        NavigationLink(destination: BDMapView(cameraLatitude: district.longitude, cameraLongitude: district.latitude, selectedCDCode: String(district.commercialDistrictCode) , selectedCDName: district.commercialDistrictName)) {
            ZStack {
                // 등수 관련 UI
                VStack{
                    HStack{
                        Text("\(index + 1)").foregroundColor(Color.black).fontWeight(.bold).font(.title2)
                        Spacer()
                        Text(">").font(.title2).foregroundColor(Color.gray.opacity(0.5)).font(.title)
                    }
                    Spacer()
                    Text(district.commercialDistrictName).font(.title2).fontWeight(.bold).foregroundColor(Color.black).lineLimit(1)
                }
                
                VStack{
                    Text("\(Int(district.commercialDistrictScore))점").foregroundColor(Color.white.opacity(0.8)).font(.system(size:28))
                }.frame(width:UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                    .background(LinearGradient(colors: [Color(hex:"87CC6C") ,Color(hex:"4CA32A")], startPoint: .top, endPoint: .bottom)).clipShape(Circle())
                
                
            }
        }.scrollTransition{ content, phase in
            content
                .opacity(phase.isIdentity ? 1.0 : 0.5)
        }
        .frame(width: UIScreen.main.bounds.width * 0.4, height : 180)
        .padding()
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(10)
        // end of Navi
    }
}

struct BoroughTop10: View {
    // 상권배열
    @State var commercialDistricts: [CommercialDistrictInfo] = []
    // 자치구들 이름 배열
    let boroughsArray: [(key: String, value: Int)] = VariableMapping.boroughsToGuCode.sorted(by: { $0.key < $1.key })
    
    @State private var selectedGuCode: Int = VariableMapping.boroughsToGuCode["강남구"] ?? 11680
    
    func fetchTopCD(guCode: Int) {
        let urlString = "http://3.36.91.181:8084/api/commdist/gu/top?guCode=\(guCode)"
        AF.request(urlString).responseDecodable(of: [CommercialDistrictInfo].self) { response in
            switch response.result {
            case .success(let districts):
                // 결과 처리
                self.commercialDistricts = districts
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(boroughsArray, id: \.self.key) { borough in
                        Button(action: {
                            // 버튼이 눌리면 선택된 자치구 업데이트
                            self.selectedGuCode = borough.value
                            // 선택된 자치구에 따라 상권 정보 업데이트
                            self.fetchTopCD(guCode: borough.value)
                        }) {
                            Text(borough.key).font(.system(size: 16)).fontWeight(.medium)
                        }
                        .frame(width: 78, height: 37)
                        .background(self.selectedGuCode == borough.value ? Color.sangchu : Color.white)
//                        .foregroundColor(self.selectedGuCode == borough.value ? Color.white : Color.black)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 1 ,x : 1, y : 1)
                    }
                }
            }
//            .scrollTargetLayout()
            .scrollIndicators(.hidden)
            
            // 자치구별 Top상권
            ScrollView (.horizontal) {
                HStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(zip(commercialDistricts.indices, commercialDistricts)), id: \.0) { index, district in
                                CommercialDistrictCardView(district: district, index: index, topColors: AppColors.topColors, numberTop: AppColors.numberTop, numberBottom: AppColors.numberBottom)
                            }
                        }
//                        .scrollTargetLayout()
                    }.scrollIndicators(.hidden)
//                    .scrollTargetBehavior(.viewAligned)
                }
            }
//            .scrollTargetLayout()
            .scrollIndicators(.hidden)
//            .scrollTargetBehavior(.viewAligned)
        }
        .onAppear {
            // 뷰가 나타날 때 디폴트 값(강남구)으로 데이터 불러오기
            self.fetchTopCD(guCode: self.selectedGuCode)
        }
        
    }
}
