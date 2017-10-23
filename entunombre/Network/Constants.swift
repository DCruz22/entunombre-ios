//
//  Constants.swift
//  entunombre
//
//  Created by Eury Perez on 10/17/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import Foundation

struct Constants {
    
    static let YOUTUBE_URL = "https://www.googleapis.com/youtube/v3/search"
    static let YOUTUBE_CHANNEL = "UCriJCGxbUjx4KC9FTqReCAA"
    static let YOUTUBE_API_KEY = "AIzaSyA404e1DIu9hbS1xB-cH-WcpCfLx6vRzrk"
    static let YOUTUBE_MAX_RESULTS = 25
    static let YOUTUBE_PART = "id,snippet"
    static let YOUTUBE_TYPE = "video"
    static let YOUTUBE_FIELDS = "items(id/kind,id/videoId,snippet/title,snippet/thumbnails/default/url,snippet/description)"
    
    struct Urls {
        static let YOUTUBE_SEARCH_VIDEOS = "\(Constants.YOUTUBE_URL)?channelId=\(Constants.YOUTUBE_CHANNEL)&fields=\(Constants.YOUTUBE_FIELDS)&key=\(Constants.YOUTUBE_API_KEY)&maxResults=\(Constants.YOUTUBE_MAX_RESULTS)&part=\(Constants.YOUTUBE_PART)&q&type=\(Constants.YOUTUBE_TYPE)"
    }
}
