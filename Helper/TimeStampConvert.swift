//
//  TimeS.swift
//  Relic
//
//  Created by apple on 2024/1/28.
//

import Foundation

extension String {
    func toDateFromUnixTimestamp() -> Date? {
        guard let timestamp = TimeInterval(self) else {
            return nil
        }
        return Date(timeIntervalSince1970: timestamp)
    }
}

extension Date {
    func toUnixTimestampString() -> String {
        let timestamp = self.timeIntervalSince1970
        return String(timestamp)
    }
}


extension Date{
    
    func is_in_same_day(as date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, equalTo: date, toGranularity: .day)
    }
    
    func is_in_same_week(as date: Date) -> Bool {
           let calendar = Calendar.current
           return calendar.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    
    func is_in_same_year(as date: Date) -> Bool {
           let calendar = Calendar.current
           return calendar.isDate(self, equalTo: date, toGranularity: .year)
    }
    
    
    enum DateFormat: String{
        case day = "HH"
        case month = "MM"
        case year = "yyyy"
        
        case dayily = "HH:mm"
        case weekily = "EEEE"
        case monthily = "MM-dd"
        case yearly = "MM-dd-yyyy"
    }
    
    func toString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func toString(dateFormat: DateFormat) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        return dateFormatter.string(from: self)
    }
}
