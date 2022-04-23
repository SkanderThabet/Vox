//
//  APIService.swift
//  Vox
//
//  Created by Skander Thabet on 20/4/2022.
//

import Foundation
import Alamofire


class APIService {
    //singleton
    
    static let shared = APIService()
    
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
