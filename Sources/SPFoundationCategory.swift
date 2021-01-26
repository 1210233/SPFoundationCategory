//
//  SPFoundationCategory.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2020/12/23.
//

import Foundation

var sp_pinyinKey = "sp_pinyinKey"
var sp_md5SumKey = "sp_md5SumKey"
var sp_sha1SumKey = "sp_sha1SumKey"
var sp_sha256SumKey = "sp_sha256SumKey"
var sp_date_stringKey = "sp_date_stringKey"

public let GB_18030_2000: String.Encoding = {
    let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
    return String.Encoding(rawValue: enc)
}()


/// 判断Any是否是nil. 与 value == nil 等价。
postfix operator =?
postfix public func =? (value: Any?) -> Bool {
    if value == nil {
        return true
    }
    switch value! {
    case Optional<Any>.none:
        return true
    default:
        return false
    }
}
@inlinable
public func anyIsNil(_ a: Any) -> Bool {
    return a=?
}

/// 判断数值是否非0.
prefix operator !!
prefix public func !! <T: Numeric>(value: T) -> Bool {
    return value != 0
}
/// 判断可选数值是否非0.
prefix operator !!!
prefix public func !!! <T: Numeric>(value: T?) -> Bool {
    if value == nil {
        return true
    }
    return !!(value!)
}
