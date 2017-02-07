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

let RELATIVE_URL_LOGIN = "/api/login"
let RELATIVE_URL_REGISTER = "/api/register"
let RELATIVE_URL_FORGOT_PASSWORD = "/api/forgot_password"
let RELATIVE_URL_LOGIN_FACE_BOOK = "/api/loginFacebook"
let RELATIVE_URL_VIDEO_CATEGORIES = "/api/categories"
let RELATIVE_URL_VIDEO_LATEST = "/api/getListVideoLasted/%d/%d";
let RELATIVE_URL_VIDEO_TRENDING = "/api/getListVideoTrending/%d/%d";

let RELATIVE_URL_PLAY_VIMEO = "%@?player_id=player&autoplay=1&title=0&byline=0&portrait=0&api=1&maxheight=480&maxwidth=800";
let RELATIVE_URL_PLAY_FACEBOOK = "/api/playFacebookVideo?video_url=%@";

let LIMIT_VIDEOS_HOMES = 10;

let KEY_USERNAME = "username"
let KEY_PASSWORD = "password"
let KEY_EMAIL = "email"
let KEY_ACCESS_TOKEN = "access-token"
