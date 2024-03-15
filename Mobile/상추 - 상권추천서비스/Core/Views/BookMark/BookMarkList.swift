//
//  ContentView.swift
//  MyToDos
//
//  Created by Tunde Adegoroye on 10/06/2023.
//

import SwiftUI
import SwiftData

struct BookMarkTopView : View {
    @Binding var showCreate: Bool
    @Binding var hashCreate: Bool
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "AppIcon.png")!).resizable().scaledToFit().frame(width: 30, height: 30).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 5))
            Text("북마크").font(.SingleDay).foregroundColor(Color("sangchoo"))
            Spacer()
            Button(action: {
                hashCreate.toggle()
            }, label: {
                Label("", systemImage: "minus").foregroundColor(Color("sangchoo"))
            }).foregroundColor(Color("sangchoo"))
                Button(action: {
                    showCreate.toggle()
                }, label: {
                    Label("", systemImage: "plus").foregroundColor(Color("sangchoo"))
                }).foregroundColor(Color("sangchoo"))
            
        }
    }
}

struct BookMarkList: View {
    
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var hashCreate = false
    @Query private var items: [BookMarkItem]
    private var showNavigationBar = true
    var body: some View {
        /*
         var cdCode : String
         var userMemo : String
         var timestamp : Date
         var cdTitle : String
         var cdInfo : String
         var isImportant : Bool
         */
        VStack{
            BookMarkTopView(showCreate: $showCreate, hashCreate: $hashCreate).padding(.top , 16).padding(.horizontal , 10)
            List{
                ForEach(items){ item in
                                        NavigationLink(destination: UpdateBookMarkView(item: item)){
                        HStack{
                            VStack(alignment: .leading) {
                                Text(item.cdTitle).font(.system(size: 22)).bold().foregroundStyle((Color("sangchoo")))
                                HStack{
                                    /*
                                     Text(item.timestamp, style: .date) // 날짜만 표시
                                     Text(item.timestamp, style: .time) // 시간만 표시
                                     Text(item.timestamp, style: .timer) // 타이머 스타일
                                     Text(item.timestamp, style: .offset) // 현재 시간과의 차이
                                     Text(item.timestamp, style: .relative) // 상대적인 시간 표시 (예: 5 minutes ago)
                                     */
                                    Text("\(item.timestamp, format: Date.FormatStyle(date:.numeric, time:.none)) \(item.userMemo)")
                                        .font(.system(size: 13)) // 전체 텍스트에 적용될 폰트 사이즈
                                        .foregroundColor(Color(hex: "767676")) // 전체 텍스트에 적용될 폰트 색상
                                        .lineLimit(1) // 텍스트가 한 줄로 제한됩니다.
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
                                
                            }
                            // 제목 시간 Vstack                 Button {
//                                withAnimation {
//                                    item.isImportant.toggle()
//                                }
//                            } label: {
//                                
//                                Image(systemName: "checkmark")
//                                    .symbolVariant(.circle.fill)
//                                    .foregroundStyle(item.isImportant ? .green : .gray)
//                                    .font(.largeTitle)
//                            }
//                            .buttonStyle(.plain)
                        } // HStack
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
            // List
//            .listStyle(PlainListStyle())
            .listSectionSpacing(8)
            .scrollContentBackground(.hidden)
            .padding(.horizontal, 10)
            
        } // VStack
        .background(Color(hex: "F4F5F7"))
 
}
}

