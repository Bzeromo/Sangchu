//
//  ContentView.swift
//  상추 - 상권 분석 서비스
//
//  Created by 안상준 on 3/7/24.
//

import SwiftUI
import SwiftData

struct CDMIconOrLoadingView: View {
    let commercialDistrictMapIcon = UIImage(named: "상권지도아이콘.png")

    var body: some View {
        if let icon = commercialDistrictMapIcon {
            Image(uiImage: icon)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 4)
        } else {
            Image(systemName: "arrow.triangle.2.circlepath.circle")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 4)
        }
    }
}

struct CRIconOrLoadingView: View {
    let customizedRecommendationIcon = UIImage(named: "맞춤추천받기아이콘.png")

    var body: some View {
        if let icon = customizedRecommendationIcon {
            Image(uiImage: icon)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 4)
        } else {
            Image(systemName: "arrow.triangle.2.circlepath.circle")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 4)
        }
    }
}


struct TopView : View {
    var colorScheme: ColorScheme // ColorScheme 타입의 변수 추가

    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "AppIcon.png")!).resizable().scaledToFit().frame(width: 30, height: 30).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 5))
            Text("상추").font(.SingleDay).foregroundColor(Color("sangchoo"))
            Spacer()
        }
        // 간단 소개
        Spacer().frame(height: 11)
        HStack {
            Text("골목상권 찾기").font(.title).foregroundColor(colorScheme == .dark ? .white : .black)
                .padding([.leading, .trailing], 20)
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Spacer()
        }
        // 간단 소개
        HStack {
            Text("상추와 함께 하세요!").font(.title3).foregroundColor(Color(hex: "767676"))
                .padding([.leading, .trailing], 20)
            Spacer()
        }
    }
}

struct SearchBar : View {
    @Binding var searchText: String // searchText를 @Binding으로 선언
    var body: some View {
        
        VStack{
            
            HStack {
                // 검색창과 아이콘을 포함하는 HStack
                TextField("상권 이름으로 검색해보세요", text: $searchText)
                    .padding(7)
                    .padding(.leading, 20) // 아이콘 이미지 공간을 위한 패딩
                    .padding(.trailing, 30) // 돋보기 버튼 공간을 위한 패딩
                    .cornerRadius(15)
                    .frame(height: 40)
                    .overlay(
                        HStack {
                            // 앱 아이콘
                            Image(uiImage: UIImage(named: "AppIcon.png")!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                            
                            Spacer()
                            
                            // 돋보기 버튼
                            if !searchText.isEmpty {
                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(hex: "93C73D"))
                                .padding(.trailing, 8)
                        }
                    )
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("sangchoo"), lineWidth: 1) // 테두리 색상과 두께 조정
                            .shadow(color: .gray, radius: 3, x: 0, y: 2) // 그림자 효과 추가
                    )
            } // HStack
            .padding(.bottom, 5)
            .padding(.horizontal) // 이 부분에 주는 padding에 따라서 검색창 가로 너비 조절!
            
            HStack{
                Text("일 검색횟수 125회, 누적 검색횟수 1520회")
                    .font(.system(size: 11))
                Spacer()
            }.padding(.horizontal).padding(.leading, 5)
           

        }// Top Vstack
        
    }
} // SearchBar

