//
//  PlayerDetailsView.swift
//  Vox
//
//  Created by Skander Thabet on 23/4/2022.
//

import UIKit

class PlayerDetailsView: UIView {
    
    var episode: Episode! {
        didSet{
            playerEpisodeLabel.text = episode.title
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            playerImageView.sd_setImage(with: url)
        }
    }
    
    //MARK: - Outlets

    @IBOutlet weak var playerDismissBtn: UIButton!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var playerEpisodeLabel: UILabel!
    
    //MARK: - Actions
    @IBAction func playerDismissActionBtn(_ sender: Any) {
        self.removeFromSuperview()
    }
    

}
