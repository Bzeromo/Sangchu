//
//  ChartView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/21/24.
//

import SwiftUI
import Charts


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
    @State var selectedFilterOption: FilterOption = .consumer
    @State var CDcode : String
    @State var CDname : String
    
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
                    Spacer()
                    Text("")
                }
                Spacer()
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
                    Button {
                        alertType = .bookmark
                        showingAlert = true
                    } label: {
                        Image(systemName: "bookmark")
                    }
                    
                    Button {
                        alertType = .location
                        showingAlert = true
                    } label: {
                        Image(systemName: "location.circle")
                    }
                }
            } // 여기까지 툴바 추가
            .alert(isPresented: $showingAlert) {
                switch alertType {
                case .bookmark:
                    return Alert(title: Text("Coming Soon"), message: Text("준비 중인 기능입니다."), dismissButton: .default(Text("확인")))
                case .location:
                    return Alert(title: Text("Coming Soon"), message: Text("준비 중인 기능입니다."), dismissButton: .default(Text("확인")))
                default:
                    return Alert(title: Text("Error")) // 혹은 더 적절한 기본 처리
                }
            }
        } // end of NavigationView
    } // end of bodyView
}
