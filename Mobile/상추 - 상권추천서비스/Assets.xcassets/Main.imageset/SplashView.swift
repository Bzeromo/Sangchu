//
//  SplashView.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/28/24.
//

import SwiftUI

struct SplashView: View {
    @State private var startAnimation: Bool = false
    let MainColors: [Color] = [Color(hex: "3B7777"),Color(hex: "50B792")]
    var body: some View {
        ZStack {
            
            //Color(hex: "FF8080"),
            LinearGradient(
                           colors:
                            MainColors,
                           startPoint: startAnimation ? .topLeading : .bottomLeading,
                           endPoint: startAnimation ? .bottomTrailing : .topTrailing
                       ).onAppear {
                           withAnimation(.linear(duration: 6.0)) {
                               startAnimation.toggle()
                           }
                       }
            
            VStack() {
                Image(uiImage: UIImage(named: "Splash.png")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150 , height: 150)
                    
                
                
                Text("상추")
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("맞춤형 상권 추천 서비스")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
            
            
           
        }.ignoresSafeArea(.all)
    }
}
