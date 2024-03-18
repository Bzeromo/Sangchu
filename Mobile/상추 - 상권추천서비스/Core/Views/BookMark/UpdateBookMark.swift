//
//  UpdateBookMark.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/14/24.
//

import SwiftUI
import SwiftData
import PhotosUI // 사진 선택기를 가져오기 위함
import SwiftUIImageViewer

struct UpdateBookMarkView: View {
    
    @Environment(\.dismiss) var dismiss
    @Query private var hashtags : [Hashtag]
    @State var selectedHashtag : Hashtag?
    
    @State private var isImageViewerPresented = false
    @State var selectedPhoto : PhotosPickerItem?
    @Bindable var item: BookMarkItem
    var body: some View {
        List {
            Section(header: Text("상권정보")){
                Text("상권명 : \(item.cdTitle)")
                Text("상권정보 :  \(item.cdInfo)")
            }
                Section(header: Text("해시태그 추가")){
                    Picker("선택된 태그",selection: $selectedHashtag){
                        ForEach(hashtags) { hashtag in
                            Text(hashtag.title).tag(hashtag as Hashtag?)
                        }
                        Text("없음").tag(nil as Hashtag?)
                    }
                }
            
            
            Section(header: Text("메모")) {
                ZStack(alignment: .topLeading) {
                    if item.userMemo.isEmpty {
                        Text("메모를 입력하세요")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    TextEditor(text: $item.userMemo)
                }
            }
            Section {
                
                if let iamgeData = item.image, let uiImage = UIImage(data: iamgeData){
                    Image(uiImage: uiImage).resizable().scaledToFit().frame(maxWidth: .infinity,maxHeight: 300)
                        .onTapGesture {
                            isImageViewerPresented = true
                        }
                        .fullScreenCover(isPresented: $isImageViewerPresented){
                            SwiftUIImageViewer(image:Image(uiImage: uiImage)).overlay(alignment: .topTrailing){
                                Button{
                                    isImageViewerPresented = false
                                } label: {
                                    Image(systemName: "xmark").font(.headline)
                                }.buttonStyle(.bordered).clipShape(Circle()).tint(.purple).padding()
                            }
                        }
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
        .navigationTitle("메모")
        .toolbar{
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
