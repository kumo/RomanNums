//
//  TodayViewController.swift
//  Today in Roman Nums
//
//  Created by Robert Clarke on 03/09/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

import UIKit
import NotificationCenter

extension Int {
    func toRoman() -> String? {
        var number = self
        
        if (number < 1) {
            return nil
        }
        
        let values = [("M", 1000), ("CM", 900), ("D", 500), ("CD", 400), ("C",100), ("XC", 90), ("L",50), ("XL",40), ("X",10), ("IX", 9), ("V",5),("IV",4), ("I",1)]
        
        var result = ""
        
        
        for (romanChar, arabicValue) in values {
            var count = number / arabicValue
            
            if count == 0 { continue }
            
            for _ in 1...count
            {
                result += romanChar
                number -= arabicValue
            }
        }
        
        return result
    }
}

extension NSDate {
    func dateInRoman() -> String? {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: self)
        
        let month = components.month
        let day = components.day
        var year = components.year
        
        let locale = NSLocale.currentLocale().localeIdentifier // en_GB@currency=EUR ?!
        
        // some defaults
        var format = "."
        var longYears = true
        
        var preferences = NSUserDefaults(suiteName: "group.it.kumo.roman")
        
        if preferences.valueForKey("long_years") != nil {
            longYears = preferences.valueForKey("long_years").boolValue
            
            if (longYears == false) {
                year = year % 100
            }
        }
        
        if preferences.valueForKey("date_format") != nil {
            let dateFormat = preferences.valueForKey("date_format").integerValue
            
            if (dateFormat == 1) {
                format = "-";
            } else if (dateFormat == 2) {
                format = " ";
            }
        }

        if (locale == "en_US") {
            return month.toRoman()! + format + day.toRoman()! + format + year.toRoman()!
        } else {
            return day.toRoman()! + format + month.toRoman()! + format + year.toRoman()!
        }
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        NSLog(dateLabel.text!)
        
        let date = NSDate()
        
        dateLabel.text = date.dateInRoman()
        completionHandler(NCUpdateResult.NewData)
        
        /*if (dateLabel.text == "Why hello!?") {
        completionHandler(NCUpdateResult.NoData)
        } else {
        dateLabel.text = "Why hello!?"
        
        completionHandler(NCUpdateResult.NewData)
        }*/
    }
    
}
