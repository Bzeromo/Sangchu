//
//  ChartView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/21/24.
//

import SwiftUI
import Charts
import SwiftData


// 필터링 옵션
enum FilterOption: String, CaseIterable, Identifiable {
    case consumer = "consumer"
    case sales = "sales"
    case infra = "infra"
    
    var id: Self { self }
    
    // 열거형 값에 따른 아이콘
    var systemImageName: String {
        switch self {
        case .consumer:
            return "figure"
        case .sales:
            return "wonsign"
        case .infra:
            return "building.2"
        }
    }
}


struct CDInfoView: View {
    @Environment(\.modelContext) var context
    
    @Query private var items: [BookMarkItem]
    @State var selectedFilterOption: FilterOption = .consumer
    @State var CDcode : String
    @State var CDname : String
    @State private var hasMatchingItem: Bool = true
    
    
    @State private var showingAlert = false
    @State private var alertType: AlertType? = nil

    enum AlertType {
        case bookmark
        case location
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Picker("flitering",
                           selection : $selectedFilterOption
                    ) {
                        ForEach(FilterOption.allCases) { option in
                            Image(systemName: option.systemImageName).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .cornerRadius(5)
                    .padding()

                }
                switch selectedFilterOption {
                    case .consumer:
                        ConsumerChartView(cdCode: CDcode)
                    case .sales:
                        SalesChartView(cdCode: CDcode)
                    case .infra:
                        InfraChartView(cdCode: CDcode)
                }
            }
            .onAppear{
                // 같은게 있으면 false를 반환
                hasMatchingItem = !items.contains { $0.cdCode == CDcode }
            }
//            .navigationBarTitle("\(CDname) [\(CDcode)]", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading ) {
                    VStack {
                        Spacer()
                        Text("[\(CDcode)]").foregroundColor(.sangchu) // 상권 코드에 sangchu 색상 적용
                        Text(CDname).foregroundColor(.sangchu) // 상권 이름에 sangchu 색상 적용
                    }
                }
                
                ToolbarItemGroup(placement: .primaryAction) {
                    HStack {
                        Button {
                            alertType = .bookmark
                            showingAlert = true
                            if(hasMatchingItem){
                                var item = BookMarkItem()
                                item.cdCode = self.CDcode
                                item.cdTitle = self.CDname
                                item.cdInfo = "이 상권은 망했습니다."
                                withAnimation {
                                    context.insert(item)
                                    hasMatchingItem.toggle()
                                }
                            }else{
                                if let itemToDelete = items.first(where: { $0.cdCode == CDcode }) {
                                    withAnimation {
                                        context.delete(itemToDelete)
                                        hasMatchingItem.toggle()
                                        try? context.save() // 변경 사항 저장
                                    }
                                }
                            }
                            
                        }
                    label: {
                        if(hasMatchingItem){
                            Image(systemName: "bookmark")
                        }else{
                            Image(systemName: "bookmark.fill")
                        }
                        
                    }
                        
                        Button {
                            alertType = .location
                            showingAlert = true
                        } label: {
                            Image(systemName: "location.circle")
                        }
                    }
                    .frame(width: 80)
                } // end of buttonGroup
            } // 여기까지 툴바 추가
            .alert(isPresented: $showingAlert) {
                switch alertType {
                case .bookmark:
                    if(hasMatchingItem){
                        return Alert(title: Text("북마크"), message: Text("\(CDname)가 제거되었습니다."), dismissButton: .default(Text("확인")))
                      
                    } else{
                        return   Alert(title: Text("북마크"), message: Text("\(CDname)가 추가되었습니다.."), dismissButton: .default(Text("확인")))
                    }
                  
                case .location:
                    return Alert(title: Text("Coming Soon"), message: Text("준비 중인 기능입니다."), dismissButton: .default(Text("확인")))
                default:
                    return Alert(title: Text("Error")) // 혹은 더 적절한 기본 처리
                }
            }
            .accentColor(Color("sangchu"))
        } // end of NavigationView
    } // end of bodyView
}


/*
 //
 import SwiftUI
 import SwiftData
 struct CreateBookMarkView: View {
     
     @Environment(\.dismiss) var dismiss // 창닫기
     @Environment(\.modelContext) var context // 컨텍스트를 사용할 수 있게 함
     
     @Query private var hashtags : [Hashtag]
     
     @State var selectedHashtag : Hashtag?
     @State private var item = BookMarkItem() // BookMarkItem 형식으로 변수를 만들어줌
     
     
     /*
      var cdCode : String
      var userMemo : String
      var timestamp : Date
      var cdTitle : String
      var cdInfo : String
      var isImportant : Bool
      */
     var body: some View {
         List {
             
             // 수동으로 상태관리를 해줄 필요가 사라진다.
             TextField("상권코드", text: $item.cdCode)
             TextField("상권명", text: $item.cdTitle)
             TextField("상권정보", text: $item.cdInfo)
 //            Toggle("중요한가요?", isOn: $item.isImportant)
             
             Section{
                 Picker("",selection: $selectedHashtag){
                     ForEach(hashtags) { hashtag in
                         Text(hashtag.title).tag(hashtag as Hashtag?)
                         
                     }
                     Text("없음").tag(nil as Hashtag?)
                 }
             }.labelsHidden().pickerStyle(.inline)
             
             Button("생성") {
                 withAnimation {
                     context.insert(item)
 /*
  바인딩 될 모든 업데이트와함께 항목을 삽입하게 되며 실제로 컨텍스트에서 Save를 호출하지
  않아도 저장이된다.
  데이터를 생성하고 Swift 데이터에 삽입하는 데 필요한 모든 것이 매번 인코딩 되거나
  자동으로 안전하게 사용
 */
                     
                 }
                 dismiss()
             } // Button
         }
         .navigationTitle("상권 북마크 만들기")
     }
 }

 */
