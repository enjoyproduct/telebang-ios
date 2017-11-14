//
//  SlideMenuModel.swift
//  Yo365
//
//  Created by Billy on 2/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//
import Foundation

struct SlideMenuElement {
    enum MenuType: String {
        case Home, Categories, Series, Favourite, Download, News, Upload, AboutUs, Terms, Feedback, Help, Share, SubscriptionHistory
    }
    
    let icon: String
    let title: String
    let type: MenuType
    let enable: Bool
}

extension SlideMenuElement {
    enum ErrorType: Error {
        case noPlistFile
        case cannotReadFile
    }
    
    /// Load all the elements from the plist file
    static func loadFromPlist() throws -> [SlideMenuElement] {
        // First we need to find the plist
        
        guard let file = Bundle.main.path(forResource: "SlideMenuElements", ofType: "plist") else {
            throw ErrorType.noPlistFile
        }
        
        // Then we read it as an array of dict
        guard let array = NSArray(contentsOfFile: file) as? [[String: AnyObject]] else {
            throw ErrorType.cannotReadFile
        }
        
        // Initialize the array
        var elements: [SlideMenuElement] = []
        
        // For each dictionary
        for dict in array {
            // We implement the element
            let element = SlideMenuElement.from(dict: dict)
            // And add it to the array
            if(element.enable){
                elements.append(element)
            }
        }
        
        // Return all elements
        return elements
    }
    
    /// Create an element corresponding to the given dict
    static func from(dict: [String: AnyObject]) -> SlideMenuElement {
        let icon = dict["icon"] as! String
        let title = dict["title"] as! String
        let type = MenuType(rawValue: dict["type"] as! String)!
        let enable = dict["enable"] as! Bool
        
        return SlideMenuElement(icon: icon,
                       title: title,
                       type: type,
                       enable: enable)
    }
}
