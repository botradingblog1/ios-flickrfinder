//
//  Constants.swift
//  com.justmobiledev.mobile.ios.flickrsearch
//
//  Created by Christian Scheid on 11/17/17.
//  Copyright © 2017 Christian Scheid. All rights reserved.
//

import Foundation

struct Constants {
    
    struct FlickrURLParams {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
    }
    
    struct FlickrAPIKeys {
        static let SearchMethod = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let ResponseFormat = "format"
        static let DisableJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
    }
    
    struct FlickrAPIValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "6018ce76bba90c3eff10d2f95093f634"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let MediumURL = "url_m"
        static let SafeSearch = "1"
    }

}
