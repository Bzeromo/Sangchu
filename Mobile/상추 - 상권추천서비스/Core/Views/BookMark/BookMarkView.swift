//
//  BookMarkView.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/18/24.
//

import SwiftUI

struct BookMarkTabView: View {
    var body: some View {
        // 이곳에서 NavigationLink 또는 다른 네비게이션 메커니즘을 사용하여
        // 북마크 관련 뷰로 네비게이션할 수 있습니다.
        
        NavigationLink(destination: BookMarkList()) {
                            Text("다음 페이지로")
        }.navigationTitle("홈")
    }
}
