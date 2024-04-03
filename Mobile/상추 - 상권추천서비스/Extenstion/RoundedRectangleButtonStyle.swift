//
//  RoundedRectangleButtonStyle.swift
//  상추 - 상권 분석 서비스
//
//  Created by 안상준 on 3/7/24.
//

// RoundedRectangleButtonStyle.swift

import SwiftUI

struct RoundedRectangleButtonStyle: ButtonStyle {
    var bgColor: Color // 배경색
    var textColor: Color // 글자색
    var width: CGFloat // 버튼의 너비
    var hasStroke: Bool // 테두리 유무
    var shadowRadius: CGFloat? // 그림자 반경
    var shadowColor: Color? // 그림자 색상
    var shadowOffset: CGSize? // 그림자 위치

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: width)
            .padding(20)
            .background(bgColor)
            .cornerRadius(20)
            .foregroundColor(textColor)
            .overlay(hasStroke ? RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1) : nil) // 테두리 유무에 따라 오버레이 설정
            .shadow(color: shadowColor ?? Color.clear, radius: shadowRadius ?? 0, x: shadowOffset?.width ?? 0, y: shadowOffset?.height ?? 0) // 그림자
    }
}

