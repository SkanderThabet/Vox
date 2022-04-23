//
//  PodcastCell.swift
//  Vox
//
//  Created by Skander Thabet on 20/4/2022.
//

import UIKit

class PodcastCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var podcastTrackName: UILabel!
    @IBOutlet weak var podcastArtistName: UILabel!
    @IBOutlet weak var podcastEpisodeCount: UILabel!
    
    var podcast: Podcast! {
        didSet {
            podcastTrackName.text = podcast.trackName
            podcastArtistName.text = podcast.artistName
            
        }
    }
    
}
