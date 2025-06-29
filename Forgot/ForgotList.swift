//
//  forgotList.swift
//  Forgot
//
//  Created by VC on 29/6/2025.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ForgotList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\ForgotItems.timestamp, order: .reverse)], animation: .snappy) private var items: [ForgotItems]
    @State private var showingPopup: Bool = false
    @State private var inputText: String = ""
    
    var body: some View {
        NavigationSplitView {
            ZStack{
                List {
                    Section(activeSectionTitle){
                        ForEach(items) { item in
                            NavigationLink {
                                Text(item.task)
                                Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                            } label: {
                                Text(item.task)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                }
                .toolbar {
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    EditButton()
    //                }
                    ToolbarItem {
                        Button("Add Item") {
                            showingPopup.toggle()
                        }.alert("Place Your Item", isPresented: $showingPopup){
                            TextField("", text: $inputText)
                            Button("OK", action: submit)
                        }
                    }
                }
            }
            
        } detail: {
            Text("Things to forgot")
        }
    }
    
    var activeSectionTitle: String {
        let count = items.count
        return count == 0 ? "No Items" : "\(count) Item\(count == 1 ? "" : "s")"
    }
    
    private func submit() {
        guard !inputText.isEmpty else { return }
        addItem()
        showingPopup.toggle()
        inputText = ""
    }

    private func addItem() {
        withAnimation {
            let newItem = ForgotItems(timestamp: Date(), task: inputText)
            modelContext.insert(newItem)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
    
}
