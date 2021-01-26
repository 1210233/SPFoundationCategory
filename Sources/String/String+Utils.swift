//
//  String+Utils.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2020/12/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - 转换
extension String {
    public
    var pinyin: String {
        get {
            if let str = objc_getAssociatedObject(self, &sp_pinyinKey) as? String {
                return str
            }
            
            let mString = NSMutableString(string: self)
            var str = ""
            if CFStringTransform(mString, nil, kCFStringTransformToLatin, false),
               CFStringTransform(mString, nil, kCFStringTransformStripCombiningMarks, false) {
                mString.replaceOccurrences(of: " ", with: "", range: NSRange(location: 0, length: mString.length))
                str = String(mString)
            }
            objc_setAssociatedObject(self, &sp_pinyinKey, str, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            return str
        }
    }
    
    public
    func fileSize() -> UInt {
        let mgr = FileManager.default
        var dir: ObjCBool = false
        let exiset = mgr.fileExists(atPath: self, isDirectory: &dir)
        if !exiset {
            return 0
        }
        
        var totalByteSize = UInt(0)
        if dir.boolValue {
            if let subpaths = mgr.subpaths(atPath: self) {
                for subpath in subpaths {
                    let fullSubpath = self.appending(subpath)
                    var isDir: ObjCBool = false
                    mgr.fileExists(atPath: fullSubpath, isDirectory: &isDir)
                    if isDir.boolValue {
                        do {
                            let attri = try mgr.attributesOfItem(atPath: fullSubpath)
                            if let size = attri[FileAttributeKey.size] as? UInt {
                                totalByteSize += size
                            }
                        } catch  { }
                    }
                }
            }
        } else {
            do {
                let attri = try mgr.attributesOfItem(atPath: self)
                if let size = attri[FileAttributeKey.size] as? UInt {
                    totalByteSize = size
                }
            } catch  { }
        }
        return totalByteSize
    }
    
    public
    func toDate(format: String = "YYYY-MM-dd HH:mm:ss") -> Date? {
        let fmt = DateFormatter(format: format)
        return fmt.date(from: self)
    }
    
    public
    func stringDateToHmString() -> String {
        let fmt = DateFormatter(format: "YYYY-MM-dd HH:mm:ss")
        let fmt1 = DateFormatter(format: "YYYY-MM-dd HH:mm")
        if let date = fmt.date(from: self) {
            return fmt1.string(from: date)
        } else {
            return self
        }
    }
    
    #if canImport(UIKit)
    public
    func textSize(forFont font: UIFont = UIFont.systemFont(ofSize: UIFont.labelFontSize), maxWidth width:CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        let string = NSString(string: self)
        let rect = string.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil)
        return rect.size;
    }
    #endif
}

// MARK: - 正则验证
extension String {
    public
    var isBlank: Bool {
        let string = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return string.isEmpty
    }
    
    public
    var isValidIDCard: Bool {
        if self.count == 18 {
            let predicate = NSPredicate(format: "SELF MATCHES %@", "[1-9]\\d{5}(18|19|20|21)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|[1-3]0|31)\\d{3}[\\dXx]")
            if (predicate.evaluate(with: self)) {
                return self.lowercased().verifingForIDCard();
            }
        }
        return false;
    }
    
    private func verifingForIDCard() -> Bool {
        let rat = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3];
        let code: [UInt8] = [49, 48, 120, 57, 56, 55, 54, 53, 52, 51, 50]
        var total = 0
        
        let cs = UnsafeMutableRawPointer.allocate(byteCount: 18, alignment: 1)
        memcpy(cs, self.cString(using: .ascii), 18)
        for i in 0 ..< 17 {
            let p = cs + i
            total += (rat[i % 10] * (Int(p.load(as: UInt8.self)) - 48))
        }
        let result = (cs + 17).load(as: UInt8.self)
        cs.deallocate()
        return result == code[total % 11]
    }
    
    public
    var isPhoneNumber: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "((13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])+\\d{8})$")
        return predicate.evaluate(with: self)
    }
    
    public
    var isChinese: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(^[\\u4e00-\\u9fa5]+$)")
        return predicate.evaluate(with: self)
    }
    public
    var containsChinese: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(.*[\\u4e00-\\u9fa5].*)")
        return predicate.evaluate(with: self)
    }
    public
    var isPureInt: Bool {
        let s = Scanner(string: self)
        return (s.scanInt(nil) && s.isAtEnd)
    }
    
    public
    var isPureFloat: Bool {
        let s = Scanner(string: self)
        return (s.scanFloat(nil) && s.isAtEnd)
    }
    
    public
    var containsEmoji: Bool {
        for s in self.unicodeScalars {
            if s.isEmoji {
                return true
            }
        }
        return false
    }
}

