//
//  Episode.swift
//  Vox
//
//  Created by Skander Thabet on 23/4/2022.
//

import Foundation
import FeedKit

struct Episode: Decodable {
    internal init(feedItem : RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
    
    var title: String?
    var pubDate : Date
    var description : String?
    var imageUrl: String?
}
