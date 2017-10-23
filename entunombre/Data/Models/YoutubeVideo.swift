//
//  YoutubeVideo.swift
//  entunombre
//
//  Created by Eury Perez on 10/17/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class YoutubeVideoDB: Object {
    @objc dynamic var videoId:String = ""
    @objc dynamic var title:String = ""
    @objc dynamic var desc:String = ""
    @objc dynamic var pictureUrl:String = ""
    
    override public static func primaryKey() -> String? {
        return "videoId"
    }
}

struct YoutubeVideo: Mappable {
    var id:YoutubeVideoId?
    var snippet:YoutubeVideoSnippet?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        snippet <- map["snippet"]
    }
}

struct YoutubeVideoResponse:Mappable {
    var items:[YoutubeVideo]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        items <- map["items"]
    }
}

struct YoutubeVideoId: Mappable {
    var kind:String?
    var videoId:String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        kind <- map["kind"]
        videoId <- map["videoId"]
    }
}

struct YoutubeVideoSnippet: Mappable {
    var title:String?
    var description:String?
    var thumbnails:YoutubeVideoThumbnails?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        thumbnails <- map["thumbnails"]
    }
    
}

struct YoutubeVideoThumbnails: Mappable {
    var thumbnail:YoutubeVideoThumbnail?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        thumbnail <- map["default"]
    }
}

struct YoutubeVideoThumbnail: Mappable {
    var url:String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        url <- map["url"]
    }
}
