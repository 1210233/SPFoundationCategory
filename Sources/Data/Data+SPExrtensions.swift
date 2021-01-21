//
//  Data+SPExrtensions.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2020/12/30.
//

import Foundation

extension Data {
    public
    var imageTypeForContent: String? {
        if let b = self.first {
            switch b {
            case 0xFF:
                return "image/jpeg";
            case 0x89:
                return "image/png";
            case 0x47:
                return "image/gif";
            case 0x49, 0x4D:
                return "image/tiff";
            case 0x52:
                // R as RIFF for WEBP
                if (self.count < 12) {
                    return nil
                }
                
                if let testString = String(data: self[0..<12], encoding: .ascii) {
                    if testString.hasPrefix("RIFF") && testString.hasSuffix("WEBP") {
                        return "image/webp";
                    }
                }
            default:
                return nil;
            }
        }
        return nil
    }
    
    public
    var describe: String {
        var string = self.description
        string.append(" is <")
        for i in 0 ..< self.count {
            let byte = self[i]
            string.append(String(format: "%02x", byte))
            if (i + 1) % 4 == 0 {
                string.append(" ")
            }
        }
        string.append(">")
       return string

    }
}
