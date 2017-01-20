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

let KEY_USERNAME = "username"
let KEY_PASSWORD = "password"
let KEY_EMAIL = "email"
let KEY_ACCESS_TOKEN = "access-token"
