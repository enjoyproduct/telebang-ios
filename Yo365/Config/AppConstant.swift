//
//  AppConstant.swift
//  Yo365
//
//  Created by Billy on 1/19/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Foundation

enum EnvironmentType {
    case DEVELOPMENT
    case STAGING
    case PRODUCTION
}

enum VideoCounterField: String {
    case view, share
}

let RELATIVE_URL_LOGIN = "/api/login"
let RELATIVE_URL_REGISTER = "/api/register"
let RELATIVE_URL_FORGOT_PASSWORD = "/api/forgot_password"
let RELATIVE_URL_LOGIN_FACE_BOOK = "/api/loginFacebook"
let RELATIVE_URL_VIDEO_CATEGORIES = "/api/categories"
let RELATIVE_URL_VIDEO_LATEST = "/api/getListVideoLasted/%d/%d"
let RELATIVE_URL_VIDEO_MOST = "/api/getListVideoMostView/%d/%d"
let RELATIVE_URL_VIDEO_TRENDING = "/api/getListVideoTrending/%d/%d"
let RELATIVE_URL_SEARCH_BY_KEYWORD = "/api/getListVideoByKeyword"
let RELATIVE_URL_GET_VIDEOS_BY_CATEGORY = "/api/getListVideoByCategory/%d/%d/%d";
let RELATIVE_URL_GET_VIDEO_BY_ID = "/api/getVideoById/%d";

let RELATIVE_URL_UPDATE_VIDEO_COUNTER = "api/updateStatistics"
let RELATIVE_URL_PLAY_VIMEO = "%@?player_id=player&autoplay=1&title=0&byline=0&portrait=0&api=1&maxheight=480&maxwidth=800"
let RELATIVE_URL_PLAY_FACEBOOK = "/api/playFacebookVideo?video_url=%@"
let RELATIVE_URL_USER_LIKE_VIDEO = "/api/likevideo"
let RELATIVE_URL_GET_USER_LIKE_STATUS = "/api/getLikeVideoStatus/%d/%d"
let RELATIVE_URL_GET_VIDEO_COMMENTS = "/api/getListCommentVideo/%d/%d/%d"
let RELATIVE_URL_INSERT_COMMENT = "/api/insertCommentVideo"
let RELATIVE_URL_CHANGE_PASSWORD = "/api/change_password"
let RELATIVE_URL_CHANGE_PROFILE = "/api/change_profile"
let RELATIVE_URL_CHANGE_AVATAR = "api/change_avatar"

let LIMIT_VIDEOS_HOMES = 10;
let LIMIT_VIDEOS_SEARCH = 10;
let LIMIT_COMMENTS_VIDEO = 20;

let KEY_USERNAME = "username"
let KEY_PASSWORD = "password"
let KEY_EMAIL = "email"
let KEY_ACCESS_TOKEN = "access-token"
let KEY_KEYWORD = "keyword"
let KEY_LIMIT = "limit";
let KEY_PAGE_NUMBER = "page"
let KEY_VIDEO_ID = "video_id"
let KEY_FIELD = "field"
let KEY_CUSTOMER_ID = "customer_id"
let KEY_COMMENT_CONTENT = "comment_text"
let KEY_OLD_PASS = "old_password"
let KEY_NEW_PASS = "new_password"
let KEY_USER_ID = "user_id"
let KEY_FIRST_NAME = "firstname"
let KEY_LAST_NAME = "lastname"
let KEY_PHONE_NUMBER = "phonenumber"
let KEY_AVATAR = "avatar"
