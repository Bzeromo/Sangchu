//
//  UpdateToDoView.swift
//  MyToDos
//
//  Created by Tunde Adegoroye on 10/06/2023.
//

import SwiftUI
import SwiftData

struct UpdateToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var item: BookmarkItem
    
    var body: some View {
        List {
            TextField("제목", text: $item.title)
            DatePicker("날짜를 선택해주세요",
                       selection: $item.timestamp)
            Toggle("중요한가요?", isOn: $item.isCritical)
            Button("수정") {
                dismiss()
            }
        }
        .navigationTitle("수정하기")
    }
}
