//
//  SearchResponse.swift
//  ImgurProject
//
//  Created by Fedii Ihor on 12.07.2022.
//

import Foundation
struct SearchResponse: Codable {
    let status: Int?
    let success: Bool?
    let data: [ImageItem]
}

struct ImageItem: Codable {
    let title: String?
    let type: String?
    let section: String?
    let animated: Bool?
    let width: Int?
    let height: Int?
    let link: String?
    
    func titleText() -> String {
        if width != nil , height != nil {
            return ""
        } else {
            return title ?? ""
        }
    }
}
/*
 {"id":"WS2LFCw",
 "title":"What are you pointing at human.",
 "description":null,
 "datetime":1417124899,
 "type":"image\/jpeg",
 "animated":false,
 "width":720,
 "height":609,
 "size":181509,
 "views":8444,
 "bandwidth":1532661996,
 "vote":null,
 "favorite":false,
 "nsfw":false,
 "section":"funny",
 "account_url":null,
 "account_id":null,
 "is_ad":false,
 "in_most_viral":true,
 "has_sound":false,
 "tags":[{
 "name":"cat",
 "display_name":"cat",
 "followers":2073831,
 "total_items":275356,
 "following":false,
 "is_whitelisted":false,
 "background_hash":"xeEIpAn",
 "thumbnail_hash":null,
 "accent":"159559",
 "background_is_animated":false,
 "thumbnail_is_animated":false,
 "is_promoted":false,
 "description":"feline friends",
 "logo_hash":null,
 "logo_destination_url":null,
 "description_annotations":{}},
 {"name":"cats",
 "display_name":"cats",
 "followers":211599,
 "total_items":128059,
 "following":false,
 "is_whitelisted":false,
 "background_hash":"xeEIpAn",
 "thumbnail_hash":null,"accent":"BF63A7",
 "background_is_animated":false,
 "thumbnail_is_animated":false,
 "is_promoted":false,
 "description":"Our feline friends",
 "logo_hash":null,
 "logo_destination_url":null,
 "description_annotations":{}
 }],
 "ad_type":0,
 "ad_url":"",
 "edited":0,
 "in_gallery":true,
 "topic":null,
 "topic_id":0,
 "link":"https:\/\/i.imgur.com\/WS2LFCw.jpg",
 "ad_config":{"safeFlags":["in_gallery"],
 "highRiskFlags":[],
 "unsafeFlags":["sixth_mod_unsafe"],
 "wallUnsafeFlags":[],
 "showsAds":false,
 "showAdLevel":1},
 "comment_count":235,
 "favorite_count":2254,
 "ups":8336,"downs":190,
 "points":8146,
 "score":9199,
 "is_album":false
 
 }
 */
