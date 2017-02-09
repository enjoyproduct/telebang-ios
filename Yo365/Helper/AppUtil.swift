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
    

}
