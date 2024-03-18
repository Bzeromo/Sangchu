//
//  HashTag.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/14/24.
//

import SwiftUI
import SwiftData

struct CreateHashtagView : View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @Query private var hashtags : [Hashtag]
    
    @State private var title : String = ""
    
    var body : some View {
        List{
            Section("해시태그 추가하기"){
                TextField("해시태그를 추가해보세요", text : $title)
                Button("등록"){
                    withAnimation{
                        // context에 삽입하기 전 역데이터도 올바르게 설정되었는지 확인하는 과정
                        let hashtag = Hashtag(title : title)
                        context.insert(hashtag)
                        hashtag.items = [] // 빈배열로 만드는 방법, 해당 항목을 업데이트 하려면 삽입 후 빈배열로 만드는 과정을 수행해야함
                    }
                    
                }.disabled(title.isEmpty) // 비어있으면 등록안됨
            }
            
            Section("Hashtag"){
                
                if(hashtags.isEmpty){
                    ContentUnavailableView("카테고리가 없습니다", systemImage: "archivebox")
                }else{
                    ForEach(hashtags){ hashtag in
                        Text(hashtag.title).swipeActions{
                            Button(role: .destructive) {
                                withAnimation {
                                    context.delete(hashtag)
                                }
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                        
                    }
                }
                
               
            }
        }
        .navigationTitle("해시태그 추가하기")
    }
    
}
