import SwiftUI

enum Category: String, CaseIterable, Identifiable {
    case 한식음식점 // korean
    case 중식음식점 // chinese
    case 일식음식점 // japanese
    case 양식음식점 // western
    case 제과점 // bakery
    case 패스트푸드점 // fastfood
    case 치킨전문점 // chicken
    case 분식전문점 // snack
    case 호프_간이주점 // hof
    case 커피_음료 // cafe
    
    var id: Self { self }
}

struct ChooseCategoryView: View {
    let borough: String
    @State private var selectedCategory: Category? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
//        GeometryReader { geometry in
            VStack {
                // 고른 자치구
//                Text("\(borough)를 고르셨습니다!")
                
                HStack {
                    Text("지역")
                        .font(.title2)
                        .foregroundColor(Color("customgray"))
                        .padding(15)
                    Text("업종")
                        .font(.title)
                        .foregroundColor(Color.sangchu)
                        .padding(15)
                        .minimumScaleFactor(0.5)
                } // end of HStack
                
                Spacer()
                
                Text(" \"업종\"")
                    .font(.system(size: 30)) + Text("을 선택하세요.")
                    .font(.system(size: 20))
                
                Spacer()
                
                VStack {
                    GeometryReader { geometry in
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(Category.allCases) { category in
                                Button(action: {
                                    self.selectedCategory = category
                                    // print("\(category.rawValue.replacingOccurrences(of: "_", with: "-")) 선택됨")
                                }) {
                                    GeometryReader { buttonGeometry in
                                        VStack (alignment: .center) {
                                            Image(category.rawValue.replacingOccurrences(of: "_", with: "-")) // 언더바를 하이픈으로 변경
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: buttonGeometry.size.width * 0.6, height: buttonGeometry.size.width * 0.6)
                                            
                                            Text(category.rawValue)
                                                .font(.system(size: buttonGeometry.size.width * 0.2))
                                                .foregroundColor(Color(.defaultfont))
                                                .padding(3)
                                                .lineLimit(nil)
                                        }.frame(maxWidth: .infinity, alignment: .center)
                                    }
                                }
                                .padding()
                                .frame(width: geometry.size.width / 3.5, height: geometry.size.width / 3.5) // GeometryReader를 사용하여 크기 동적 조절
                                .background(Color.clear) // 버튼의 배경을 투명하게 설정
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(selectedCategory == category ? Color.sangchu : Color.black, lineWidth: selectedCategory == category ? 3 : 1) // 선택된 카테고리에 따라 stroke 색상 변경
                                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                                        .padding(5)
                                )
                            } // end of ForEach
                        }
                    } // end of VGrid
                }.padding(15) // end of VStack
                
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
                    NavigationLink("다음", destination: DistrictRankingView(borough: borough, category: selectedCategory?.rawValue ?? ""))
                        .disabled(selectedCategory == nil) // Picker가 조작되지 않았다면 버튼 비활성화
                        .foregroundColor(.black)
                        .buttonStyle(RoundedRectangleButtonStyle(
                            bgColor: selectedCategory == nil ? Color(hex: "c6c6c6") : Color.sangchu,
                            textColor: .black,
                            width: UIScreen.main.bounds.width / 4,
                            hasStroke: false,
                            shadowRadius: 2,
                            shadowColor: Color.black.opacity(0.1),
                            shadowOffset: CGSize(width: 0, height: 4)))
                        .padding([.trailing, .bottom])
                } // end of 이전/다음 버튼 HStack
                
            } // end of Total VStack
//        } // end of GeometryReader
    } // end of body View
} // end of ChooseCategoryView
