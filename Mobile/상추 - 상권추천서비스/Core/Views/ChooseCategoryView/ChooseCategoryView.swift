import SwiftUI

enum Category: String, CaseIterable, Identifiable {
    case 한식음식점
    case 중식음식점
    case 일식음식점
    case 양식음식점
    case 제과점
    case 패스트푸드점
    case 치킨전문점
    case 분식전문점
    case 호프_간이주점
    case 커피_음료
    
    var id: Self { self }
}

struct ChooseCategoryView: View {
    let borough: String
    @State private var selectedCategory: Category? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 고른 자치구
                Text("\(borough)를 고르셨습니다!")
                
                HStack {
                    Text("지역")
                        .font(.title2)
                        .foregroundColor(Color("customgray"))
                        .padding(15)
                    Text("업종")
                        .font(.title)
                        .foregroundColor(Color("sangchoo"))
                        .padding(15)
                        .minimumScaleFactor(0.5)
                } // end of HStack
                
                Spacer()
                
                Text(" \"업종\"")
                    .font(.system(size: 30)) + Text("을 선택하세요.")
                    .font(.system(size: 20))
                
                Spacer()
                
                VStack {
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
                                    .stroke(Color.black, lineWidth: 1)
                                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                                    .padding(5)
                            )
                        } // end of ForEach
                    } // end of VGrid
                }.padding(15) // end of VStack
                
                Spacer()
            } // end of Total VStack
        } // end of GeometryReader
    } // end of body View
} // end of ChooseCategoryView
