//
//  VideoCategoryResponseObject.swift
//  Yo365
//
//  Created by Billy on 2/6/17.
//  Copyright © 2017 Billy. All rights reserved.
//
import ObjectMapper
class VideoCategoryResponseJSON: Mappable {
    var topCategories: Array<Int>?
    var allcategories: Array<VideoCategoryJSON>?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        topCategories           <- map["top_category"]
        allcategories           <- map["all_category"]
    }
}

class VideoCategoryJSON: Mappable {
    var id: Int?
    var thumbnail: String?
    var icon: String?
    var name: String?
    var enable: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id                  <- map["url"]
        thumbnail           <- map["image"]
        icon                <- map["icon"]
        name                <- map["name"]
        enable              <- map["enable"]
    }
}
