//
//  MapAdditional.swift
//  상추 - 상권추천서비스
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
     
    var body: some View {
        Spacer().frame(height: 20)
        Picker("자치구", selection: $selectedBorough) {
            ForEach(Borough.allCases) {
                borough in Text(borough.rawValue)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .onChange(of: selectedBorough) {
            isPickerTouched = true
        }
        Spacer().frame(height: 10)
        // 이전/다음 버튼
        HStack {
            // 이전 버튼
            Button("이전") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(RoundedRectangleButtonStyle(bgColor: Color(.customgray),
                                                     textColor: .white,
                                                     width: UIScreen.main.bounds.width / 4,
                                                     hasStroke: false,
                                                     shadowRadius: 1, shadowColor: Color.gray.opacity(0.5), shadowOffset: CGSize(width: 2, height: 3)))
            .padding([.leading, .bottom])

            Spacer() // Spacer를 사용하여 버튼 사이의 공간을 최대한 확보

            // 다음 버튼
            Button("이동") {
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
                width: UIScreen.main.bounds.width / 4,
                hasStroke: false,
                shadowRadius: 2,
                shadowColor: Color.black.opacity(0.1),
                shadowOffset: CGSize(width: 0, height: 4)))
            .padding([.trailing, .bottom])

        } // end of 이전/다음 버튼 HStack
    }
}
