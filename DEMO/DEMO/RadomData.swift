//
//  RadomData.swift
//  DEMO
//
//  Created by Songwen Ding on 9/13/16.
//  Copyright © 2016 DingSoung. All rights reserved.
//

import UIKit


public class RadomData:NSObject {
    open class func uInt(_ max:UInt32) -> UInt32 {
        return arc4random_uniform(max)
    }
    open class func string(_ length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: length)
        for _ in 0..<length {
            let len = UInt32 (letters.length)
            let rand = arc4random_uniform(len)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString as String
    }
    
    open static let colorHexs = [0x71B0DA,0xF88D48,0xEB4B5C,0x76797C,0x395DD5,0xFEC163,0x72AFD9,0x9BD0FE,0x6738D5,0xA139D5,0xF35352,0xCE62D6,0x5182E4,0xEF4C4C,0x3FB27E,0xB7D62D,0x5156B8,0xFF8549,0xD42D6B,0x69D4DB,0x51B4F1,0xF7CB4A,0xFE855A,0x9BCC66,0x40A376,0x8954D4,0x3886D4]
    
    open static var color:UIColor {
        get {
            let index = Int(RadomData.uInt(UInt32(RadomData.colorHexs.count)))
            let color = UIColor(hex6: colorHexs[index])
            return color
        }
    }
    
    
    
    
}
