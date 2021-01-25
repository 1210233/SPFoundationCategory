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

@inlinable
public func anyIsNil(_ a: Any) -> Bool {
    switch a {
    case Optional<Any>.none:
        return true
    default:
        return false
    }
}
