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
    static let LOGIN_EMAIL_FIELD_OFFSET:CGFloat = 10
    
    static let LOGIN_LOADING_MSG = "Logging in..."
    static let HOMEFEED_FETCHING_MSG = "Loading journals..."
    static let PROFILE_LOADING_MSG = "Loading profile.."
    static let PASSWORD_NOT_MATCH_MSG = "password does not match."
    static let SAVING_JOURNAL_ENTRY_MSG = "Saving your journal entry.."
    static let SIGN_UP_LOADING_MSG = "Signing up..."
    static let SEARCHING_MSG = "Searching for journals..."
    static let EMPTY_NAME_ERROR_MSG = "Name is required!"
    
    // Side menu configs
    static let MENU_WIDTH:CGFloat = 250
    
    enum MENU_STATE:String {
        case home_feed = "home"
        case profile = "profile"
        case search = "search"
        case most_recent_journal = "recent_journal"
        case friends = "friends"
    }
    
    static let THEME_COLOR = Helper.UIColorFromHex(rgbValue: 0x2196f3, alpha: 1.0)
    static let THEME_COLOR_TWO = Helper.UIColorFromHex(rgbValue: 0xf9f9f9, alpha: 1.0)
    static let LIGHT_GRAY = Helper.UIColorFromHex(rgbValue: 0xeeeeee, alpha: 1.0)
    static let DARK_GRAY = Helper.UIColorFromHex(rgbValue: 0x484848, alpha: 1.0)
    
    static let MAPLINE_BLUE = Helper.UIColorFromHex(rgbValue: 0x29b6f6, alpha: 1.0)
    static let MAPLINE_GREEN = Helper.UIColorFromHex(rgbValue: 0x81c784, alpha: 1.0)
    
    
    static let BG_GRADIENT_BLUE = Helper.UIColorFromHex(rgbValue: 0x81d4fa, alpha: 1.0)
    static let BG_GRADIENT_GREEN = Helper.UIColorFromHex(rgbValue: 0xa5d6a7, alpha: 1.0)
}
