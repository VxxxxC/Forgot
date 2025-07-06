//
//  Home.swift
//  Forgot
//
//  Created by VC on 1/7/2025.
//

import SwiftUI
import SwiftData
import WidgetKit

struct Home: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ForgotItems]
    @State private var showAll: Bool = false
    
    init(){
        let predicate = #Predicate<ForgotItems>{ !$0.isCompleted }
        let sort = [SortDescriptor(\ForgotItems.timestamp, order: .reverse)]
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        
        _items = Query(descriptor, animation: .snappy)
    }
    
  

    var body: some View {
            VStack{
                Section{
                    List{
                        Section(activeSectionTitle){
                            ForEach(items){
                                ForgotItemRow(forgot: $0)
                            }
                        }
                    }.cornerRadius(20).padding(10)
                    
                    
                    // Nested Container
                    List{
                        ForgotItemFinishRow(showAll: $showAll)
                    }.cornerRadius(20).padding(10)
                    
                    
                    
                } header: {
                    HStack{
                        HeaderView()
                    }
                    
                } footer: {
                    Button(action: {
                        addItem()
                    }, label:{
                        Image(systemName: "plus.circle.fill").fontWeight(.regular).font(.system(size: 50)).foregroundStyle(.cyan)
                    })
                }

                
            }
    
        
        
        // Bottom Tabs
        
//        TabView {
//            ForgotList().tabItem{
//                Image(systemName: "list.bullet")
//                Text("Forgot List")
//            }
//            Setting().tabItem{
//                Image(systemName: "gear")
//                Text("Setting")
//            }
//        }
    }
    
    // Header
    func HeaderView() -> some View {
        HStack(){
            VStack(alignment: .leading){
                Text(Date().formatted(date: .abbreviated, time: .omitted)).foregroundColor(.gray)
                Text("Today").font(.largeTitle.bold())
            }
         
        }.hLeading()
    }

    private func addItem() {
        withAnimation {
            let newItem = ForgotItems(timestamp: Date(), task: "")
            modelContext.insert(newItem)
        }
    }
    
    var activeSectionTitle: String {
        let count = items.count
        return items.count == 0 ? "No Items" : "\(count) Item\(count == 1 ? "" : "s")"
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




// adding customize UI for 'View' struct
extension View {
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading).padding(.leading)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ForgotItems.self, inMemory: true)
}
