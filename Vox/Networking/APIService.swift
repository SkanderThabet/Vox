//
//  APIService.swift
//  Vox
//
//  Created by Skander Thabet on 20/4/2022.
//

import Foundation
import Alamofire
import FeedKit
import JGProgressHUD
import SwiftyJSON


class APIService {
    //singleton
    
    static let shared = APIService()
    var user : UserProfile?
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
    
//    func callingLoginApi(email : String, password: String, _ hud: JGProgressHUD, completionHandler : @escaping Handler) {
//        let url = "https://voxappli.herokuapp.com/api/vox/auth/login"
//        let params = ["email" : email,"password" : password]
//
//        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default).response { response in
//            debugPrint(response)
//            hud.dismiss()
//            switch response.result {
//            case .success(let data):
//                do {
//                    let json = try JSONDecoder().decode(UserProfile.self, from: data!)
////                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                    if (response.response?.statusCode == 200) {
//                        completionHandler(.success(json))
//                    } else {
//                        completionHandler(.failure(.customMessage(message: "Please check your network connectivity")))
//                    }
//                } catch let error {
//                    print(error)
//                    completionHandler(.failure(.customMessage(message: "Please try again")))
//                }
//
//            case .failure(let error):
//                print(error)
//                completionHandler(.failure(.customMessage(message: "Please try again")))
//            }
//    }
//}
    func callingLoginApi(email : String, password: String, _ hud: JGProgressHUD, completionHandler : @escaping Handler)  {
        let url = "https://voxappli.herokuapp.com/api/vox/auth/login"
        let params = ["email" : email,"password" : password]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { (DataResponse)  in
                print(DataResponse)
                hud.dismiss()
                if let _ = DataResponse.error {
                    completionHandler(.failure(.customMessage(message: "Please check your network connectivity")))
                    print(DataResponse.error as Any)
                    return
                }
                switch DataResponse.result {
                case .success(let data):
                    do {
                        let json = try JSONDecoder().decode(UserProfile.self, from: data )
                        print(json)
                        UserDefaults.standard.set(json, forKey: "user")
                        self.user = UserDefaults.standard.callingUser(forKey: "user")
                        print("USer : ",self.user!)
                        completionHandler(.success(json))
                    } catch let error {
                        print(error)
                        completionHandler(.failure(.customMessage(message: "Please Try Again")))
                        
                    }
                    
                case .failure(let error):
                    print(error)
                    completionHandler(.failure(.customMessage(message: "Please Try Again")))
                    
                }
                
            }
    }
    
    func callingLogOutApi(){
        let headers : HTTPHeaders = [
            "token": "\(TokenService.tokenInstance.getToken)"
        ]
        let url = "https://voxappli.herokuapp.com/api/vox/auth/"
        AF.request(url, method: .get, headers: headers).response { response in
            switch response.result {
            case.success(_):
                TokenService.tokenInstance.removeToken()
//                let welcomeVC = WelcomeViewController.sharedInstance()
//                vc.navigationController?.pushViewController(welcomeVC, animated: true)
                let rootVC = UIApplication.shared.windows.first?.rootViewController
                if let topVC = UIApplication.getTopViewController(){
                    if rootVC?.children.first is HomeViewController{
                        topVC.navigationController?.pushViewController(WelcomeViewController.sharedInstance(), animated: true)
                    } else {
                        let welcomeVC = WelcomeViewController.sharedInstance()
                        topVC.navigationController?.pushViewController(welcomeVC, animated: true)
                    }
                }
                print("Token removed")
            case .failure(let error):
                print("Error fetch logged in user : ",error)
            }
        }
        
        
    }
    
    func callingFetchLoggedUser(completionHandler : @escaping Handler){
        let url = "https://voxappli.herokuapp.com/api/vox/auth"
        var urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest = try! JSONEncoding.default.encode(urlRequest, with: nil)
            urlRequest.setValue("\(TokenService.tokenInstance.getToken())", forHTTPHeaderField: "Authorization")

        AF.request(urlRequest).responseData { response in
            switch response.result {
            case.success(let data):
                do {
                    let json = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(json)
                    completionHandler(.success(response))
                } catch let error {
                    print(error)
                    completionHandler(.failure(.customMessage(message: "Error While Fetching Token for user")))
                }
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(.customMessage(message: "Error While Fetching Token for user")))
                print(error)
            }
        }
        
    }
    
    func callingSendEmail (email: String,code : String, completed: @escaping (Bool, Any?) -> Void) {
        print("----code ",code)
        let url = "https://voxappli.herokuapp.com/api/vox/auth/IosSendMail/"
            AF.request(url+email,
                       method: .post, parameters: ["code": code] , encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
                    .validate(contentType: ["application/json"])
                    .responseData { response in
                        switch response.result {
                        case .success:
                            let jsonData = JSON(response.data!)
                            let utilisateur = self.makeItem(jsonItem: jsonData)
                           
                            print(utilisateur)
                            completed(true, utilisateur)
                        case let .failure(error):
                            debugPrint(error)
                            completed(false, nil)
                        }
                    }
            }
    
    func ResetPassword(email: String,password : String, completed: @escaping (Bool, Any?) -> Void) {
        let url = "https://voxappli.herokuapp.com/api/vox/auth/Iosresetpassword/"
            AF.request(url + email,
                       method: .post, parameters: ["password": password], encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
                    .validate(contentType: ["application/json"])
                    .responseData { response in
                        switch response.result {
                        case .success:
                            let jsonData = JSON(response.data!)
                            let utilisateur = self.makeItem(jsonItem: jsonData)
                           
                            print(utilisateur)
                            completed(true, utilisateur)
                        case let .failure(error):
                            debugPrint(error)
                            completed(false, nil)
                        }
                    }
            }
    
    func makeItem(jsonItem: JSON) -> User {
            
           
            
            return User(
                id: jsonItem["_id"].stringValue,
                username: jsonItem["username"].stringValue,
                email: jsonItem["email"].stringValue,
                firstname: jsonItem["firstname"].stringValue,
                lastname: jsonItem["lastname"].stringValue,
                dob: jsonItem["dob"].stringValue,
                avatar: jsonItem["avatar"].stringValue,
                v: jsonItem["__v"].intValue,
                updatedAt: jsonItem["updatedAt"].stringValue,
                password: jsonItem["password"].stringValue
            )

        
        }
}
