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
    
    @State var capturedImage : UIImage? = nil
    @State private var isCustomCameraViewPresented = false
    @State private var isImageViewerPresented = false
    @FocusState private var isTextEditorFocused: Bool // 수정중일때 버튼 표시하게 하기 위함
    @State private var isImageLoaded = false // 사진 애니메이션을 위햐
    @State var selectedPhoto : PhotosPickerItem?
    @Bindable var item: BookMarkItem
    var body: some View {
        ScrollView(.vertical){
            ZStack(alignment: .topTrailing) {
                if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill() // 오타 수정
                        .opacity(isImageLoaded ? 1.0 : 0.0) // isImageLoaded 상태에 따라 투명도 조절
                                            .onAppear {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    isImageLoaded = true // 이미지가 표시될 때 애니메이션 적용
                                                }
                                            }
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .clipped() // 이미지를 프레임에 맞춰 잘라냄
                        .onTapGesture {
                            isImageViewerPresented = true
                        }
                        .fullScreenCover(isPresented: $isImageViewerPresented) {
                            SwiftUIImageViewer(image: Image(uiImage: uiImage))
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        isImageViewerPresented = false
                                    } label: {
                                        Image(systemName: "xmark").font(.headline)
                                    }
                                    .buttonStyle(.bordered)
                                    .clipShape(Circle())
                                    .tint(.purple)
                                    .padding()
                                }
                        }
                }
                if item.image != nil {
                    Button(role: .destructive) {
                        withAnimation {
                            selectedPhoto = nil
                            item.image = nil
                        }
                    } label: {
                        Label {
                            Text("")
                        } icon: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.red) // 아이콘 색상을 빨간색으로 설정
                                .font(.system(size: 14)) // 아이콘 크기 조정
                                .padding(6) // 아이콘 주위에 패딩 추가
                                .background(Color.white) // 배경 색상을 흰색으로 설정
                                .clipShape(Circle()) // 배경을 원형으로 클리핑
                                .shadow(radius: 3) // 선택적으로 그림자 추가
                        }
                    }.padding(.top, 6)
                }
            }
            
            VStack(alignment: .leading, spacing: 3 ){
                Text("\(item.cdTitle)").font(.title).fontWeight(.semibold)
                HStack{
                    Text("\(item.timestamp, format: Date.FormatStyle(date:.numeric, time:.standard))").font(.system(size:13)).foregroundColor(.gray)
                    
                    Spacer()
                    NavigationLink(destination: BDMapView(cameraLatitude: item.latitude, cameraLongitude: item.longitude, selectedCDCode: String(item.cdCode), selectedCDName: item.cdTitle)){
                        Text("정보보러가기").font(.system(size:13))
                    }
                    
                }
            }.padding(.leading , 20).padding(.trailing, 20)
            HStack{
                Picker("선택된 태그",selection: $selectedHashtag){
                    ForEach(hashtags) { hashtag in
                        Text(hashtag.title).tag(hashtag as Hashtag?)
                    }
                    Text("없음").tag(nil as Hashtag?)
                }.font(.title3)
                Spacer()
            }
           .padding(.leading , 20).padding(.trailing, 20)
            TextEditor(text: $item.userMemo)
                            .frame(minHeight: 300, maxHeight: .infinity)
                            .padding(.leading , 20).padding(.trailing, 20)
                            .focused($isTextEditorFocused)
                            
                
            
        }
        .navigationTitle("메모")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                                    if isTextEditorFocused { // 텍스트 에디터가 포커스되었을 때만 버튼을 보여줌
                                        Button("완료") {
                                            isTextEditorFocused = false // 버튼을 누르면 포커스를 해제하여 키보드를 내림
                                        }
                                    }
                                }
            ToolbarItemGroup(placement: .bottomBar) {
                PhotosPicker(selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Label("사진 추가", systemImage: "photo").foregroundColor(.green)
                }
                Spacer()
                
                Button(action: {isCustomCameraViewPresented.toggle()
                }) {
                    Label("카메라", systemImage: "camera").sheet(isPresented: $isCustomCameraViewPresented, content: {CustomCameraView(capturedImage: $capturedImage)})
                }
                
              
                
                Spacer()
                Button(action: {
                }) {
                    Label("공유", systemImage: "square.and.arrow.up").foregroundColor(.green)
                }
                Spacer()
                Button(action: {
                    // 삭제 작업을 수행하는 코드를 여기에 추가하세요.
                    // 예를 들어, 선택된 사진을 초기화하는 코드를 넣을 수 있습니다.
                    selectedPhoto = nil
                }) {
                    Label("삭제", systemImage: "trash")
                }
            }
        }
        .accentColor(Color("sangchu"))
        .task(id:selectedPhoto){
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                item.image = data
            }
        }
        .task(id: capturedImage) {
            if let capturedImage = capturedImage,
               let imageData = capturedImage.jpegData(compressionQuality: 1.0) {
                item.image = imageData
            }
        }
        .onAppear(perform: {
            selectedHashtag = item.hashtag
        })
    }
}
