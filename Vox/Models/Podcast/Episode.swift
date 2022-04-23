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
        self.description = feedItem.description ?? ""
    }
    
    var title: String?
    var pubDate : Date
    var description : String?
}
