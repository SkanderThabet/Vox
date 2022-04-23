//
//  RSSFeed.swift
//  Vox
//
//  Created by Skander Thabet on 23/4/2022.
//

import FeedKit
extension RSSFeed {
    func toEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Episode]()
        items?.forEach({ (feedItem) in
            var episode = Episode(feedItem: feedItem)
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl

            }
            episodes.append(episode)
        })
        return episodes
}
    

}
