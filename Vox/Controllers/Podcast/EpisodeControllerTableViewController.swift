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
            fetchEpisodes()
            navigationItem.title = podcast?.trackName
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWork()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
//        guard let url = URL(string: feedUrl) else { return }
//        let parser = FeedParser(URL: url)
//        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
//            // Do your thing, then back to the Main thread
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let feed):
//                    feed.rssFeed
//                    switch feed {
//                    case let .atom(feed):
//                        break
//                    case let .rss(feed):
//                        self.episodes = feed.toEpisodes()
//                        self.tableView.reloadData()
//                        break
//                    case let .json(feed):
//                        break
//                    }
//
//                case .failure(let error):
//                    print(error)
//                    self.displayError(error)
//                    break
//                }
//
//            }
//        }
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
//
//        let episode = self.episodes[indexPath.row]
//        let window = UIApplication.shared.keyWindow
//        let playerDetailsView = PlayerDetailsView.initFromNib()
//        playerDetailsView.episode = episode
//        playerDetailsView.frame = self.view.frame
//
//        window?.addSubview(playerDetailsView)
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
