//
//  CreateView.swift
//  MyToDos
//
//  Created by Tunde Adegoroye on 10/06/2023.
//


// 지도에서 구현했기떄문애 추후 삭제, 블로그 정리하고 삭제하자
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
