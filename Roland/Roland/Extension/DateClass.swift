//
//  DateClass.swift
//  Roland
//
//  Created by 林希語 on 2021/11/4.
//

import Foundation

import UIKit

class DateClass {
    
    // MARK: 比較時間先後
    static func compareOneDay(oneDay: String, withAnotherDay anotherDay: Date) -> Int {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd.HH:mm"
//        let oneDayStr: String = dateFormatter.string(from: oneDay)
        let anotherDayStr: String = dateFormatter.string(from: anotherDay)
        let dateA = dateFormatter.date(from: oneDay)
        let dateB = dateFormatter.date(from: anotherDayStr)
        let result: ComparisonResult = (dateA?.compare(dateB!))!
        
        // Date1  is in the future
        if result == ComparisonResult.orderedDescending {
            return 1
            
        }
        
        // Date1 is in the past
        else if result == ComparisonResult.orderedAscending {
            return 2
            
        }
        
        // Both dates are the same
        else {
            return 0
        }
    }
}
