//
//  UpdateBookMark.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/14/24.
//

import SwiftUI
import SwiftData

struct UpdateBookMarkView: View {
    
    @Environment(\.dismiss) var dismiss
    @Query private var hashtags : [Hashtag]
    @State var selectedHashtag : Hashtag?
    /*
     var cdCode : String
     var userMemo : String
     var timestamp : Date
     var cdTitle : String
     var cdInfo : String
     var isImportant : Bool
     */
    
    @Bindable var item: BookMarkItem
    
    var body: some View {
        List {
            Section(header: Text("상권정보 추가")){
                TextField("상권명", text: $item.cdTitle)
                TextField("상권정보", text: $item.cdInfo)
            }
//            Toggle("중요한가요?", isOn: $item.isImportant)
            Section(header: Text("해시태그 추가")){
                Picker("",selection: $selectedHashtag){
                    ForEach(hashtags) { hashtag in
                        Text(hashtag.title).tag(hashtag as Hashtag?)
                    }
                    Text("없음").tag(nil as Hashtag?)
                }
            }.labelsHidden().pickerStyle(.inline)
            
            Section(header : Text("메모")){
                TextField("메모", text: $item.userMemo)
            }
            Button("수정") {
                item.timestamp = .now
                item.hashtag = selectedHashtag
                dismiss()
            }
        }
        .navigationTitle("수정하기")
        .onAppear(perform: {
            selectedHashtag = item.hashtag
        })
    }
}
