//
//  Data+Security.swift
//  SPFoundationCategory module
//
//  Created by LSP on 2021/1/7.
//

import Foundation
import CommonCrypto
import zlib

// MARK: - 加解密
// MARK: SHA&MD5
extension Data {
    public
    var md5Sum: String {
        if let v = objc_getAssociatedObject(self, "md5Sum") as? String {
            return v
        }
        let string = self.stringForSum(.md5)
        objc_setAssociatedObject(self, "md5Sum", string, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return string
    }
    
    public
    var sha1Sum: String {
        if let v = objc_getAssociatedObject(self, "sha1Sum") as? String {
            return v
        }
        let string = self.stringForSum(.sha1)
        objc_setAssociatedObject(self, "sha1Sum", string, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return string
    }
    
    public
    var sha256Sum: String {
        if let v = objc_getAssociatedObject(self, "sha256Sum") as? String {
            return v
        }
        let string = self.stringForSum(.sha256)
        objc_setAssociatedObject(self, "sha256Sum", string, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return string
    }
    
    public
    var crc32Value: UInt32 {
        return self.withUnsafeBytes {pointer in
            guard let d = pointer.baseAddress else {
                return 0
            }
            let data = d.bindMemory(to: UInt8.self, capacity: self.count)
            var crc = crc32(0, nil, 09)
            crc = crc32(uLong(crc), data, uInt(self.count))
            return UInt32(crc)
        }
    }
    
    enum DataSum {
        case sha1
        case md5
        case sha256
    }
    private
    func stringForSum(_ sum: DataSum) -> String {
        var len = Int(CC_SHA1_DIGEST_LENGTH)
        if sum == .md5 {
            len = Int(CC_MD5_DIGEST_LENGTH)
        } else if sum == .sha256 {
            len = Int(CC_SHA256_DIGEST_LENGTH)
        }
        var buffer = [UInt8](repeating: 0, count: len)
        guard buffer.withUnsafeMutableBufferPointer({ bytes in
            guard let digest = bytes.baseAddress else {
                return false
            }
            return self.withUnsafeBytes {pointer in
                guard let data = pointer.baseAddress else {
                    return false
                }
                switch sum {
                case .md5:
                    CC_MD5(data, CC_LONG(self.count), digest)
                break
                case .sha1:
                    CC_SHA1(data, CC_LONG(self.count), digest)
                break
                case .sha256:
                    CC_SHA256(data, CC_LONG(self.count), digest)
                }
                
                return true
            }
        }) else {
            return ""
        }
        var string = ""
        buffer.forEach { byte in
            string.append(String(format: "%02x", byte))
        }
        return string
    }
}

// MARK: AES加解密
extension Data {
    //===>>>>>>>AES
    public
    enum AesLength {
        case aes128
        case aes256
    }
    
    public
    enum AesType {
        case decrypt
        case encrypt
    }
    
    public
    func aes(_ type: AesType, withKey key: String, len: AesLength = .aes128) -> Data? {
 
        let cnt = (len == .aes128 ? kCCKeySizeAES128 : kCCKeySizeAES256) + 1
        var keyBuffer = [CChar](repeating: 0, count: cnt)
        guard key.getCString(&keyBuffer, maxLength: cnt, encoding: .utf8) else {
            return nil
        }

        var dataLength = self.count
        dataLength -= dataLength % 16
        
        let bufferLength = dataLength + kCCBlockSizeAES128
        let bufferBytes = UnsafeMutableRawPointer.allocate(byteCount: bufferLength, alignment: 1)
        var bytesDecrypted: size_t = 0
        
        guard self.withUnsafeBytes({ bytes in
            guard let dataBytes = bytes.baseAddress else {
                return false
            }
            return keyBuffer.withUnsafeBufferPointer({ buffer in
                guard let keyPtr = buffer.baseAddress else {
                    return false
                }
                let option = type == .encrypt ? kCCEncrypt : kCCDecrypt
                let cryptState = CCCrypt(CCOptions(option),
                                         CCOperation(kCCAlgorithmAES),
                                         CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode),
                                         keyPtr,
                                         kCCBlockSizeAES128,
                                         nil,
                                         dataBytes,
                                         dataLength,
                                         bufferBytes,
                                         bufferLength,
                                         &bytesDecrypted)
                return cryptState == CCCryptorStatus(kCCSuccess)
            })
        }) else {
            bufferBytes.deallocate()
            return nil
        }
        return Data(bytesNoCopy: bufferBytes, count: bytesDecrypted, deallocator: .free)
    }
}
