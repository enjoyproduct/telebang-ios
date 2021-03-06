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
    static func getNewAccessCode(accountID: Int, type: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (String)-> Void) {
        let params: Parameters = [KEY_USER_ID: String(accountID), KEY_SUBSCRIPTION_TYPE: type]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_GET_NEW_ACCESS_CODE), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                successHandler(response.result.value!.content as! String)
            }
        }
    }

    static func updateSubscription(accountID: Int,card_number: String, paystack_auth_key: String, subscribed_date: Int, type: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping ()-> Void) {
        let params: Parameters = [KEY_USER_ID: String(accountID),KEY_PAYSTACK_AUTH_CODE: paystack_auth_key, KEY_SUBSCRIBED_DATE: String(subscribed_date), KEY_CARD_NUMBER: card_number, KEY_SUBSCRIPTION_TYPE: type]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_UPDATE_SUBSCRIPTION), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                successHandler()
            }
        }
    }
    static func getSubscriptions(accountID: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (Array<SubscriptionModel>)-> Void) {
        let params: Parameters = [KEY_USER_ID: String(accountID)]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_GET_SUBSCRIPTIONS), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let data: Array<Dictionary<String, AnyObject>>! = response.result.value!.content as! Array<Dictionary<String, AnyObject>>
                let subscriptionList: Array<SubscriptionModel>! = Mapper<SubscriptionModel>().mapArray(JSONArray: data)
                successHandler(subscriptionList)
                
            }
        }
    }
    static func getVideoSeries(url: String, errorHandler: @escaping (String) -> Void, successHandler: @escaping (Array<SeriesJSON>)-> Void) {
        Alamofire.request(getAbsoluteUrl(relativeUrl: url)).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                
                let data: Array<Dictionary<String, AnyObject>>! = response.result.value!.content as! Array<Dictionary<String, AnyObject>>
                let seriesList: Array<SeriesJSON>! = Mapper<SeriesJSON>().mapArray(JSONArray: data)
                successHandler(seriesList)
            }
        }
    }
    static func getListVideoBySeries(url: String, errorHandler: @escaping (String) -> Void, successHandler: @escaping (Array<VideoResponseJSON>)-> Void) {
        Alamofire.request(getAbsoluteUrl(relativeUrl: url)).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let data: Array<Dictionary<String, AnyObject>>! = response.result.value!.content as! Array<Dictionary<String, AnyObject>>
                let videoList: Array<VideoResponseJSON>! = Mapper<VideoResponseJSON>().mapArray(JSONArray: data)
                successHandler(videoList)
            }
        }
    }
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
    
    static func changePassword(accountID: Int, currentPassword: String, newPassword: String,  errorHandler: @escaping (String) -> Void, successHandler: @escaping ()-> Void) {
        let params: Parameters = [KEY_USER_ID: String(accountID), KEY_OLD_PASS: currentPassword, KEY_NEW_PASS: newPassword ]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_CHANGE_PASSWORD), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                successHandler()
            }
        }
    }
    
    static func changeProfile(params: Parameters,  errorHandler: @escaping (String) -> Void, successHandler: @escaping (CustomerResponse)-> Void) {
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_CHANGE_PROFILE), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
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
    
    static func getListVideoByCategory(catID: Int, pageNumber: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (Array<VideoResponseJSON>)-> Void) {
        let relativeUrl = String.init(format: RELATIVE_URL_GET_VIDEOS_BY_CATEGORY, catID, pageNumber, LIMIT_VIDEOS_SEARCH)
        Alamofire.request(getAbsoluteUrl(relativeUrl: relativeUrl)).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let data: Array<Dictionary<String, AnyObject>>! = response.result.value!.content as! Array<Dictionary<String, AnyObject>>
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
    
    static func getVideosByID(videoID: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (VideoResponseJSON)-> Void) {
        let relativeUrl = String.init(format: RELATIVE_URL_GET_VIDEO_BY_ID, videoID)
        Alamofire.request(getAbsoluteUrl(relativeUrl: relativeUrl)).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content: Dictionary<String, AnyObject>? = response.result.value?.content as! Dictionary<String, AnyObject>?
                let data = VideoResponseJSON(JSON: content!)
                successHandler(data!)
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
    
    static func updateVideosCounter(field: String, videoID: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping ()-> Void) {
        let params: Parameters = [KEY_FIELD: field, KEY_VIDEO_ID: videoID]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_UPDATE_VIDEO_COUNTER), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                successHandler()
            }
        }
    }
    
    static func updateUserLikeVideo(customerID: Int, videoID: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (LikeStatusResponse)-> Void) {
        let params: Parameters = [KEY_CUSTOMER_ID: customerID, KEY_VIDEO_ID: videoID]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_USER_LIKE_VIDEO), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content: Dictionary<String, AnyObject>? = response.result.value?.content as! Dictionary<String, AnyObject>?
                let data = LikeStatusResponse(JSON: content!)
                successHandler(data!)
            }
        }
    }
    
    static func getLikeVideoStatus(customerID: Int, videoID: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (LikeStatusResponse)-> Void) {
        let relativeUrl = String.init(format: RELATIVE_URL_GET_USER_LIKE_STATUS, videoID, customerID)
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: relativeUrl)).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content: Dictionary<String, AnyObject>? = response.result.value?.content as! Dictionary<String, AnyObject>?
                let data = LikeStatusResponse(JSON: content!)
                successHandler(data!)
            }
        }
    }
    
    
    static func getVideoComments(videoID: Int, pageNumber: Int, errorHandler: @escaping (String) -> Void, successHandler: @escaping (Array<CommentJSON>)-> Void) {
        let relativeUrl = String.init(format: RELATIVE_URL_GET_VIDEO_COMMENTS,videoID, pageNumber, LIMIT_COMMENTS_VIDEO)
        Alamofire.request(getAbsoluteUrl(relativeUrl: relativeUrl)).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let data: Array<Dictionary<String, AnyObject>>! = response.result.value!.content as! Array<Dictionary<String, AnyObject>>
                let listComments: Array<CommentJSON>! = Mapper<CommentJSON>().mapArray(JSONArray: data)
                successHandler(listComments)
            }
        }
    }
    
    static func postCommentVideo(customerID: Int, videoID: Int,commentContent: String, errorHandler: @escaping (String) -> Void, successHandler: @escaping (CommentJSON)-> Void) {
        
        let params: Parameters = [KEY_CUSTOMER_ID: customerID, KEY_VIDEO_ID: videoID, KEY_COMMENT_CONTENT: commentContent]
        
        Alamofire.request(getAbsoluteUrl(relativeUrl: RELATIVE_URL_INSERT_COMMENT), method: .post ,parameters: params).responseObject { (response: DataResponse<ResponseModel>) in
            
            let result = parseResponse(data: response, errorHandler: errorHandler)
            if(result){
                let content: Dictionary<String, AnyObject>? = response.result.value?.content as! Dictionary<String, AnyObject>?
                let data = CommentJSON(JSON: content!)

                successHandler(data!)
            }
        }
    }
    
    static func changeAvatar(customerID: Int, image: UIImage, errorHandler: @escaping (String?) -> Void, successHandler: @escaping (CustomerResponse?)-> Void, processHandler: @escaping (Int)-> Void) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(image, 1)!, withName: KEY_AVATAR,fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(String(customerID).data(using: String.Encoding.utf8)!, withName: KEY_USER_ID)
        }, to: getAbsoluteUrl(relativeUrl: RELATIVE_URL_CHANGE_AVATAR)) { (result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    let percen: Int = Int.init(progress.fractionCompleted * 100)
                    processHandler(percen)
                })
                
                upload.responseString(completionHandler: { (response: DataResponse<String>) in
                    let responseModel = ResponseModel(JSONString: response.value!)
                    if ((responseModel?.code!)! > 0)  {
                        let content: Dictionary<String, AnyObject>? = responseModel?.content as! Dictionary<String, AnyObject>?
                        let data = CustomerResponse(JSON: content!)

                        successHandler(data!)
                    }else{
                        errorHandler(responseModel?.message!)
                    }
                })
                
            case .failure(let error):
                errorHandler(error.localizedDescription)
                break
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
            errorHandler(error.localizedDescription)
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
