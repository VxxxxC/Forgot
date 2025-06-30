//
//  forgotList.swift
//  Forgot
//
//  Created by VC on 29/6/2025.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ForgotItemRow: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\ForgotItems.timestamp, order: .reverse)], animation: .snappy) private var items: [ForgotItems]
    
    @Bindable var forgot : ForgotItems
    @FocusState private var isActive: Bool
    
    var body: some View {
        
        //        NavigationView{
        //                List {
        //                    Section(activeSectionTitle){
        //                        ForEach(items) { item in
        //                            HStack(){
        //                                Text(item.task)
        //                                Spacer()
        //                                Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))").foregroundColor(.secondary).font(.subheadline)
        //                            }
        //                        }
        //                        .onDelete(perform: deleteItems)
        //                    }
        //
        //                }.toolbar{
        //                        if !items.isEmpty {
        //                         EditButton()
        //                        }
        //                }.backgroundStyle(.cyan)
        //            }
        
        HStack{
            if !isActive && !forgot.task.isEmpty {
                Button(action: {}, label: {
                    Image(systemName: forgot.isCompleted ? "checkmark.circle.fill" : "circle").font(.title2).padding(3).contentShape(.rect)
                        .foregroundStyle(forgot.isCompleted ? .secondary : .primary)
                        .contentTransition(.symbolEffect(.replace))
                })
            }
            TextField("You Forgot...", text: $forgot.task)
                .strikethrough(forgot.isCompleted)
                .foregroundStyle(forgot.isCompleted ? .secondary : .primary)
                .focused($isActive)
            
            if !isActive && !forgot.task.isEmpty{
                // Priority Button
                Menu {
                    ForEach(Priority.allCases, id: \.rawValue){
                        _priority in Button(action: { forgot.priority = _priority }, label: {
                            HStack{
                                Text(_priority.rawValue).font(.caption)
                                if forgot.priority == _priority {
                                    Image(systemName: "checkmark")
                                }
                            }
                        })
                    }
                } label : {
                    Image(systemName: "circle.fill")
                        .font(.title2).padding(3).contentShape(.rect).foregroundStyle(forgot.priority.color.gradient)
                }
            }
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = forgot.task.isEmpty
        }
        // Swipe Delete Action
        .swipeActions(edge: .trailing) {
            Button("", systemImage: "trash"){
                modelContext.delete(forgot)
            }.tint(.red)
        }
        .onSubmit(of: .text){
            modelContext.delete(forgot)
        }
    }
//    
//    var activeSectionTitle: String {
//        let count = items.count
//        return count == 0 ? "No Items" : "\(count) Item\(count == 1 ? "" : "s")"
//    }
//    
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//                WidgetCenter.shared.reloadAllTimelines()
//            }
//        }
//    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: ForgotItems.self, inMemory: true)
}

