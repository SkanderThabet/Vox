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
            miniPlayerEpTitleLabel.text = episode.title
            
            playerEpisodeLabel.text = episode.title
            playerEpisodeAuthorLabel.text = episode.author ?? ""
            playEpisode()
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            playerImageView.sd_setImage(with: url)
            miniPlayerImageView.sd_setImage(with: url)
        }
    }
    let keyWindow = UIApplication
        .shared
        .connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }
    
    //MARK: - Outlets
    
    @IBOutlet weak var miniPlayerFastforwardBtn: UIButton! {
        didSet {
            miniPlayerFastforwardBtn.addTarget(self, action: #selector(handleForwardBtn), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniPlayerPauseBtn: UIButton! {
        didSet {
            miniPlayerPauseBtn.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    
    
    @IBOutlet weak var miniPlayerEpTitleLabel: UILabel!
    @IBOutlet weak var miniPlayerImageView: UIImageView!
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var maximizedStackPlayerView: UIStackView!
    @IBOutlet weak var playerMutedVolume: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var playerDismissBtn: UIButton!
    
    @IBOutlet weak var playerImageView: UIImageView! {
        didSet {
            playerImageView.layer.cornerRadius = 5
            playerImageView.clipsToBounds = true
            let scale:CGFloat = 0.7
            playerImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
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
    //MARK: - Handle Play & Pause Function
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayerPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            self.enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseBtn.setImage(UIImage(named: "play"), for: .normal)
            miniPlayerPauseBtn.setImage(UIImage(named: "play"), for: .normal)
            shrinkEpisodeImageView()
        }
    }
    
    //MARK: - Actions
    @IBAction func playerDismissActionBtn(_ sender: Any) {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController
        mainTabBarController?.minimizePlayerDetails()
        
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleBackwardBtn(_ sender: Any) {
        let fifteenSeconds = CMTimeMake(value: 15, timescale: 1)
        let seekTime = CMTimeSubtract(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    @IBAction func handleForwardBtn(_ sender: Any) {
        let fifteenSeconds = CMTimeMake(value: 15, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
        
    }
    
    
    //MARK: - enlarge Podcast episode imageview
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.playerImageView.transform = .identity
        }
        
    }
    //MARK: - shrink Podcast episode imageview
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            let scale:CGFloat = 0.7
            self.playerImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
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
    
    //MARK: - Observe Player Current Time Function
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durationTimeLabel.text = durationTime?.toDisplayString()
            self?.updateCurrentSlider()
        }
    }
    //MARK: - Update Current Slider Function
    fileprivate func updateCurrentSlider(){
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    //MARK: - Awake From Nib overriden function
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        observePlayerCurrentTime()
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("Episode started playing")
            self?.enlargeEpisodeImageView()
        }
        
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        if gesture.state == .began {
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            self.miniPlayerView.alpha = 1 + translation.y / 200
            self.maximizedStackPlayerView.alpha = -translation.y / 200
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.transform = .identity
                self.miniPlayerView.alpha = 1
                self.maximizedStackPlayerView.alpha = 0 
            }
        }
    }
    
    @objc func handleTapMaximize() {
        let mainBarTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController
        mainBarTabController?.maximizePlayerDetails(episode: nil)
        print("Tapping to maximize")
    }
    
   
    
    static func initFromNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
    }
    
    deinit {
        print("State of the player ...")
    }
    
    
    
}
