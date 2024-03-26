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
            ScrollView(.vertical) {
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
                    Spacer()
                }
                .navigationTitle("\(CDname)")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    // 북마크 같은게 있으면 false를 반환
                    hasMatchingItem = !items.contains { $0.cdCode == CDcode }
                }
                .toolbar {
//                    ToolbarItem(placement: .topBarLeading ) {
//                        VStack {
//                            Spacer()
//                            Text("[\(CDcode)]").foregroundColor(.sangchu) // 상권 코드에 sangchu 색상 적용
//                            Text(CDname).foregroundColor(.sangchu) // 상권 이름에 sangchu 색상 적용
//                        }
//                    }
                    
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
                
            }
        } // end of NavigationView
    } // end of bodyView
}
