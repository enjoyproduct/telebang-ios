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
                let content: Dictionary<String, AnyObject>? = response.result.value?.content as! Dictionary<String, AnyObject>?
                let data = CustomerResponse(JSON: content!)
                successHandler(data!)
            }
        }
    }
    
    static func signInWithFacebook(accessToken: String, errorHandler: @escaping (String) -> Void, successHandler: @escaping (CustomerResponse)-> Void) {
        let params: Parameters = [KEY_ACCESS_TOKEN: accessToken]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_LOGIN_FACE_BOOK), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content: Dictionary<String, AnyObject>? = response.result.value?.content as! Dictionary<String, AnyObject>?
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
                let content: Dictionary<String, AnyObject>? = response.result.value?.content as! Dictionary<String, AnyObject>?
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
    
    static func getVideoCategories(errorHandler: @escaping (String) -> Void, successHandler: @escaping (VideoCategoryResponseJSON)-> Void) {
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_VIDEO_CATEGORIES)).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content: Dictionary<String, AnyObject>? = response.result.value?.content as! Dictionary<String, AnyObject>?
                let data = VideoCategoryResponseJSON(JSON: content!)!
                successHandler(data)
            }
        }
    }
    
    static func getVideosLatest(pageNumber: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (Array<VideoResponseJSON>)-> Void) {
        let relativeUrl = String.init(format: RELATIVE_URL_VIDEO_LATEST, pageNumber, LIMIT_VIDEOS_HOMES)
        Alamofire.request(getAbsoluteUrl(relativeUrl: relativeUrl)).responseObject { (response: DataResponse<ResponseModel>) in

            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content: Dictionary<String, AnyObject>! = response.result.value?.content as! Dictionary<String, AnyObject>!
                let data: Array<Dictionary<String, AnyObject>>! = content?["videos"] as! Array<Dictionary<String, AnyObject>>
                let videoList: Array<VideoResponseJSON>! = Mapper<VideoResponseJSON>().mapArray(JSONArray: data)
                successHandler(videoList)
            }
        }
    }
    
    static func getVideosMostView(pageNumber: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (Array<VideoResponseJSON>)-> Void) {
        let relativeUrl = String.init(format: RELATIVE_URL_VIDEO_MOST, pageNumber, LIMIT_VIDEOS_HOMES)
        Alamofire.request(getAbsoluteUrl(relativeUrl: relativeUrl)).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content: Dictionary<String, AnyObject>! = response.result.value?.content as! Dictionary<String, AnyObject>!
                let data: Array<Dictionary<String, AnyObject>>! = content?["videos"] as! Array<Dictionary<String, AnyObject>>
                let videoList: Array<VideoResponseJSON>! = Mapper<VideoResponseJSON>().mapArray(JSONArray: data)
                successHandler(videoList)
            }
        }
    }
    
    static func getVideosTrending(pageNumber: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (Array<VideoResponseJSON>)-> Void) {
        let relativeUrl = String.init(format: RELATIVE_URL_VIDEO_TRENDING, pageNumber, LIMIT_VIDEOS_HOMES)
        Alamofire.request(getAbsoluteUrl(relativeUrl: relativeUrl)).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let data: Array<Dictionary<String, AnyObject>>! = response.result.value!.content as! Array<Dictionary<String, AnyObject>>
                let videoList: Array<VideoResponseJSON>! = Mapper<VideoResponseJSON>().mapArray(JSONArray: data)
                successHandler(videoList)
            }
        }
    }
    
    static func getVideosBeyKeyword(keyword: String, pageNumber: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (Array<VideoResponseJSON>)-> Void) {
        let params: Parameters = [KEY_KEYWORD: keyword, KEY_PAGE_NUMBER: pageNumber, KEY_LIMIT: LIMIT_VIDEOS_SEARCH ]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_SEARCH_BY_KEYWORD), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let data: Array<Dictionary<String, AnyObject>>! = response.result.value!.content as! Array<Dictionary<String, AnyObject>>
                let videoList: Array<VideoResponseJSON>! = Mapper<VideoResponseJSON>().mapArray(JSONArray: data)
                successHandler(videoList)
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
