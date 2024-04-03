import SwiftUI

struct RecommendBoroughCard: View {
    @State var isHeartFilled: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // 배경 이미지 설정
                Image(uiImage: UIImage(named: "AppIcon.png")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -20)
                    .edgesIgnoringSafeArea(.all)

                // 우측 상단에 위치한 버튼
                Button(action: { self.isHeartFilled.toggle() }) {
                    Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .background(Circle().fill(Color.white).frame(width: 40, height: 40))
                        .padding(.top, 15)
                        .padding(.leading, geometry.size.width / 100 * 60)
                }

                // 제목과 내용을 최하단에 배치
                VStack () {
                    Spacer()

                    // 제목과 내용
                    VStack(alignment: .leading, spacing: 5) {
                        Text("제목")
                            .font(.headline)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.horizontal, 5) // 좌우 패딩 조정

                        Text("내용내용내용내용내용")
                            .font(.subheadline)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .padding(.horizontal, 5) // 좌우 패딩 조정
                    }
                    .frame(width: geometry.size.width, alignment: .leading)
                    .background(Color.defaultbg) // 제목과 내용의 배경색 설정
                }.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, height: geometry.size.height / 10 * 7)
            .background(Color.red)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 2)
        }

    }
}
