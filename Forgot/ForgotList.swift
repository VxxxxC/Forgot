//
//  forgotList.swift
//  Forgot
//
//  Created by VC on 29/6/2025.
//

import SwiftUI
import SwiftData

struct ForgotTab: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showingPopup: Bool = false
    @State private var inputText: String = ""
    
    var body: some View {
        NavigationSplitView {
            ZStack{
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text(item.text)
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                        } label: {
                            Text(item.text)
                        }
                    }
                    .onDelete(perform: deleteItems)
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
    
    
    private func submit() {
        guard !inputText.isEmpty else { return }
        addItem()
        showingPopup.toggle()
        inputText = ""
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date(), text: inputText)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
}
