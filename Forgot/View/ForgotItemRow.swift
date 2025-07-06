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
    @Environment(\.scenePhase) private var scenePhase
    @Query(sort: [SortDescriptor(\ForgotItems.timestamp, order: .forward)], animation: .snappy) private var items: [ForgotItems]
    
    @Bindable var forgot : ForgotItems
    @FocusState private var isActive: Bool
    
    var body: some View {
        
        HStack{
            if !isActive && !forgot.task.isEmpty {
                Button(action: {
                    forgot.isCompleted.toggle()
                    WidgetCenter.shared.reloadAllTimelines()
                }, label: {
                    Image(systemName: forgot.isCompleted ? "checkmark.circle.fill" : "circle").font(.title2).padding(3).contentShape(.rect)
                        .foregroundStyle(forgot.isCompleted ? .secondary : .primary)
                        .contentTransition(.symbolEffect(.replace))
                })
            }
            VStack(alignment: .leading){
                TextField("You Forgot...", text: $forgot.task)
                    .strikethrough(forgot.isCompleted) // if Complete will strikethrough the item name
                    .foregroundStyle(forgot.isCompleted ? .secondary : .primary)
                    .focused($isActive)
                
                if !forgot.task.isEmpty {
                    Text(forgot.timestamp.formatted(.dateTime.day().month().weekday()))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
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
                WidgetCenter.shared.reloadAllTimelines()
            }.tint(.red)
        }
        .onSubmit(of: .text){
            if forgot.task.isEmpty {
                 modelContext.delete(forgot)
            } else {
                modelContext.insert(forgot)
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: scenePhase){
            oldValue, newValue in
            if newValue != .active && forgot.task.isEmpty {
                modelContext.delete(forgot)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .task {
            forgot.isCompleted = forgot.isCompleted
        }
    }

    
}

#Preview {
    ContentView()
        .modelContainer(for: ForgotItems.self, inMemory: true)
}

