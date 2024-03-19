//
//  CameraView.swift
//  AVFoundationHeetae
//
//  Created by 양희태 on 3/19/24.
//

import SwiftUI
import AVFoundation

struct CameraView : UIViewControllerRepresentable {
   
    
    typealias UIViewControllerType = UIViewController
    
    // 카메라 보기 외부에서 캡처 사진에 엑세스하기를 원하기 때문에 카메라 서비스를 초기화해줘야함
    // 그래야 버튼등을 내가 원하는대로 커스텀할 수 있다.
    let cameraService : CameraService
    
    // 결과값이 오류가 나올 수도 있기에 이렇게 설정
    let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
    
    //UIView를 만듬
    func makeUIViewController(context: Context) -> UIViewController {
        cameraService.start(delegate: context.coordinator){ err in
            if let err = err {
                didFinishProcessingPhoto(.failure(err))
                return
            }
        }
        
        // ViewController 선언
        let viewController = UIViewController()
        
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        cameraService.previewLayer.frame = viewController.view.bounds
        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    // 실제로 원하는 대리자를 준수하게 된다.
    class Coordinator : NSObject,AVCapturePhotoCaptureDelegate {
        
        // 부모 뷰를 추가
        let parent : CameraView
        private var didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
        
        // 부모 뷰를 위한 초기화
        // @escaping을 사용하는 이유는 함수가 끝나고도 사용을 원할때 ex) 스크린샷을 찍고 잠깐 남아있는 경우가 그 예시
        init(_ parent: CameraView, didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> ()){
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
        }
        
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
            didFinishProcessingPhoto(.success(photo))
            
        }
        
        
    }
    
}
