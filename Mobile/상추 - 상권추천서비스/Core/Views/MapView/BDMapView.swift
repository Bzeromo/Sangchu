//
//  MapView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/14/24.
//

import SwiftUI
import NMapsMap

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> NMFMapView {
        return NMFMapView()
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {
    }
}

struct BottomSheetView: View {
    var body: some View {
        Text("여기에 이제 업종 선택 구현")
    }
}

struct BDMapView: View {
    @State private var showingSearchView = false

    var body: some View {
        NavigationView {
            VStack {
                MapView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
    
