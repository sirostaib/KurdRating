//
//  YouTubeSearchResponse.swift
//  KurdRating
//
//  Created by Siros Taib on 3/28/24.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
