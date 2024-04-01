//
//  ChooseBorough.swift
//  상추 - 상권 분석 서비스
//
//  Created by 안상준 on 3/7/24.
//

import SwiftUI

// 서울시 자치구 지도
struct BoroughMap: View {
    let boroughMapImg = UIImage(named: "서울자치구25개지도.png")

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
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    // 뷰를 제어하기 위함 // 이전버튼에 활용
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var startAnimation : Bool = false
        
    let universalSize = UIScreen.main.bounds
    
    // amplitude는 진폭 원래는 150 값이 들어있었음
    // interval 은 UIScreen.width size
    func getSinWave(interval : CGFloat, amplitude : CGFloat = 100,baseline:CGFloat = UIScreen.main.bounds.height / 2) ->
    Path{
        Path { path in
            path.move(to: CGPoint(x:0, y:baseline))
            path.addCurve(to: CGPoint(x : 1 * interval, y : baseline),
                          control1: CGPoint(x:interval * (0.3),y: amplitude + baseline),
                          control2: CGPoint(x:interval * (0.7),y: -amplitude + baseline)
            )
            path.addCurve(to: CGPoint(x : 2 * interval, y : baseline),
                          control1: CGPoint(x:interval * (1.3),y: amplitude + baseline),
                          control2: CGPoint(x:interval * (1.7),y: -amplitude + baseline)
            )
            path.addLine(to: CGPoint(x: 2 * interval, y: universalSize.height))
            path.addLine(to: CGPoint(x: 0 , y: universalSize.height))
        }
    }
    
    let MainColors: [Color] = [Color(hex: "50B792"),Color(hex: "3B7777")]
    
    var body: some View {
        ZStack{
            getSinWave(interval: universalSize.width * 1.5 , amplitude: 150, baseline: 65 + universalSize.height / 2)
            //.stroke(lineWidth: 2) // 선만
                .foregroundColor(Color.red.opacity(0.3))
                .offset(x: startAnimation ? -1 * (universalSize.width * 1.5) : 0)
                .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false))
            
            getSinWave(interval: universalSize.width , amplitude: 200, baseline: 70 + universalSize.height / 2)
                .foregroundColor(Color("sangchu").opacity(0.3))
                .offset(x: startAnimation ? -1 * (universalSize.width) : 0)
                .animation(Animation.linear(duration: 11).repeatForever(autoreverses: false))
            
            getSinWave(interval: universalSize.width * 3 , amplitude: 200, baseline: 95 + universalSize.height / 2)
                .foregroundColor(Color.black.opacity(0.2))
                .offset(x: startAnimation ? -1 * (universalSize.width * 3) : 0)
                .animation(Animation.linear(duration: 4).repeatForever(autoreverses: false))
            
            getSinWave(interval: universalSize.width * 1.2 , amplitude: 50, baseline: 75 + universalSize.height / 2)
                .foregroundColor(Color.init(red:0.6, green:0.9, blue : 1).opacity(0.4))
                .offset(x: startAnimation ? -1 * (universalSize.width * 1.2) : 0)
                .animation(Animation.linear(duration: 4).repeatForever(autoreverses: false))
//
            
            
            // 절취선
            VStack {
                Spacer().frame(height: UIScreen.main.bounds.height * 0.12)
                
                HStack{
                    Spacer()
                    Text("서울 자치구 기준 선택").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundStyle(Color.black).fontWeight(.semibold)
                    Spacer()
                }
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(Borough.allCases, id: \.self) { borough in
                                    Button(action: {
                                        self.selectedBorough = borough
                                        self.isPickerTouched = true
                                    }) {
                                        
                                        Text(borough.rawValue)
                                            .padding()
                                            .font(.system(size: 14))
                                            .fontWeight(.bold)
                                            .frame(width: UIScreen.main.bounds.width * 0.28, height : UIScreen.main.bounds.height * 0.048)
                                            .background(self.selectedBorough == borough ? AnyView(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing)) : AnyView(Color.white))
                                            .foregroundStyle(self.selectedBorough == borough ? LinearGradient(colors: [Color.white , Color.white], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                            .fontWeight(self.selectedBorough == borough ? .semibold : .regular)
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                            .overlay(
                                                        RoundedRectangle(cornerRadius: 50)
                                                            .stroke(Color(hex:"58b295").opacity(0.7), lineWidth: 0.2)
                                                    )
                                            .shadow(color: Color(hex:"50B792"), radius: self.selectedBorough == borough ? 0 : 1, x: 1, y: 1)
                                    }
                                    
                                }
                            }
                            .padding()
//                }.frame(height : UIScreen.main.bounds.height * 0.6).clipped()
                
                Spacer()
                
  
                // 이전/다음 버튼
                NavigationLink(destination: ChooseCategoryView(borough: selectedBorough.rawValue)) {
                    HStack {
                        self.isPickerTouched == true ?
                        Text("선택 완료").font(.title3).fontWeight(.semibold).foregroundStyle(Color.white) : Text("지역 선택").font(.title3).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.07)
                    .background(!isPickerTouched ?
                                AnyView(Color(hex: "c6c6c6")) : AnyView(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing)))
                    .cornerRadius(20)
                    .disabled(!isPickerTouched)
                  
                        
                }.padding(.bottom,20) // end of 이전/다음 버튼 HStack
                   
                
    //            Text(selectedBorough.rawValue) // 고른 자치구 확인용
            }
            // end of VStack
        }
        .navigationTitle("지역 선택")
        .ignoresSafeArea(.all)
        .onAppear{
            self.startAnimation = true
        }
        .background(Color(hex: "F4F5F7"))
        
    } // end of body view
} // end of ChooseBorough view
