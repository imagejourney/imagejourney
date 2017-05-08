//
//  Constants.swift
//  imagejourney
//
//  Created by James Man on 5/3/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let USER_DEFAULTS_KEY = "currentUserData"
    
    static let GOOGLE_MAP_KEY = "AIzaSyDb0cvH3v2mQVZ4DPM6GG241NckHC5Owac"
    
    static let SIGNUP_MARGIN:CGFloat = 20
    static let SIGNUP_FIELD_OFFSET:CGFloat = 35
    static let LOGIN_FIELD_MARGIN:CGFloat = 20
    static let LOGIN_EMAIL_FIELD_OFFSET:CGFloat = 50
    
    static let LOGIN_LOADING_MSG = "Logging in..."
    static let PASSWORD_NOT_MATCH_MSG = "password does not match."
    static let SIGN_UP_LOADING_MSG = "Signing up..."
    static let EMPTY_NAME_ERROR_MSG = "Name is required!"
    
    // Side menu configs
    static let MENU_WIDTH:CGFloat = 200
    
    enum MENU_STATE:String {
        case home_feed = "home"
        case profile = "profile"
        case search = "search"
        case most_recent_journal = "recent_journal"
        case friends = "friends"
    }
}