struct MidView : View {
    var body: some View {
        GeometryReader { geometry in
            
            VStack(){
                Spacer()
                // 상권지도 컴포넌트
                NavigationLink (destination: ChooseBorough()) {
                    HStack {
                        Spacer()
                        VStack (alignment: .leading) {
                            Text("상권 지도")
                                .font(.system(size: 22))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(hex: "767676"))
                                .padding(2)
                            Text("주변 상권을 한 눈에!")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "93C73D"))
                                .padding(3)
                        }
                        Spacer()
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        CDMIconOrLoadingView()
                        
                        Spacer()
                    }
                    .padding(20)
                    .frame(width: geometry.size.width * 0.93 , height: geometry.size.height / 5 * 2)
                    .background(Color.white) // 전체 VStack의 배경색 설정
                        .cornerRadius(5) // 모서리 둥글게
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 1, y: 1) // 그림자 효과 추가
                }
                
                
                // 맞춤 추천 받기
                NavigationLink (destination: ChooseBorough()) {
                    HStack {
                        
                        Spacer()
                        VStack (alignment: .leading) {
                            Text("맞춤 추천 받기")
                                .font(.system(size: 22))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(hex: "767676"))
                                .padding(2)
                            Text("개인별 맞춤 추천 서비스!")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "93C73D"))
                                .padding(3)
                        }
                        Spacer()
                        Spacer()
                        CRIconOrLoadingView()
                        Spacer()
                    }
                    .padding(20)
                    .frame(width: geometry.size.width * 0.93 , height: geometry.size.height / 5 * 2)
                    .background(Color.white) // 전체 VStack의 배경색 설정
                        .cornerRadius(5) // 모서리 둥글게
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 1, y: 1) // 그림자 효과 추가
                } // 맞춤추천 컴포넌트 끝
                
                Spacer()
                
            } // VStack
        } // geometry
        
    }
}

struct BottomView : View {
    var colorScheme: ColorScheme // ColorScheme 타입의 변수 추가
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                HStack{
                    Text("TOP 10").font(.title).foregroundColor(Color.red)
                    Text("상권").font(.title).foregroundColor(colorScheme == .dark ? .white : .black)
                    Text("(월 단위)").font(.caption2).foregroundColor(Color(hex: "767676"))
                    Spacer()
    //                        NavigationLink (destination: GraphTestView()) {
    //                            Text("더보기 >").font(.caption)
    //                                .foregroundColor(Color(hex: "767676"))
    //                                .padding(3)
    //                        }
                }.padding(.horizontal) // HSTACK
                
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 10) {
                        ForEach(1 ... 10, id : \.self) { number in
                            VStack(spacing: 0){
//                                Text("\(number) 등")
//                                    .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
//                                    .background(.mint)
//                                    .cornerRadius(5)
                                RecommendBoroughCard().frame(width: geometry.size.width / 3, height: geometry.size.height / 6 * 9)
                            }
                        }
                    }
                }.padding(.horizontal) // SCROLL
            } // TOP 10 VSTAC
        }
        
    }
}


struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme // 다크모드 or 라이트모드
    @Query private var items: [Item]
    @State private var searchText : String = ""
private var showNavigationBar = false
    var body: some View {
        
            
            GeometryReader{ geometry in
                VStack(alignment: .center){ // 세로축
                    HStack{
                        
                    }.frame(height: geometry.size.height / 90)
                    HStack { // VStack을 중앙에 위치시키기 위해 HStack 사용
                        Spacer() // 왼쪽에 Spacer 추가
                        VStack {
                            // 상단 소개페이지
                            TopView(colorScheme: colorScheme).frame(width: geometry.size.width / 100 * 97) // colorScheme 정보를 TopView에 전달
                            // 검색창
                            SearchBar(searchText: $searchText).frame(width: geometry.size.width / 100 * 97).padding(.top , geometry.size.height / 50)
                            // 상권 지도
                            HStack{
                                Spacer()
                                Spacer()
                                Spacer()
                                MidView().frame(width: geometry.size.width / 100 * 96)
                                Spacer()
                            }
                        }
                        .frame(width: geometry.size.width * 0.98) // Vstack 너비 조정
                        Spacer() // 오른쪽에 Spacer 추가
                        Spacer() // 오른쪽에 Spacer 추가
                    } // HStack
                    .frame(height: geometry.size.height / 5 * 3 )
                    
                    HStack{
                        Spacer()
                        VStack{
                            // Top10
                            BottomView(colorScheme: colorScheme)
                        }.frame(width: geometry.size.width * 0.99)
                    }.frame(width: geometry.size.width / 100 * 98, height: geometry.size.height / 20 * 5)
                    Spacer()
                    
                }
                .background(Color(hex: "F4F5F7")) // Vstack
                    
                
                
            } // Geometry
    }// body
} // HomeView
