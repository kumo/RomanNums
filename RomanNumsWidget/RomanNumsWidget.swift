//
//  RomanNumsWidget.swift
//  RomanNumsWidget
//
//  Created by Robert Clarke on 14/06/21.
//  Copyright © 2021 Robert Clarke. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let date = Date()
        return SimpleEntry(date: date, romanDate: "MMXXV")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let date = Date()
        let romanDate = date.dateInRoman()
        let entry = SimpleEntry(date: Date(), romanDate: romanDate ?? "Error converting date")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        for dayOffset in 0 ..< 2 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfDay)!
            let romanDate = entryDate.dateInRoman()
            let entry = SimpleEntry(date: entryDate, romanDate: romanDate ?? "Error converting date")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let romanDate: String
}

struct RomanNumsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.romanDate)
            .multilineTextAlignment(.center)
            .lineLimit(3)
    }
}

@main
struct RomanNumsWidget: Widget {
    let kind: String = "RomanNumsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RomanNumsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct RomanNumsWidget_Previews: PreviewProvider {
    static var previews: some View {
        RomanNumsWidgetEntryView(entry: SimpleEntry(date: Date(), romanDate: "XX-XX-XXXX"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
