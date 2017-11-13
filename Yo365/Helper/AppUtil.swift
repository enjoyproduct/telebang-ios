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

}
