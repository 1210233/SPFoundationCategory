//
//  Date+SPExrtensions.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2020/12/30.
//

import Foundation

// MARK: - 快捷访问分量
extension Date {
    public static
    var nowTime: String {
        return Date().string
    }
    public static
    var timeStamp: TimeInterval {
        return Date().timeStamp
    }
    public static
    var todayDate: String {
        let fmt = DateFormatter(.yyyy_MM_dd)
        return fmt.string(from: Date())
    }
    
    
    public
    var nearestHour: Int {
        let date = self + 1800
        return Calendar.current.component(.hour, from: date)
    }
    public
    var timeStamp: TimeInterval {
        return self.timeIntervalSince1970
    }
    public
    var year: Int {
//        let components = Calendar.current.dateComponents([.year, .month, .day, .weekOfYear, .hour], from: self)
        return Calendar.current.component(.year, from: self)
    }
    public
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    public
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    public
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    public
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    public
    var seconds: Int {
        return Calendar.current.component(.second, from: self)
    }
    public
    var weeks: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    /// 当周的第几天（从星期天开始算）
    public
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    /// 星期几
    public
    var week: Int {
        return Calendar.current.component(.weekdayOrdinal, from: self)
    }
    
    /// 中文的年份
    public
    var chineseYear: String {
        var integer = self.year
        let numArray: [Character] = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        if integer <= 0 {
            return "零年";
        }else{
            var str = String()
            while ((integer / 10 != 0)) {
                str.insert(numArray[integer % 10], at: str.startIndex)
                integer /= 10;
            }
            str.insert(numArray[integer], at: str.startIndex)
            str.append("年")
            return str
        }
    }
    
    /// 中文的月份
    public
    var chineseMonth: String {
        let integer = self.month
        let numArray: [Character] = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        if integer <= 0 {
            return "零月";
        }else{
            var str = String()
            if (integer < 10) {
                str.append(numArray[integer])
            }else{
                str.append("十")
                if (integer > 10) {
                    str.append(numArray[integer % 10])
                }
            }
            str.append("月")
            return str
        }
    }

    /// 中文的日期
    public
    var chineseDay: String {
        let integer = self.day
        let numArray: [Character] = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        if (integer <= 0) {
            return "零日";
        }else{
            var str = String()
            if (integer < 10) {
                str.append(numArray[integer])
            }else{
                str.append("十")
                if integer == 10 {
                    
                } else if integer < 20 {
                    str.append(numArray[integer % 10])
                }else if integer % 10 == 0 {
                    str.insert(numArray[integer / 10], at:str.startIndex)
                }else{
                    str.insert(numArray[integer / 10], at:str.startIndex)
                    str.append(numArray[integer % 10])
                }
            }
            str.append("日")
            return str
        }
    }
}

// MARK: - 转换
extension Date {
    public
    var string: String {
        if let v = objc_getAssociatedObject(self, "date_string") as? String {
            return v
        }
        
        let fmt = DateFormatter(.yyyy_MM_dd_HH_mm_ss)
        let d = fmt.string(from: self)
        objc_setAssociatedObject(self, "date_string", d, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return d
    }
    
    public
    func string(usingFormat format: DateFormatter.Format = .yyyy_MM_dd_HH_mm_ss) -> String {
        let fmt = DateFormatter(format)
        let d = fmt.string(from: self)
        return d
    }
    
    public static
    func string(forFileName suffix: String?) -> String {
        let fmt = DateFormatter(format: "yyyyMMddHHmmssSSS")
        var string = fmt.string(from: Date())
        if suffix != nil {
            string += "." + suffix!
        }
        return string
    }
}

// MARK: - 计算
extension Date {
    /// 获取与另一个Date的差值，单位以传入的component为基准，component不传则结果为秒。
    /// - Parameters:
    ///   - date: another date
    ///   - component: usable in Calendar.Component which in [.day, .month, .year, .hour, .minute, .second] and default is .second
    /// - Returns: distance for given component
    public
    func distance(from date: Date, in component: Calendar.Component = .second) -> Int64 {
        if component == .year ||
            component == .month {
            
            let components = Calendar.current.dateComponents([.year, .month], from: date, to: self)
            var count = components.year ?? 0
            if component == .year {
                return Int64(count)
            }
            // Month
            count = count * 12 + (components.month ?? 0)
            return Int64(count)
        }else {
            let ti = self.timeIntervalSince(date)
            if component == .day {
                return Int64(ti / 86400)
            }
            if component == .hour {
                return Int64(ti / 3600)
            }
            if component == .minute {
                return Int64(ti / 60)
            }
            if component == .second {
                return Int64(ti)
            }
        }
        return 0
    }
    
    public static
    func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSince(rhs)
    }
}
