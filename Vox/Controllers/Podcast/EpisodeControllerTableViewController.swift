//
//  EpisodeControllerTableViewController.swift
//  Vox
//
//  Created by Skander Thabet on 23/4/2022.
//

import UIKit
import FeedKit

class EpisodeControllerTableViewController: UITableViewController {

    var podcast : Podcast? {
        didSet {
            
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWork()
        setupNavigationBarButtons()
    }
    
    fileprivate func setupNavigationBarButtons() {
        //let's check if we have already saved this podcast as fav
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        let hasFavorited = savedPodcasts.index(where: { $0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName }) != nil
        if hasFavorited {
            // setting up our heart icon
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
//                UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts))
            ]
        }
        
    }
    
    @objc func handleSaveFavorite(){
        print("Saving info into UserDefaults")
        
        guard let podcast = self.podcast else { return }
        
        // 1. Transform Podcast into Data
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
//        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
        do {
           let data =  try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
        } catch let err {
            print("Error Save Favs : ",err)
            self.displayError(err)
        }
        
        
//        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
        
        showBadgeHighlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
    }
    
    @objc func handleFetchSavedPodcasts(){
        print("Fetching saved Podcasts from UserDefaults")
        // how to retrieve our Podcast object from UserDefaults
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return }
        
//        let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast]
        do {
        let savedPodcasts = try NSKeyedUnarchiver.unarchivedObject(ofClass: Podcast.self, from: data) as? [Podcast]
            savedPodcasts?.forEach({ (p) in
                        print(p.trackName ?? "")
                    })
        } catch let err {
            print("Error fetch : ",err)
        }
        
        
//        savedPodcasts?.forEach({ (p) in
//            print(p.trackName ?? "")
//        })
    }
    
    fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"

    }
    
    //MARK: - Fetch episodes
    fileprivate func fetchEpisodes(){
        guard let feedUrl = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Setup Work

    fileprivate func setupWork(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    fileprivate let cellId = "cellId"
    
    var episodes = [Episode]()
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return episodes.count
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = self.episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
