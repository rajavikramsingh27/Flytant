//
//  Encryption.swift
//  Flytant
//
//  Created by Vivek Rai on 16/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import RNCryptor

class Encryption {
    
//    class func encryptText(chatRoomId: String, message: String) -> String{
//        guard let data = message.data(using: String.Encoding.utf8) else {return ""}
//        let encryptedData = RNCryptor.encrypt(data: data, withPassword: chatRoomId)
//        return encryptedData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//    }
//
//    class func decryptText(chatRoomId: String, encryptedMessage: String) -> String{
//        let decryptor = RNCryptor.Decryptor(password: chatRoomId)
//        let encryptedData = NSData(base64Encoded: encryptedMessage, options: NSData.Base64DecodingOptions(rawValue: 0))
//        var message: NSString = ""
//        if encryptedData != nil {
//            do {
//                let decryptedData = try decryptor.decrypt(data: encryptedData! as Data)
//                message = NSString(data: decryptedData, encoding: String.Encoding.utf8.rawValue)!
//            } catch {
//                print("error decrypting text \(error.localizedDescription)")
//            }
//        }
//        return message as String
//    }
    
}
