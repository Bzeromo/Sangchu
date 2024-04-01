//
//  MapAdditional.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/27/24.
//

import SwiftUI
import NMapsMap

struct MapAdditional: View {
    @ObservedObject var viewModel: MapViewModel
    
    @State private var selectedBorough: Borough = .강남구
    @State private var isPickerTouched: Bool = false
    // 뷰를 제어하기 위함 // 이전버튼에 활용
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let MainColors: [Color] = [Color(hex: "50B792"),Color(hex: "3B7777")]
    var body: some View {
        
        VStack{
            Divider()
                .frame(minHeight: 5)
                .background(Color.gray.opacity(0.8)) // 절취선의 색상과 투명도를 설정합니다.
                .padding(.leading, 150).padding(.trailing, 150).padding(.bottom, 15)
                
            Spacer().frame(height: 2)
            ScrollView{
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(Borough.allCases, id: \.self) { borough in
                        Button(action: {
                            self.selectedBorough = borough
                            self.isPickerTouched = true
                        }) {
                            Text(borough.rawValue)
                                .font(.system(size: 18))
                                
                               
                        }.frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.1).background(self.selectedBorough == borough ? LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Color.white,Color.white], startPoint: .leading, endPoint: .trailing))
                            .foregroundStyle(self.selectedBorough == borough ? LinearGradient(colors: [Color.white,Color.white], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                            .fontWeight(self.selectedBorough == borough ? .semibold : .regular)
                            .clipShape(RoundedRectangle(cornerRadius: 35))
                            .overlay(
                                        RoundedRectangle(cornerRadius: 35)
                                            .stroke(Color.black.opacity(0.7), lineWidth: 0.2)
                                    )
                        
                    }
                }.padding()
            }.frame(height : UIScreen.main.bounds.height * 0.55).clipped()
            Button(!isPickerTouched ? "이동할 지역 선택" : "이동하기") {
                // 여기에 BDMapView를 해당 자치구의 위도 경도로 이동시키면서 viewModel.showBoroughSheet를 false로 바꿔주고 고른 자치구도 초기화 시켜줘야 함!
                let location = selectedBorough.location
                viewModel.selectedBoroughLocation = NMGLatLng(lat: location.latitude, lng: location.longitude)
                viewModel.showBoroughSheet = false
            }
            .disabled(!isPickerTouched) // Picker가 조작되지 않았다면 버튼 비활성화
            .foregroundColor(.black)
            .buttonStyle(RoundedRectangleButtonStyle(
                bgColor: !isPickerTouched ? Color(hex: "c6c6c6") : Color.sangchu,
                textColor: .black,
                width: UIScreen.main.bounds.width * 0.8,
                hasStroke: false,
                shadowRadius: 2,
                shadowColor: Color.black.opacity(0.1),
                shadowOffset: CGSize(width: 0, height: 4)))
            .padding([.trailing, .bottom])
            .frame(width: UIScreen.main.bounds.width * 0.8)
        }
        
        
        
    }
}
