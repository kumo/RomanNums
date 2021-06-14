//
//  WidgetConverter.swift
//  Roman Numerals
//
//  Created by Robert Clarke on 14/06/21.
//  Copyright © 2021 Robert Clarke. All rights reserved.
//

import Foundation

extension Date {
    func dateInRoman() -> String? {
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self as Date)
        
        let month = components.month
        let day = components.day
        var year = components.year
        
        var locale = NSLocale.current.identifier // en_GB@currency=EUR ?!
        
        // some defaults
        var format = "."
        var longYears = true
        
        if let preferences = UserDefaults(suiteName: "group.it.kumo.roman") {
        
            if let _ = preferences.value(forKey: "long_years") {
                longYears = preferences.bool(forKey: "long_years")
                
                if (longYears == false) {
                    year = year! % 100
                }
            }
            
            if let _ = preferences.value(forKey: "date_format") {
                let dateFormat = preferences.integer(forKey: "date_format")
                
                if (dateFormat == 1) {
                    format = "-";
                } else if (dateFormat == 2) {
                    format = " ";
                }
            }
            
            if let _ = preferences.value(forKey: "date_order") {
                
                let order = preferences.integer(forKey: "date_order")
                
                if (order == 1) {
                    locale = "en_GB"
                } else if (order == 2) {
                    locale = "en_US"
                }
            }
        }

        if (locale == "en_US") {
            return month!.toRoman()! + "\u{200B}" + format + "\u{200B}" + day!.toRoman()! + "\u{200B}" + format + "\u{200B}" + year!.toRoman()!
        } else {
            return day!.toRoman()! + "\u{200B}" + format + "\u{200B}" + month!.toRoman()! + "\u{200B}" + format + "\u{200B}" + year!.toRoman()!
        }
    }
}
