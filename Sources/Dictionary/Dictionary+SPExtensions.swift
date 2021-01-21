//
//  Dictionary+SPExtensions.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2021/1/7.
//

import Foundation

// MARK: - JSON序列化
extension Dictionary {
    public
    var jsonString: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
            return String(data: data, encoding: .utf8)
        } catch { }
        return nil
    }
}

// MARK: - SPLog打印
extension Dictionary {
    public
    func spLog(toLevel: UInt = 2) where Key == String  {
        let content = self.logFromLevel(0, toLevel: toLevel, start: 0)
        print(String(format: "<\(Self.self):%p> content: " + content, self))
    }
    
    public
    func logFromLevel(_ level: UInt, toLevel: UInt, start: UInt) -> String where Key == String {
        if level > toLevel {
            return "{...}\n"
        }
        
        var string = "{\n"
        var prefix = "  "
        for _ in 0 ..< level {
            prefix += "  "
        }
        for _ in 0 ..< start {
            prefix += "  "
        }
        self.forEach { (key, value) in
            var temp = "\"" + key + "\":"
            string.append(prefix)
            string.append(temp)
            
            if let v = value as? NSNumber {
                string.append(v.stringValue)
            } else if let v = value as? String {
                string.append(v)
            } else if let v = value as? Dictionary<Key, Any> {
                let content = v.logFromLevel(level + 1, toLevel: toLevel, start: start)
                string.append(content)
            } else if let v = value as? Array<Any> {
                let content = v.logFromLevel(level + 1, toLevel: toLevel, start: start)
                string.append(content)
            } else if value is NSNull || anyIsNil(value) {
                string.append("null")
            } else if let v = value as? NSObject {
                let cls = String(cString: object_getClassName(v))
                temp = v.description
                if !temp.contains(cls) {
                    string.append(String(format: "<%@:%@>", cls, temp))
                }else {
                    string.append(temp)
                }
            } else {
                string.append(String(describing: value))
            }
            string.append(",\n")
        }
        if !self.isEmpty {
            string = string[0 ..< string.count - 2]
        }
        string.append("\n}")
        return string
    }
}

// MARK: - 过滤空对象
extension Dictionary {
    public
    func filterNullValues() -> Self {
         return self.filter { (key, value) -> Bool in
            return !(value is NSNull)
        }
    }
    
    mutating public
    func filterNullValues() {
        self.forEach { (key, value) in
            if value is NSNull {
                self.removeValue(forKey: key)
            }
        }
    }
}
