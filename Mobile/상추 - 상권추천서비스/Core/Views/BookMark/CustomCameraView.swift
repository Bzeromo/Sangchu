//
//  CustomCameraView.swift
//  AVFoundationHeetae
//
//  Created by 양희태 on 3/19/24.
//

import SwiftUI

struct CustomCameraView : View
{
    let cameraService = CameraService()
    @Binding var capturedImage : UIImage?
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View{
        ZStack{
            CameraView(cameraService: cameraService) { result in
                switch result{
                case .success(let photo):
                    if let data = photo.fileDataRepresentation(){
                        capturedImage = UIImage(data : data)
                        presentationMode.wrappedValue.dismiss()
                    }else{
                        print("Error : no image data found")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            VStack{
                Spacer()
                Button(action: {
                    cameraService.capturePhoto()
                }) {
                    Image(uiImage: UIImage(named: "whitee.png")!)
                        .resizable()
                        .padding(.bottom) // 필요에 따라 조정
                        .frame(width: 70, height: 90) // 이미지 크기에 따라 조정
                }
                .overlay(
                    Circle() // 원형 테두리
                        .stroke(Color.white, lineWidth: 4) // 하얀색, 테두리 너비 조정
                )
                .clipShape(Circle()) // 테두리를 원형으로 자르기
            }
        }
    }
}
