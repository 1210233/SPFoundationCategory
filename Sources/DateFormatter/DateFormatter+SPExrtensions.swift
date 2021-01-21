//
//  DateFormatter+SPExrtensions.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2020/12/30.
//

import Foundation


// MARK: - 快捷初始化
extension DateFormatter {
    /**
     
     Date formats:
     ===============
     
     MMM d, ''yy             Nov 4, '12
     'Week' w 'of 52'        Week 45 of 52
     'Day' D 'of 365'        Day 309 of 365
     m 'minutes past' h      9 minutes past 8
     h:mm a                  8:09 PM
     HH:mm:ss's'             20:09:00s
     HH:mm:ss:SS             20:09:00:00
     h:mm a zz               8:09 PM CST
     h:mm a zzzz             8:09 PM Central Standard Time
     yyyy-MM-dd HH:mm:ss Z    2012-11-04 20:09:00 -0600
     
     **/
    
    public
    enum Format: String {
        
    //    case `default` =
        ///  e.g. 1990-07-24 15:23:10
        case yyyy_MM_dd_HH_mm_ss =      "yyyy-MM-dd HH:mm:ss"
        ///  e.g. 1990-07-24
        case yyyy_MM_dd =               "yyyy-MM-dd"
        ///  e.g. 07-24 15:23
        case MM_dd_HH_mm =              "MM-dd HH:mm"
        ///  e.g. 07-24
        case MM_dd =                    "MM-dd"
        ///  e.g. 24-07-1990
        case dd_MM_yyyy =               "dd-MM-yyyy"
        ///  e.g. 24-Jul-1990
        case dd_MMM_yyyy =              "dd-MMM-yyyy"
        ///  e.g. 24-07-1990 05:20 AM
        case dd_MM_yyyy_HH_mm_12H =     "dd-MM-yyyy hh:mm a"
        ///  e.g. 24-07-1990 15:20
        case dd_MM_yyyy_HH_mm_ss =      "dd-MM-yyyy HH:mm:ss"
        ///  e.g. 24-07-1990 05:20 AM
        case dd_MM_yyyy_HH_mm_ss_12H =  "dd-MM-yyyy hh:mm:ss a"
        ///  e.g. 07-24-1990
        case MM_dd_yyyy =               "MM-dd-yyyy"
        ///  e.g. Jul 24, 1990
        case MMM_dd_yyyy =              "MMM dd, yyyy"
        ///  e.g. July 24
        case MMMM_dd =                  "MMMM dd"
        ///  such as July, November...
        case MMMM =                     "MMMM"
        ///  e.g. Jul 24, 2014 05:20:50 AM
        case MMM_dd_yyyy_HH_mm_ss_12H =     "MMM dd, yyyy hh:mm:ss a"
        ///  e.g. Jul 24, 2014 05:20 AM
        case MMM_dd_yyyy_HH_mm_12H =    "MMM dd, yyyy hh:mm a"
        ///  e.g. 15:20:50
        case HH_mm_ss =                 "HH:mm:ss"
        ///  e.g. Tue
        case E =                        "E"
        /// e.g. Tuesday
        case EEEE =                     "EEEE"
        ///  e.g. Q1,Q2,Q3,Q4
        case QQQ =                      "QQQ"
        ///  e.g. 4th quarter
        case QQQQ =                     "QQQQ"
        case FILE_NAME =                "yyyyMMddHHmmssSSS"
    }
    
    public convenience
    init(format: String) {
        self.init()
        self.dateFormat = format
    }
    
    public convenience
    init(_ format: Format) {
        self.init(format: format.rawValue)
    }
}


