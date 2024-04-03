import SwiftUI
import Alamofire
import Lottie

struct CommercialDistrictCardView: View {
    var district: CommercialDistrictInfo
    var index: Int
    var topColors: [Color]
    var numberTop: [Color]
    var numberBottom: [Color]
    let MainColors: [Color] = [Color(hex: "50B792"),Color(hex: "3B7777")]

    var body: some View {
        NavigationLink(destination: BDMapView(cameraLatitude: district.longitude, cameraLongitude: district.latitude, selectedCDCode: String(district.commercialDistrictCode) , selectedCDName: district.commercialDistrictName)) {
            
            ZStack{
                
                LottieView(animation: .named("Circlecheck.json"))
                                            .playbackMode(.playing(.toProgress(1,loopMode: .loop)))
                                            .frame(width: 220,height: 220)
                VStack{
                    HStack{
                        Text("\(index + 1)위").foregroundColor(Color.black).fontWeight(.semibold).font(.title).padding(.leading, 25).padding(.top,20)
                        Spacer()
                    }
                    Spacer()
                        
                        Text("\(Int(district.commercialDistrictScore))").foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing)).font(.system(size:38)).fontWeight(.bold)
                   
                    Spacer()
                    Text(district.commercialDistrictName).font(.system(size: 16)).fontWeight(.bold).foregroundColor(Color.black).lineLimit(1)
                    Spacer().frame(height: 30)
                }
               
            }
                .frame(width: 196, height: 230)
                .background(Color.white)
                .cornerRadius(35)
                .shadow(color: Color(hex:"50B792"), radius: 4, x: 0, y: 0)
            }
        .frame(width: 204, height: 238)
        .padding(.trailing,15).padding(.top,10)
           
    }
}

struct BoroughTop10: View {
    // 상권배열
    @State var commercialDistricts: [CommercialDistrictInfo] = []
    // 자치구들 이름 배열
    let boroughsArray: [(key: String, value: Int)] = VariableMapping.boroughsToGuCode.sorted(by: { $0.key < $1.key })
    
    @State private var selectedGuCode: Int = VariableMapping.boroughsToGuCode["강남구"] ?? 11680
    let MainColors: [Color] = [Color(hex: "50B792"),Color(hex: "3B7777")]
    func fetchTopCD(guCode: Int) {
        let urlString = "https://j10b206.p.ssafy.io/api/commdist/gu/top?guCode=\(guCode)"
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
//        VStack {
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
                        .background(self.selectedGuCode == borough.value ?
                                    AnyView(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing)) :
                                                   AnyView(Color.white))
                        .foregroundStyle(self.selectedGuCode == borough.value ? LinearGradient(colors: [Color.white , Color.white], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(50)
                                .shadow(color: Color(hex:"50B792"), radius: self.selectedGuCode == borough.value ? 0 : 2, x: 0, y: 0)
                           
                        
                    }
                }.frame(height:40)
            }
            .padding(.leading,20)
//            .scrollTargetLayout()
            .scrollIndicators(.hidden)
            
            // 자치구별 Top상권
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) { // 여기에서 spacing 값을 조정합니다.
                    ForEach(Array(zip(commercialDistricts.indices, commercialDistricts)), id: \.0) { index, district in
                        CommercialDistrictCardView(district: district, index: index, topColors: AppColors.topColors, numberTop: AppColors.numberTop, numberBottom: AppColors.numberBottom)
                    }
                }
//                .padding(.horizontal) // 필요에 따라 추가적인 패딩을 조정할 수 있습니다.
            }
//            .scrollTargetLayout()
            .padding(.leading,20)
            .scrollIndicators(.hidden)
//            .scrollTargetBehavior(.viewAligned)
//        }
        .onAppear {
            // 뷰가 나타날 때 디폴트 값(강남구)으로 데이터 불러오기
            self.fetchTopCD(guCode: self.selectedGuCode)
        }
        
    }
}
