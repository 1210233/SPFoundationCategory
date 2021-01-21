//
//  Date+SPConvert.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2021/1/7.
//

import Foundation

// MARK: - 比较和转换
extension Date {
    public
    enum CompareCurrentStyle {
        case `default`
        case style1
    }
    
    public static
    func compareCurrentFrom(string: String, style: CompareCurrentStyle = .default) -> String {
        let fmt = DateFormatter(.yyyy_MM_dd_HH_mm_ss)
        if let date = fmt.date(from: string) {
            return self.compareCurrentFrom(date: date, style: style)
        }
        return string
    }
    
    public static
    func compareCurrentFrom(date: Date, style: CompareCurrentStyle = .default) -> String {
        return self.compareCurrentFrom(interval: date.timeIntervalSince1970, style: style)
    }
    
    public
    var compareWithCurrent: String {
        return Date.compareCurrentFrom(date: self)
    }
    
    public static
    func compareCurrentFrom(interval: TimeInterval, style: CompareCurrentStyle = .default) -> String {
        let time = interval > 4102415999 ? interval / 1000 : interval
        let seconds = self.timeStamp - time
        if seconds < 60 {
            return "刚刚"
        } else if seconds < 3600 { // 1小时内
            return String(format: "%.0lf分钟前", seconds / 60)
        } else if seconds < 86400 { // 1天内
            return String(format: "%.0lf小时前", seconds / 3600)
        }
        if style == .style1 {
            if seconds < (2 * 86400) { // 昨天以内
                let fmt = DateFormatter(format: "昨天 HH:mm")
                return fmt.string(from: Date(timeIntervalSince1970: time))
            } else if seconds < (180 * 86400) { // 1个月内
                let fmt = DateFormatter(.MM_dd_HH_mm)
                return fmt.string(from: Date(timeIntervalSince1970: time))
            } else {
                let fmt = DateFormatter(format: "yyyy-MM-dd HH:mm")
                return fmt.string(from: Date(timeIntervalSince1970: time))
            }
        } else {
            if seconds < (30 * 86400) { // 1个月内
                return String(format: "%.0lf天前", seconds / 86400)
            } else if seconds < (6 * 30 * 24 * 3600) { // 半年内
                let fmt = DateFormatter(.MM_dd)
                return fmt.string(from: Date(timeIntervalSince1970: time))
            } else {
                let fmt = DateFormatter(.yyyy_MM_dd)
                return fmt.string(from: Date(timeIntervalSince1970: time))
            }
        }
    }
}
