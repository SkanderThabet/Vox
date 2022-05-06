//
//  PlayerDetailsView.swift
//  Vox
//
//  Created by Skander Thabet on 23/4/2022.
//

import UIKit
import AVKit
import MediaPlayer

class PlayerDetailsView: UIView {
    
    var episode: Episode! {
        didSet{
            miniPlayerEpTitleLabel.text = episode.title
            
            playerEpisodeLabel.text = episode.title
            playerEpisodeAuthorLabel.text = episode.author ?? ""
            
            
            setupNowPlayingInfo()
            setupAudioSession()
            playEpisode()
            
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            playerImageView.sd_setImage(with: url)
            miniPlayerImageView.sd_setImage(with: url)
//            miniPlayerImageView.sd_setImage(with: url) { image, _, _, _ in
//                let image = self.playerImageView.image ?? UIImage()
//                let artwork = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
//                    return image
//                })
//                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
//            }
        }
    }
    
    fileprivate func setupNowPlayingInfo() {
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyArtwork] = episode.imageUrl
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        guard let url = URL(string: episode.imageUrl ?? "") else { return }
        miniPlayerImageView.sd_setImage(with: url) { image, _, _, _ in
            guard let image = image else { return }

            let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
                return image
            })
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
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
    
    @IBOutlet weak var homepageRectangleImg: UIImageView!
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
            self.setupElapsedTime(playBackRate: 1)
        } else {
            player.pause()
            playPauseBtn.setImage(UIImage(named: "play"), for: .normal)
            miniPlayerPauseBtn.setImage(UIImage(named: "play"), for: .normal)
            shrinkEpisodeImageView()
            self.setupElapsedTime(playBackRate: 0)
        }
    }
    
    //MARK: - Actions
    @IBAction func playerDismissActionBtn(_ sender: Any) {
        UIApplication.mainTabBarController()?.minimizePlayerDetails()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
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
            self?.setupLockScreenCurrentTime()
            self?.updateCurrentSlider()
        }
    }
    
    fileprivate func setupLockScreenCurrentTime() {
        var nowPlayingInfo = [String: Any]()
//        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        guard let currentItem = player.currentItem else { return }
        let durationInSeconds = CMTimeGetSeconds(currentItem.duration)
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    //MARK: - Update Current Slider Function
    fileprivate func updateCurrentSlider(){
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    var panGesture : UIPanGestureRecognizer!
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: self.superview)
            maximizedStackPlayerView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: self.superview)
            let velocity = gesture.velocity(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.maximizedStackPlayerView.transform = .identity
                
                if translation.y > 50 || velocity.y > 500 {
                    UIApplication.mainTabBarController()?.minimizePlayerDetails()
                }
            }

        }
    }
    
    fileprivate func setupGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        miniPlayerView.addGestureRecognizer(panGesture)
        maximizedStackPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let errSession {
            print("Failed to activate Session : ",errSession)
           
        }
    }
    
    fileprivate func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) in
            print("Should play the podcast")
            self.player.play()
            self.playPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            self.miniPlayerPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            self.setupElapsedTime(playBackRate: 1)
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) in
            print("Should pause the podcast")
            self.player.pause()
            self.playPauseBtn.setImage(UIImage(named: "play"), for: .normal)
            self.miniPlayerPauseBtn.setImage(UIImage(named: "play"), for: .normal)
            self.setupElapsedTime(playBackRate: 0)
            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) in
            self.handlePlayPause()
            return .success
        }
        
    }
    
    fileprivate func setupElapsedTime(playBackRate: Float) {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = playBackRate
    }
    //MARK: - Awake From Nib overriden function
    fileprivate func obserBoundaryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("Episode started playing")
            self?.enlargeEpisodeImageView()
            self?.setupLockScreenDuration()
        }
    }
    
    fileprivate func setupLockScreenDuration() {
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
    }
    fileprivate func setupInterruptionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: .AVCaptureSessionWasInterrupted, object: nil)
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        
        if type == AVAudioSession.InterruptionType.began.rawValue {
            print("Interruption began")
            playPauseBtn.setImage(UIImage(named: "play"), for: .normal)
            miniPlayerPauseBtn.setImage(UIImage(named: "play"), for: .normal)
        } else {
            print("Interruption ended")
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
                miniPlayerPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRemoteControl()
        
        setupGesture()
        setupInterruptionObserver()
        observePlayerCurrentTime()
        obserBoundaryTime()
        
    }
    
    
    static func initFromNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
    }
    
    deinit {
        print("State of the player ...")
    }
    
    
    
}


