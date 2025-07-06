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

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = ForgotEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
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
                ForEach(forgotList) {
                    item in
                    HStack(spacing: 10){
                        Button(intent: ToggleButton(id: item.id)) {
                            Image(systemName: "circle")
                        }
                        .font(.callout)
                        .tint(item.priority.color.gradient)
                        .buttonBorderShape(.circle)
                        
                        Text(item.task).font(.callout)
                        
                        Spacer()
                    }
                    .transition(.push(from: .bottom))
                }
            
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
        let sort = [SortDescriptor(\ForgotItems.timestamp, order: .reverse)]
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


#Preview(as: .systemSmall) {
    ForgotWidget()
} timeline: {
    ForgotEntry()
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
