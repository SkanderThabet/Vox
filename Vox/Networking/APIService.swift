//
//  APIService.swift
//  Vox
//
//  Created by Skander Thabet on 20/4/2022.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    //singleton
    
    static let shared = APIService()
    
    func fetchEpisodes (feedUrl: String , completionHandler : @escaping ([Episode]) -> ()) {
        guard let url = URL(string: feedUrl) else { return }
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                // Do your thing, then back to the Main thread
                DispatchQueue.main.async {
                    switch result {
                    case .success(let feed):
                        feed.rssFeed
                        switch feed {
                        case let .atom(feed):
                            break
                        case let .rss(feed):
                            let episodes = feed.toEpisodes()
                            completionHandler(episodes)
                            break
                        case let .json(feed):
                            break
                        }
                        
                    case .failure(let error):
                        print(error)
                        
                        break
                    }
                    
                }
            }
        }
        
    }
    
    
    func fetchPodcats(searchText : String, completionHandler : @escaping ([Podcast]) -> ()) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term" : searchText, "media": "podcast"]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseData { (DataResponse) in
            if let err = DataResponse.error {
                print("Failed to fetch api ...",err)
                return
            }
            guard let data = DataResponse.data else { return }
            //            let dummyString = String(data: data, encoding: .utf8)
            //            print(dummyString ?? "")
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
                //                print("Result count : ", searchResult.resultCount)
                //print specific attr from fetching json api
                //                searchResult.results.forEach({ (podcast) in
                //                    print(podcast.trackName, podcast.artistName)
                //                })
                //                self.podcasts = searchResult.results
                //                self.tableView.reloadData()
            } catch let err {
                print("Failed to decode",err)
                //                self.displayError(err)
            }
        }
    }
}
