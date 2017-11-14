//
//  SeriesModel.swift
//  teleBang
//
//  Created by Admin on 11/14/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import ObjectMapper
class SeriesModel: Mappable {
    var id: Int?
    var thumbnail: String?
    var title: String?
    var shortDescription: String?
    var completed: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        thumbnail           <- map["thumbnail"]
        title               <- map["title"]
        shortDescription    <- map["short_description"]
        completed           <- map["completed"]
    }

}
