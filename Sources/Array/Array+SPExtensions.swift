//
//  Array+SPExtensions.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2020/12/30.
//

import Foundation

// MARK: - 增删操作
extension Array {
    public static
    func += (lhs: inout Array<Element>, rhs: Element) where Element: Equatable {
        if !lhs.contains(rhs) {
            lhs.append(rhs)
        }
    }
    public static
    func -= (lhs: inout Array<Element>, rhs: Element) where Element: Equatable {
        lhs.removeAll { (ele) -> Bool in
            return (rhs == ele)
        }
    }
    public static
    func -= (lhs: inout Array<Element>, rhs: Array<Element>) where Element: Equatable {
        lhs.remove(items: rhs)
    }
    
    @discardableResult mutating public
    func remove(_ item: Element) -> Int where Element: Equatable {
        var n = 0
        self.removeAll { (ele) -> Bool in
            if (item == ele) {
                n += 1
                return true
            }
            return false
        }
        return n
    }
    
    @discardableResult mutating public
    func remove(items: Array<Element>) -> Array<Element> where Element: Equatable {
        var removed = Array<Element>()
        self.removeAll { (ele) -> Bool in
            if items.contains(ele) {
                removed.append(ele)
                return true
            }
            return false
        }
        return removed
    }
}

// MARK: - 验证下标
extension Array {
    public
    func valid(index i: Int) -> Bool {
        return i < self.count && i >= 0
    }
}

// MARK: - JSON序列化
extension Array {
    public
    var jsonString: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
            return String(data: data, encoding: .utf8)
        } catch { }
        return nil
    }
}

// MARK: - 快捷访问
extension Array {
    public
    func nextObject(with object: Element?) -> Element? where Element: Equatable {
        if object == nil {
            return self.first
        }
        if let idx = self.firstIndex(of: object!) {
            if self.valid(index: idx + 1) {
                return self[idx + 1]
            }
        }
        return nil
    }
    
    public
    func previousObject(with object: Element?) -> Element? where Element: Equatable {
        if object == nil {
            return self.first
        }
        if let idx = self.firstIndex(of: object!) {
            if self.valid(index: idx - 1) {
                return self[idx - 1]
            }
        }
        return nil
    }
}

// MARK: - SPLog打印
extension Array {
    public
    func spLog(toLevel: UInt = 2) {
        let className = String(cString: object_getClassName(self))
        let content = self.logFromLevel(0, toLevel: toLevel, start: 0)
        print("<%@:%p> content:", className)
        print(content)
    }
    
    public
    func logFromLevel(_ level: UInt, toLevel: UInt, start: UInt) -> String {
        if level > toLevel {
            return "[...],\n"
        }
        
        var string = "[\n"
        var prefix = "  "
        for _ in 0 ..< level {
            prefix += "  "
        }
        for _ in 0 ..< start {
            prefix += "  "
        }
        for ele in self {
            string.append(prefix)
            if let e = ele as? NSNumber {
                string.append(e.stringValue)
            }else if let e = ele as? String {
                string.append("\"" + e + "\"")
            }else if let e = ele as? Dictionary<String, Any> {
                let content = e.logFromLevel(level + 1, toLevel: toLevel, start: start)
                string.append(content)
            }else if let e = ele as? Array {
                let content = e.logFromLevel(level + 1, toLevel: toLevel, start: start)
                string.append(content)
            }else if ele is NSNull || anyIsNil(ele) {
                string.append("null")
            }else if let e = ele as? NSObject {
                let cls = String(cString: object_getClassName(ele))
                let temp = e.description
                if !temp.contains(cls) {
                    string.append(String(format: "<%@:%@>", cls, temp))
                }else {
                    string.append(temp)
                }
            } else {
                string.append(String(describing: ele))
            }
            string.append(",\n")
        }
        if !self.isEmpty {
            string = string[0 ..< string.count - 2]
        }
        string.append(prefix)
        var s = string.index(before: string.endIndex)
        s = string.index(before: s)
        string.removeSubrange(s ..< string.endIndex)
        
        if level != 0 {
            string.append("],\n")
        }else {
            string.append("]\n")
        }
        
        return string
    }
}

// MARK: - 过滤空对象
extension Array {
    public
    func filterNullValues() -> Self {
        return self.filter { (ele) -> Bool in
            return !(ele is NSNull)
        }
    }
    
    mutating public
    func filterNullValues() {
        self.removeAll { (ele) -> Bool in
            return ele is NSNull
        }
    }
}
