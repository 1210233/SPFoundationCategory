//
//  Array+SPExtensions.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2020/12/30.
//

import Foundation

// MARK: - 增删操作
extension Array where Element: Equatable {
    public static
    func += (lhs: inout Self, rhs: Element) {
        if !lhs.contains(rhs) {
            lhs.append(rhs)
        }
    }
    public static
    func -= (lhs: inout Self, rhs: Element) {
        lhs.remove(rhs)
    }
    public static
    func -= (lhs: inout Self, rhs: Self) {
        lhs.remove(rhs)
    }
    
    /// 删除指定的对象
    /// - Parameter item: 指定对象
    /// - Returns: 被删除的次数
    @discardableResult mutating public
    func remove(_ item: Element) -> Int {
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
    func remove(_ items: Self) -> Self {
        var removed: Self = []
        self.removeAll { (ele) -> Bool in
            if items.contains(ele) {
                removed.append(ele)
                return true
            }
            return false
        }
        return removed
    }
    
    @discardableResult mutating public
    func remove(firstAppear item: Element) -> Int? {
        if let idx = self.firstIndex(of: item) {
            self.remove(at: idx)
            return idx
        }
        return nil
    }
    
    @discardableResult mutating public
    func remove(lastAppear item: Element) -> Int? {
        if let idx = self.lastIndex(of: item) {
            self.remove(at: idx)
            return idx
        }
        return nil
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
extension Array where Element: Equatable  {
    public
    func nextObject(with object: Element?) -> Element? {
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
    func previousObject(with object: Element?) -> Element? {
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

// MARK: - 取子集
extension Array {
    func array(where predicate: (Element) -> Bool) -> Self {
        var arr: Self = []
        self.forEach { ele in
            if predicate(ele) {
                arr.append(ele)
            }
        }
        return arr
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
