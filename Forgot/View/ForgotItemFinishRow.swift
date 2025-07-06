//
//  ForgotItemFinishRow.swift
//  Forgot
//
//  Created by VC on 6/7/2025.
//

import SwiftUI
import SwiftData

struct ForgotItemFinishRow: View {
    @Query private var completedList: [ForgotItems]
    @Binding var showAll: Bool
    
    init(showAll: Binding<Bool>){
        let predicate = #Predicate<ForgotItems>{ $0.isCompleted }
        let sort = [SortDescriptor(\ForgotItems.timestamp, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        // Limiting to 15
        if !showAll.wrappedValue{
            descriptor.fetchLimit = 5
        }
       
        
        _completedList = Query(descriptor, animation: .snappy)
        _showAll = showAll
    }

    var body: some View {
        Section{
            ForEach(completedList){
                ForgotItemRow(forgot: $0)
            }
        } header: {
            HStack{
                Text("Completed")
                
                if showAll {
                    Button("Show Recent") {
                        showAll = false
                    }
                    
                }
            }.hLeading().font(.caption)
        } footer : {
            HStack{
                if !showAll && completedList.count == 5 {
                    Text("Showing Recent 5 Forgot Items")
                    
                    Spacer()
                    
                    Button("Show All") {
                        showAll = true
                    }
                }
            }.font(.caption).padding(.horizontal)
            
        }
    }
}

#Preview{
    ContentView()
        .modelContainer(for: ForgotItems.self, inMemory: true)
}
