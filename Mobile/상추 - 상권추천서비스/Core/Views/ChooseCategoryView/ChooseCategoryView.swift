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
    @State private var startAnimation : Bool = false
    let universalSize = UIScreen.main.bounds
    
    
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
            
            // 절취선
            
            VStack {
                // 고른 자치구
//                Text("\(borough)를 고르셨습니다!")
                
                Spacer().frame(height: UIScreen.main.bounds.height * 0.12)
                HStack{
                    Spacer()
                    Text("요식업 업종별 선택").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundStyle(Color.black).fontWeight(.semibold)
                    Spacer()
                }
                
                VStack {
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(Category.allCases) { category in
                                VStack(alignment: .center, spacing: 2){
                                    Button(action: {
                                        self.selectedCategory = category
                                        // print("\(category.rawValue.replacingOccurrences(of: "_", with: "-")) 선택됨")
                                    }) {
                                       
                                            VStack (alignment: .center) {
                                                Image(category.rawValue.replacingOccurrences(of: "_", with: "-")) // 언더바를 하이픈으로 변경
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
                                                
                                                
                                            }.frame(maxWidth: .infinity, alignment: .center)
                                        
                                    }
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)

                                    .background(
                                        Circle().fill(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                        )
                                    .overlay(
                                        Circle()
                                            .stroke(selectedCategory == category ? Color.sangchu : Color.black, lineWidth: selectedCategory == category ? 3 : 0) // 선택된 카테고리에 따라 stroke 색상 변경
                                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                                        
                                    )
                                    Text(category.rawValue)
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                        .padding(3)
                                        .lineLimit(nil)
                                }
                                
                            } // end of ForEach
                        }
                    // end of VGrid
                }.padding(15) // end of VStack
                
                Spacer()
               
                
                
                NavigationLink(destination: DistrictRankingView(borough: borough, category: selectedCategory?.rawValue ?? "")) {
                    HStack {
                        selectedCategory == nil ?
                        Text("업종 선택").font(.title3).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing)) : Text("선택 완료").font(.title3).fontWeight(.semibold).foregroundStyle(Color.white)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.07)
                    .background(self.selectedCategory == nil ?
                                AnyView(Color(hex: "c6c6c6")) : AnyView(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing)))
                    .cornerRadius(20)
                    .disabled(selectedCategory == nil)
                  
                        
                }.padding(.bottom,10)
                
            } // end of Total VStack
        }
            .navigationTitle("업종 선택")
            .ignoresSafeArea(.all)
            .onAppear{
                self.startAnimation = true
            }
            .background(Color(hex: "F4F5F7"))
        
            
    } // end of body View
} // end of ChooseCategoryView
