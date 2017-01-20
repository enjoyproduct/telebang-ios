//
//  RPC.swift
//  Yo365
//
//  Created by Billy on 1/19/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class ApiClient {
    static func login(username: String,password: String, errorHandler: @escaping (String) -> Void, successHandler: @escaping (CustomerResponse)-> Void) {
        let params: Parameters = [KEY_USERNAME: username,KEY_PASSWORD: password  ]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_LOGIN), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in

            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content = response.result.value?.content
                let data = CustomerResponse(JSON: content!)
                successHandler(data!)
            }
        }
    }
    
    static func register(username: String, email: String, password: String, errorHandler: @escaping (String) -> Void, successHandler: @escaping (CustomerResponse)-> Void) {
        let params: Parameters = [KEY_USERNAME: username, KEY_EMAIL: email, KEY_PASSWORD: password ]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_REGISTER), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content = response.result.value?.content
                let data = CustomerResponse(JSON: content!)
                successHandler(data!)
            }
        }
    }
    
    static func forgotPassword(email: String, errorHandler: @escaping (String) -> Void, successHandler: @escaping (String)-> Void) {
        let params: Parameters = [KEY_EMAIL: email]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_FORGOT_PASSWORD), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                successHandler("An email will be sent to you with reset password link")
            }
        }
    }
    
    private static func parseResponse(data: DataResponse<ResponseModel>, errorHandler: @escaping (String) -> Void)-> Bool{
        debugPrint(data)
        
        switch(data.result){
        case .success(let value):
            print(value.toJSONString() ?? "")
            
            if (value.code! > 0)  {
                return true
            }else{
                errorHandler(value.message!)
            }
            
            break
            
        case .failure(let error):
            errorHandler(error as! String)
            break
        }
        
        return false
    }
    
    private static func getAbsoluteUrl(relativeUrl: String) -> String {
        var url: String = BASE_URL
        url += relativeUrl
        return url
    }
    
}

protocol APIProtocol {
    func onSuccess(results: Any)
    func onError(message: String)
}
