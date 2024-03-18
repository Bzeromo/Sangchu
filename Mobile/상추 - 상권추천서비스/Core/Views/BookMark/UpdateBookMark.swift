//
//  UpdateBookMark.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/14/24.
//

import SwiftUI
import SwiftData
import PhotosUI // 사진 선택기를 가져오기 위함

struct UpdateBookMarkView: View {
    
    @Environment(\.dismiss) var dismiss
    @Query private var hashtags : [Hashtag]
    @State var selectedHashtag : Hashtag?
    
    @State var selectedPhoto : PhotosPickerItem?
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
            
            Section {
                
                if let iamgeData = item.image, let uiImage = UIImage(data: iamgeData){
                    Image(uiImage: uiImage).resizable().scaledToFit().frame(maxWidth: .infinity,maxHeight: 300)
                }
                
                PhotosPicker(selection : $selectedPhoto,
                             matching: .images,
                             photoLibrary : .shared()){
                    Label("사진 추가" , systemImage: "photo")
                }
                if item.image != nil{
                    Button(role: .destructive){
                        withAnimation{
                            selectedPhoto = nil
                            item.image = nil
                        } }label : {
                            Label("삭제" , systemImage: "xmark").foregroundStyle(.red)
                        }
                    
                }
                
            }
            
            Button("수정") {
                item.timestamp = .now
                item.hashtag = selectedHashtag
                dismiss()
            }
        }
        .navigationTitle("수정하기")
        .toolbar{
            ToolbarItem(placement: .cancellationAction){
                Button("뒤로가기"){
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction){
                Button("완료"){
                    dismiss()
                    item.timestamp = .now
                    item.hashtag = selectedHashtag
                }
            }
        }
        .task(id:selectedPhoto){
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                item.image = data
            }
        }
        .onAppear(perform: {
            selectedHashtag = item.hashtag
        })
    }
}
