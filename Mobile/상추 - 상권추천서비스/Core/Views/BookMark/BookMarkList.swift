//
//  ContentView.swift
//  MyToDos
//
//  Created by Tunde Adegoroye on 10/06/2023.
//

import SwiftUI
import SwiftData
struct BookMarkList: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var showCreate = false
    @State private var hashCreate = false
    @State private var searchQuery = ""
    @Query private var items: [BookMarkItem]
    
    @State private var selectedSortOption = SortOption.allCases.first!
    
    var filteredItems: [BookMarkItem] {
        
        if searchQuery.isEmpty {
            return items.sort(on: selectedSortOption)
        }
        
        let filteredItems = items.compactMap { item in
            
            let titleContainsQuery = item.cdTitle.range(of: searchQuery,
                                                      options: .caseInsensitive) != nil
            
            let categoryTitleContainsQuery = item.hashtag?.title.range(of: searchQuery,
                                                                        options: .caseInsensitive) != nil
            
            return (titleContainsQuery || categoryTitleContainsQuery) ? item : nil
        }
        
        return filteredItems.sort(on: selectedSortOption)
        
    }
    
    
    private var showNavigationBar = true
    var body: some View {        
            List{
                ForEach(filteredItems){ item in
                                        NavigationLink(destination: UpdateBookMarkView(item: item)){
                                            VStack(alignment: .leading){
                                HStack(spacing : 0){                                    /*
                                     Text(item.timestamp, style: .date) // 날짜만 표시
                                     Text(item.timestamp, style: .time) // 시간만 표시
                                     Text(item.timestamp, style: .timer) // 타이머 스타일
                                     Text(item.timestamp, style: .offset) // 현재 시간과의 차이
                                     Text(item.timestamp, style: .relative) // 상대적인 시간 표시 (예: 5 minutes ago)
                                     */
                                    VStack(alignment : .leading){
                                        Text(item.cdTitle).font(.system(size: 22)).bold().foregroundStyle((Color("sangchu")))
                                        Text("\(item.timestamp, format: Date.FormatStyle(date:.numeric, time:.none)) \(item.userMemo)")
                                            .font(.system(size: 13)) // 전체 텍스트에 적용될 폰트 사이즈
                                            .foregroundColor(Color(hex: "767676")) // 전체 텍스트에 적용될 폰트 색상
                                            .lineLimit(1) // 텍스트가 한 줄로 제한됩니다.
                                    }
                                   Spacer() // 여기에서 배경색을 노란색으로 설정합니다.
                                    if let selectedPhotoData = item.image,
                                       let uiImage = UIImage(data: selectedPhotoData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                            .clipShape(RoundedRectangle(cornerRadius: 10,
                                                                        style: .continuous))
                                
                                }
                                
                                }
                                if let hashtag = item.hashtag {
                                    Text(hashtag.title)
                                        .foregroundStyle(Color.blue)
                                        .bold()
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(Color.blue.opacity(0.1),
                                                    in: RoundedRectangle(cornerRadius: 8,
                                                                         style: .continuous))
                                }
                            }// VStack
                        .padding(.horizontal, 5)
                        .swipeActions {
                        Button(role: .destructive) {
                            
                            withAnimation {
                                context.delete(item)
                            }
                            
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }.tint(.red)
                        
    //                    Button {
    //                        toDoToEdit = item
    //                    } label: {
    //                        Label("Edit", systemImage: "pencil")
    //                    }
    //                    .tint(.orange)
                    }
                    } // NavigationLink
                    .padding(.vertical, 5)
                    
                    Section{
                        
                    }
                } // ForEach
            }
            .navigationBarTitle("북마크", displayMode: .inline)
//            .navigationBarBackButtonHidden(true)
//                    .navigationBarItems(leading: Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }) {
//                        HStack {
//                            Image(systemName: "chevron.backward") // 시스템 아이콘 사용, 원하는 이미지로 변경 가능
//                        }
//                    })
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        hashCreate.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: {
                        showCreate.toggle()
                    }, label: {
                        Image(systemName: "minus")
                    })
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    
                    Menu {
                        Picker("", selection: $selectedSortOption) {
                            ForEach(SortOption.allCases,
                                    id: \.rawValue) { option in
                                Label(option.rawValue.capitalized,
                                      systemImage: option.systemImage)
                                .tag(option)
                            }
                        }
                        .labelsHidden()
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                    }
                    
                }
                
            } // 여기까지 툴바 추가
            .animation(.easeIn, value: filteredItems) // 이거 덕분에 자연스러운 애니메이션이 된다.
            .searchable(text:$searchQuery, prompt : "내용 및 해시태그를 검색해보세요")
            .overlay {
                if filteredItems.isEmpty{
                    ContentUnavailableView.search
                }
            } // 항목이 없을때 없다고 표시해줌
            .sheet(isPresented: $showCreate,
                   content: {
                NavigationStack{
                    CreateBookMarkView()
                }
                .presentationDetents([.medium])
                
                
            })
            .sheet(isPresented: $hashCreate,
                   content: {
                NavigationStack{
                        CreateHashtagView()
                }
                .presentationDetents([.medium])
            })
            .listSectionSpacing(8)
            .scrollContentBackground(.hidden)
            .padding(.horizontal, 10)
            
         // VStack
        .background(Color(hex: "F4F5F7"))
 
}
}

enum SortOption : String, CaseIterable{
    case title
    case date
    case hashtag
}

extension SortOption{
    var systemImage : String{
        switch self{
        case .title:
            "textformat.size.larger"
        case .date:
            "calendar"
        case .hashtag:
            "folder"
        }
    }
}

private extension [BookMarkItem]{
    
    func sort(on option : SortOption) -> [BookMarkItem]{
        switch option {
        case .title:
            self.sorted(by: {$0.cdTitle < $1.cdTitle})
        case .date:
            self.sorted(by: {$0.timestamp < $1.timestamp})
        case .hashtag:
            self.sorted(by: {
                guard let firstItemTitle = $0.hashtag?.title,
                      let secondItemTitle = $1.hashtag?.title else{
                    return false
                }
                return firstItemTitle < secondItemTitle
            })
        }
    }
    
}
