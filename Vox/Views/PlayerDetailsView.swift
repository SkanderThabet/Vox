//
//  PlayerDetailsView.swift
//  Vox
//
//  Created by Skander Thabet on 23/4/2022.
//

import UIKit
import AVKit

class PlayerDetailsView: UIView {
    
    var episode: Episode! {
        didSet{
            playerEpisodeLabel.text = episode.title
            playerEpisodeAuthorLabel.text = episode.author ?? ""
            playEpisode()
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            playerImageView.sd_setImage(with: url)
        }
    }
    
    //MARK: - Outlets

    @IBOutlet weak var playerDismissBtn: UIButton!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var playerEpisodeLabel: UILabel!
    @IBOutlet weak var playerEpisodeAuthorLabel: UILabel!
    @IBOutlet weak var backwardBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    
    
    @IBOutlet weak var playPauseBtn: UIButton! {
        didSet {
            playPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            playPauseBtn.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player.pause()
            playPauseBtn.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    
    
    //MARK: - Actions
    @IBAction func playerDismissActionBtn(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    //MARK: - Play episode Function
    
    fileprivate func playEpisode() {
        guard let url = URL(string: episode.streamURL!) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()

}
