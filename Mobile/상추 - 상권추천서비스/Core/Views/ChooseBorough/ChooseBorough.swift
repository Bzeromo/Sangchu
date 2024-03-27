//
//  ChooseBorough.swift
//  상추 - 상권 분석 서비스
//
//  Created by 안상준 on 3/7/24.
//

import SwiftUI

// 서울시 자치구 지도
struct BoroughMap: View {
    let boroughMapImg = UIImage(named: "서울자치구25개지도.png")

    var body: some View {
        if let img = boroughMapImg {
            Image(uiImage: img)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
        } else {
            Image(systemName: "arrow.triangle.2.circlepath.circle")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .padding(15)
        }
    }
}

// 서울시 자치구 enum
enum Borough: String, CaseIterable, Identifiable {
    case 강남구
    case 강동구
    case 강북구
    case 강서구
    case 관악구
    case 광진구
    case 구로구
    case 금천구
    case 노원구
    case 도봉구
    case 동대문구
    case 동작구
    case 마포구
    case 서대문구
    case 서초구
    case 성동구
    case 성북구
    case 송파구
    case 양천구
    case 영등포구
    case 용산구
    case 은평구
    case 종로구
    case 중구
    case 중랑구
    
    var id: Self { self }
    
    var location: (latitude: Double, longitude: Double) {
        switch self {
        case .종로구:
            return (37.594917, 126.977319)
        case .중구:
            return (37.560132, 126.995914)
        case .용산구:
            return (37.531361, 126.979907)
        case .성동구:
            return (37.551025, 127.041057)
        case .광진구:
            return (37.546721, 127.085741)
        case .동대문구:
            return (37.582013, 127.054875)
        case .중랑구:
            return (37.597820, 127.092889)
        case .성북구:
            return (37.605703, 127.017520)
        case .강북구:
            return (37.643464, 127.011195)
        case .도봉구:
            return (37.669102, 127.032383)
        case .노원구:
            return (37.652504, 127.075052)
        case .은평구:
            return (37.619205, 126.927020)
        case .서대문구:
            return (37.577794, 126.939061)
        case .마포구:
            return (37.559321, 126.908268)
        case .양천구:
            return (37.524742, 126.855367)
        case .강서구:
            return (37.561233, 126.822813)
        case .구로구:
            return (37.494406, 126.856319)
        case .금천구:
            return (37.460574, 126.900827)
        case .영등포구:
            return (37.522310, 126.910180)
        case .동작구:
            return (37.498881, 126.951655)
        case .관악구:
            return (37.467379, 126.945334)
        case .서초구:
            return (37.473298, 127.031247)
        case .강남구:
            return (37.496657, 127.062977)
        case .송파구:
            return (37.505619, 127.115292)
        case .강동구:
            return (37.550454, 127.147014)
//        default:
//            return (37.5642135, 127.0016985) // 서울시청 기준
        }
    }
}

struct ChooseBorough: View {
    @State private var selectedBorough: Borough = .강남구
    @State private var isPickerTouched: Bool = false
    // 뷰를 제어하기 위함 // 이전버튼에 활용
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
    
    var body: some View {
        VStack {
            HStack {
                Text("지역")
                    .font(.title)
                    .foregroundColor(Color.sangchu)
                    .padding(15)
                Text("업종")
                    .font(.title2)
                    .foregroundColor(Color(hex: "767676"))
                    .padding(15)
            } // end of HStack
            
            Spacer()
            
            Text(" \"자치구\"")
                .font(.system(size: 30)) + Text("를 선택하세요.")
                .font(.system(size: 20))
            
            BoroughMap() // 서울 자치구 25개 지도

            Spacer()
            
            // 자치구 선택 Picker
            Picker("자치구", selection: $selectedBorough) {
                ForEach(Borough.allCases) {
                    borough in Text(borough.rawValue)
                }
            }
            .pickerStyle(WheelPickerStyle())
//            .onChange(of: selectedBorough) { newValue in
//                isPickerTouched = true
//            }
            .onChange(of: selectedBorough) {
                isPickerTouched = true
            }
            
            Spacer()
            
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
                NavigationLink("다음", destination: ChooseCategoryView(borough: selectedBorough.rawValue))
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

            Spacer()
            
//            Text(selectedBorough.rawValue) // 고른 자치구 확인용
        } // end of VStack
    } // end of body view
} // end of ChooseBorough view
