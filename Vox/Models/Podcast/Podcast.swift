//
//  Podcast.swift
//  Vox
//
//  Created by Skander Thabet on 15/4/2022.
//

import Foundation

struct Podcast : Decodable {
    var trackName: String?
    var artistName : String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
}