// MARK: - 表情字符
extension Unicode.Scalar {
    public
    var isEmoji: Bool {
        let unicode = self.value
        let codes: [UInt32] = [0x0023, 0x002A, 0x00A9, 0x00AE, 0x203C, 0x2049, 0x2122, 0x2139,
                               0x21A9, 0x21AA, 0x231A, 0x231B, 0x2328, 0x23CF, 0x24C2, 0x25AA,
                               0x25AB, 0x25B6, 0x25C0, 0x260E, 0x2611, 0x2614, 0x2615, 0x2618,
                               0x261D, 0x2620, 0x2622, 0x2623, 0x2626, 0x262A, 0x262E, 0x262F,
                               0x2660, 0x2663, 0x2665, 0x2666, 0x2668, 0x267B, 0x267F, 0x2696,
                               0x2697, 0x2699, 0x269B, 0x269C, 0x26A0, 0x26A1, 0x26AA, 0x26AB,
                               0x26B0, 0x26B1, 0x26BD, 0x26BE, 0x26C4, 0x26C5, 0x26C8, 0x26CE,
                               0x26CF, 0x26D1, 0x26D3, 0x26D4, 0x26E9, 0x26EA, 0x26FD, 0x2702,
                               0x2705, 0x270F, 0x2712, 0x2714, 0x2716, 0x271D, 0x2721, 0x2728,
                               0x2733, 0x2734, 0x2744, 0x2747, 0x274C, 0x274E, 0x2757, 0x2763,
                               0x2764, 0x27A1, 0x27B0, 0x27BF, 0x2934, 0x2935, 0x2B1B, 0x2B1C,
                               0x2B50, 0x2B55, 0x3030, 0x303D, 0x3297, 0x3299, 0x23F0]
        if codes.contains(unicode) {
            return true
        }
        if (unicode >= 0x0030 && unicode <= 0x0039)  ||
            (unicode >= 0x2194 && unicode <= 0x2199) ||
            (unicode >= 0x23E9 && unicode <= 0x23F3) ||
            (unicode >= 0x23F8 && unicode <= 0x23FA) ||
            (unicode >= 0x25FB && unicode <= 0x25FE) ||
            (unicode >= 0x2600 && unicode <= 0x2604) ||
            (unicode >= 0x2638 && unicode <= 0x263A) ||
            (unicode >= 0x2648 && unicode <= 0x2653) ||
            (unicode >= 0x2692 && unicode <= 0x2694) ||
            (unicode >= 0x26F0 && unicode <= 0x26F5) ||
            (unicode >= 0x26F7 && unicode <= 0x26FA) ||
            (unicode >= 0x2708 && unicode <= 0x270D) ||
            (unicode >= 0x2753 && unicode <= 0x2755) ||
            (unicode >= 0x2795 && unicode <= 0x2797) ||
            (unicode >= 0x2B05 && unicode <= 0x2B07) {
            return true
        }
        return false
    }
}

// MARK: - 下标子字符串
extension String {
    
    // MARK: string[NSRage]
    public
    subscript(bounds: NSRange) -> String {
        if bounds.location < 0  || bounds.location >= self.count {
            return ""
        }
        var length = bounds.length
        if bounds.location + length > self.count {
            length = self.count - bounds.location
        }
        if length <= 0 {
            return ""
        }
        return self[bounds.location ... bounds.location + length]
    }
    // MARK: string[x ..< y]
    public
    subscript(r: Range<Int>) -> String {
        return self[r.lowerBound ... (r.upperBound - 1)]
    }
    // MARK: string[x ... y]
    public
    subscript(r: ClosedRange<Int>) -> String {
        var upperBound = r.upperBound
        if upperBound >= self.count {
            upperBound = self.count - 1
        }
        if r.lowerBound < 0 ||
            r.lowerBound >= upperBound {
            return ""
        }
        
        let sIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let eIndex = self.index(self.startIndex, offsetBy: upperBound)
        return String(self[sIndex ... eIndex])
    }
    // MARK: string[x ...]
    public
    subscript(r: PartialRangeFrom<Int>) -> String {
        return self[r.lowerBound ... self.count - 1]
    }
    // MARK: string[... y]
    public
    subscript(r: PartialRangeThrough<Int>) -> String {
        if self.isEmpty {
            return ""
        }
        return self[0 ... r.upperBound]
    }
    // MARK: string[..< y]
    public
    subscript(r: PartialRangeUpTo<Int>) -> String {
        if self.isEmpty {
            return ""
        }
        return self[0 ..< r.upperBound]
    }
    // MARK: string[loc, len]
    public
    subscript(loc: Int, len: Int = 1) -> String {
        return self[NSRange(location: loc, length: len)]
    }
}

