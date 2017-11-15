//
//  AppUtil.swift
//  Yo365
//
//  Created by Billy on 2/9/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class AppUtil {
    static func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
    static func getDateFromTimestamp(timestamp: Int) -> String  {
    
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    static var currentTimestamp: TimeInterval {
        return Date().timeIntervalSince1970
    }

    static func makeColorFromHex(_ colorString: String) -> UIColor{
        
        var chars = colorString.hasPrefix("#") ? Array(colorString.characters.dropFirst()) : Array(colorString.characters)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1
        switch chars.count {
        case 3:
            chars = [chars[0], chars[0], chars[1], chars[1], chars[2], chars[2]]
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            a = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            r = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            g = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            b = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            a = 0
        }
        return UIColor(red: r, green: g, blue:  b, alpha: a)
    }
}
