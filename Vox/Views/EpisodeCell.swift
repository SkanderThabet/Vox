//
//  EpisodeCell.swift
//  Vox
//
//  Created by Skander Thabet on 23/4/2022.
//

import UIKit

class EpisodeCell: UITableViewCell {

    var episode : Episode! {
        didSet {
            episodeTitleLabel.text = episode.title
            episodeDescriptionLabel.text = episode.description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, YYYY"
            episodePubDateLabel.text = dateFormatter.string(from: episode.pubDate)
        }
    }
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodePubDateLabel: UILabel!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
