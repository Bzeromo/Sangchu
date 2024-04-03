//
//  UpdateBookMark.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/14/24.
//

import SwiftUI
import UIKit
import SwiftData
import PhotosUI
import SwiftUIImageViewer

struct ActivityViewController: UIViewControllerRepresentable {
  var activityItems: [Any]
  var applicationActivities: [UIActivity]? = nil
  @Environment(\.presentationMode) var presentationMode
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>
  ) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities
    )
    controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
      self.presentationMode.wrappedValue.dismiss()
    }
    return controller
  }
  
  func updateUIViewController(
    _ uiViewController: UIActivityViewController,
    context: UIViewControllerRepresentableContext<ActivityViewController>
  ) {}
}

struct UpdateBookMarkView: View {
    
    @Environment(\.dismiss) var dismiss
    @Query private var hashtags : [Hashtag]
    @State var selectedHashtag : Hashtag?
    @Environment(\.modelContext) var context
    @State var capturedImage : UIImage? = nil
    @State private var isCustomCameraViewPresented = false
    @State private var isImageViewerPresented = false
    @FocusState private var isTextEditorFocused: Bool // 수정 중 일때 버튼 표시
    @State private var isImageLoaded = false //
//    @State var selectedPhoto : PhotosPickerItem?
    @Bindable var item: BookMarkItem
    // 공유 기능 위한 배열
    @State private var itemForSharing: [Any] = []
    @State private var isSharedPresented = false
    // 공유하기 시 사진 선택
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    // 변환함수
    func resizeAndConvertImageToJPEG(image: UIImage?, maxWidth: CGFloat = 1024, maxHeight: CGFloat = 1024, compressionQuality: CGFloat = 0.7) {
        guard let image = image else { return }
        let size = image.size

        let widthRatio  = maxWidth  / size.width
        let heightRatio = maxHeight / size.height
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let resizedImageData = resizedImage?.jpegData(compressionQuality: compressionQuality) else {
            print("JPEG 변환 실패")
            return
        }
        item.image = resizedImageData
    }
    // 공유 기능 준비 위한 함수
    func prepareSharingItems() {
        itemForSharing = ["[상추] - 서울시 상권 추천 서비스", item.cdTitle, item.userMemo]
        if let imageData = item.image {
            print("JPEG Data size: \(imageData.count) bytes")
            let jpegImage = UIImage(data: imageData)
            itemForSharing.append(jpegImage as Any)
        } else {
            print("이미지 데이터 준비 실패")
        }
    }
    
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
                            inputImage = nil
                            item.image = nil
                        }
                    } label: {
                        Label {
                            Text("")
                        } icon: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.red) // 아이콘 색상
                                .font(.system(size: 14)) // 아이콘 크기
                                .padding(6) // 주위에 패딩
                                .background(Color.white) // 배경 색상
                                .clipShape(Circle()) // 원형으로 클리핑
                                .shadow(radius: 3) // 그림자 추가
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
                        Text("정보보러가기")
                        .font(.system(size:13))
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                    }
                    
                }
            }
                .padding(.leading , 20).padding(.trailing, 20)
            
            HStack{
                Picker("선택된 태그",selection: $selectedHashtag){
                    ForEach(hashtags) { hashtag in
                        Text(hashtag.title).tag(hashtag as Hashtag?)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                    }
                    Text("없음").tag(nil as Hashtag?)
                }
                .font(.title3)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
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
                                        }.foregroundStyle(Color(hex:"58b295"))
                                    }
                                }
            ToolbarItemGroup(placement: .bottomBar) {
                // 갤러리 버튼
                Button(action:{
                    showingImagePicker = true
                }) {
                    Label("갤러리", systemImage: "photo")
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImage: $inputImage)
                }
                .onChange(of: inputImage) { _ in
                    resizeAndConvertImageToJPEG(image: inputImage)
                }
                
                Spacer()
                
                // 카메라 버튼
                Button(action: {isCustomCameraViewPresented.toggle()
                }) {
                    Label("카메라", systemImage: "camera").sheet(isPresented: $isCustomCameraViewPresented, content: {CustomCameraView(capturedImage: $capturedImage)})
                }
                
                Spacer()
                Button(action: {
                    // 공유 시트 표시를 위해 상태를 변경
                    isSharedPresented = true
                }) {
                    Label("공유", systemImage: "square.and.arrow.up").foregroundColor(.green)
                }
                .onChange(of: isSharedPresented) { newValue in
                    if newValue {
                        prepareSharingItems()
                    }
                }
                .sheet(isPresented: $isSharedPresented, onDismiss: {
                    // 시트가 닫히면 상태를 초기화
                    isSharedPresented = false
                    itemForSharing = []
                }) {
                    ActivityViewController(activityItems: itemForSharing)
                }
                Spacer()
                Button(action: {
                    context.delete(item)
                    inputImage = nil
                    dismiss()
                }) {
                    Label("삭제", systemImage: "trash")
                }
            }
        }
//        .task(id: selectedPhoto) {
//            do {
//                if let photo = selectedPhoto,
//                   let data = try await photo.loadTransferable(type: Data.self) {
//                    // 사진 데이터 로드 성공
//                    if let uiImage = UIImage(data: data) {
//                        resizeAndConvertImageToJPEG(image: uiImage)
//                    } else {
//                        print("UIImage로 변환 실패")
//                    }
//                } else {
//                    print("선택된 사진 로딩 실패")
//                }
//            } catch {
//                print("사진 선택 작업에서 에러 발생: \(error)")
//            }
//        }
        .task(id: capturedImage) {
            if let capturedImage = capturedImage {
                resizeAndConvertImageToJPEG(image: capturedImage)
            } else {
                print("캡처된 이미지 처리 실패")
            }
        }
        .onAppear(perform: {
            selectedHashtag = item.hashtag
        })
        .onDisappear {
            item.hashtag = selectedHashtag
        }
    }
}
