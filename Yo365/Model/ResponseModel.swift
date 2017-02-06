//
//  ResponseModel.swift
//  Yo365
//
//  Created by Billy on 1/19/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import ObjectMapper

class ResponseModel: Mappable {
    var code: Int?
    var message: String?
    //var content: Dictionary<String, AnyObject>?
    var content: Any?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code              <- map["code"]
        message           <- map["message"]
        content           <- map["content"]
    }
}