extension Int {
    public static func ..< (minimum: Int, rhs: String.RangeUpper) -> (Int, String.RangeUpper) {
        return (minimum, String.RangeUpper(offset: rhs.offset - 1))
    }
    public static func ... (minimum: Int, rhs: String.RangeUpper) -> (Int, String.RangeUpper) {
        return (minimum, rhs)
    }
}

extension String {
    public
    struct RangeUpper {

        public static
        var end: RangeUpper {
            return RangeUpper()
        }

        fileprivate
        var offset: Int = 0

        public static
        func + (lhs: RangeUpper, rhs: Int) -> RangeUpper {
            return RangeUpper(offset: lhs.offset + rhs)
        }
        
        public static
        func - (lhs: RangeUpper, rhs: Int) -> RangeUpper {
            return RangeUpper(offset: lhs.offset - rhs)
        }
        
        public static
        func == (lhs: RangeUpper, rhs: RangeUpper) -> Bool {
            return lhs.offset == rhs.offset
        }
    }
    
    public
    subscript(range: (Int, RangeUpper)) -> String {
        if self.isEmpty {
            return self
        }
        
        var up = self.count - 1 + range.1.offset
        if up < 0 {
            up = 0
        } else if up > self.count - 1 {
            up = self.count - 1
        }
        var down = range.0
        
        if down > up {
            down = up
        }
        return self[down ... up]
    }
}

// MARK: - Json序列化
extension String {
    public
    enum JsonObjectType {
        case array
        case dictionary
        case empty
    }
    
    public
    func jsonObject() -> (type: JsonObjectType, obj: Any?) {
        if let data = self.data(using: .utf8) {
            do {
                let o = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let _ = o as? Array<Any> {
                    return (JsonObjectType.array, o)
                }else if let _ = o as? Dictionary<String, Any> {
                    return (JsonObjectType.dictionary, o)
                }
            } catch { }
        }
        return (JsonObjectType.empty, nil)
    }
    
    public
    var isValid: Bool {
        return ((self.count != 0) && (self != "null"))
    }
}

// MARK: - 加密
extension String {
    
    public
    var md5Sum: String {
        if let v = objc_getAssociatedObject(self, &sp_md5SumKey) as? String {
            return v
        }
        if let data = self.data(using: .utf8) {
            let string = data.md5Sum
            objc_setAssociatedObject(self, &sp_md5SumKey, string, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            return string
        } else {
            return ""
        }
    }
    
    public
    var sha1Sum: String {
        if let v = objc_getAssociatedObject(self, &sp_sha1SumKey) as? String {
            return v
        }
        if let data = self.data(using: .utf8) {
            let string = data.sha1Sum
            objc_setAssociatedObject(self, &sp_sha1SumKey, string, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            return string
        } else {
            return ""
        }
    }
    
    public
    var sha256Sum: String {
        if let v = objc_getAssociatedObject(self, &sp_sha256SumKey) as? String {
            return v
        }
        if let data = self.data(using: .utf8) {
            let string = data.sha256Sum
            objc_setAssociatedObject(self, &sp_sha256SumKey, string, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            return string
        } else {
            return ""
        }
    }
}


/// 定义优先级组
precedencegroup EmptyStringPrecedence {
    lowerThan: CastingPrecedence        // 优先级, 比类型转换运算低(is, as)
    higherThan: NilCoalescingPrecedence   // 优先级,比Nil合并运算符高(??)
    associativity: left                 // 结合方向:left, right or none
    assignment: false                   // true=赋值运算符,false=非赋值运算符
}

infix operator ??? : EmptyStringPrecedence
public func ??? (optional: String?, defaultValue: @autoclosure () -> String) -> String {
    if optional != nil, !optional!.isEmpty {
        return optional!
    }
    return defaultValue()
}
