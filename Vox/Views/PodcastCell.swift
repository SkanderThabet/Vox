//
//  PodcastCell.swift
//  Vox
//
//  Created by Skander Thabet on 20/4/2022.
//

import UIKit
import SDWebImage

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
            podcastEpisodeCount.text = "\(podcast.trackCount ?? 0) Episodes"
            print("Loading images with url : ", podcast.artworkUrl600 ?? "")
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
//            URLSession.shared.dataTask(with: url) { data, _, _ in
//                print("Finished downloading image data :  ",data)
//                guard let data = data else { return }
//
//                DispatchQueue.main.async {
//                    self.podcastImage.image = UIImage(data: data)
//
//                }
//            }.resume()
            
            podcastImage.sd_setImage(with: url, completed: nil)
        }
    }
    
}
