//
//  ForgotWidget.swift
//  ForgotWidget
//
//  Created by VC on 29/6/2025.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> ForgotEntry {
        ForgotEntry()
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> ForgotEntry {
        ForgotEntry()
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<ForgotEntry> {
        var entries: [ForgotEntry] = []
        let entry = ForgotEntry()
        entries.append(entry)
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ForgotItems.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, allowsSave: true)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

struct ForgotEntry: TimelineEntry {
    let date: Date = .now
}

struct ForgotWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @Query(itemDescriptor, animation: .snappy) private var forgotList: [ForgotItems]
    var body: some View {
        HomeScreenWidget()
    }
    
    @ViewBuilder
    func HomeScreenWidget() -> some View {
        VStack {
            Section
            {
                if !forgotList.isEmpty{
                    Text("Things You Forgot..").font(.caption).foregroundStyle(.red)
                }
                
                ForEach(forgotList) {
                    item in
                    HStack(spacing: 10){
                        Button(intent: ToggleButton(id: item.id)) {
                            Image(systemName: "circle")
                        }
                        .font(.callout)
                        .tint(item.priority.color.gradient)
                        .buttonBorderShape(.circle)
                        
                        VStack(alignment: .leading) {
                            Text(item.task).font(.callout)
                            Text(item.timestamp.formatted(.dateTime.day().month().weekday()))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .transition(.push(from: .bottom))
                }
            }.hLeading()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .overlay {
            if forgotList.isEmpty {
                Text("Nothing You Forgot 🎉").font(.callout).transition(.push(from: .bottom))
            }
        }
    }
    
    
    static var itemDescriptor: FetchDescriptor<ForgotItems> {
        let predicate = #Predicate<ForgotItems>{ !$0.isCompleted }
        let sort = [SortDescriptor(\ForgotItems.timestamp, order: .forward)]
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
}

struct ForgotWidget: Widget {
    let kind: String = "ForgotWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, provider: Provider()) { entry in
            ForgotWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(sharedModelContainer)
        }
        .supportedFamilies( [.systemMedium] )
        // specify widget size , if no specify will support all size
        // .system is widget in the home screen , .accessory is widget at the lock screen
    }
}

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        ForgotItems.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, allowsSave: true)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.forgotItem = "😀"
        return intent
    }
}


struct ToggleButton: AppIntent {
    init(){}
    
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle Forgot State")
    
    @Parameter(title: "Forgot ID")
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        // Update Forgot Item Status
        let context = try ModelContext(.init(for: ForgotItems.self))
        
        // Retreiving Respective Forgot Item
        let descriptor = FetchDescriptor(predicate: #Predicate<ForgotItems> { $0.id == id })
        if let item = try context.fetch(descriptor).first {
            item.isCompleted = true
            
            // Saving the context
            try context.save()
        }
        
        return .result()
    }
}

// adding customize UI for 'View' struct
extension View {
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading).padding(.leading)
    }
}


#Preview(as: .systemSmall) {
    ForgotWidget()
} timeline: {
    ForgotEntry()
}
