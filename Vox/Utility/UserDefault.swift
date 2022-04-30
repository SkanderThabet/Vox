//
//  UserDefault.swift
//  Vox
//
//  Created by Skander Thabet on 26/4/2022.
//

import Foundation

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    
    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
//        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Podcast] else { return [] }
        do {
            guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData)as? [Podcast] else { return [] }
            return savedPodcasts
        } catch let err {
            print(err)
        }
        return savedPodcasts()
    }
    
    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
//        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
        } catch let err {
            print(err)
        }
//        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }
    
    func callingUser(forKey defaultName: String) -> UserProfile? {
            guard let data = data(forKey: defaultName) else { return nil }
            do {
                return try JSONDecoder().decode(UserProfile.self, from: data)
            } catch { print(error); return nil }
        }

        func set(_ value: UserProfile, forKey defaultName: String) {
            let data = try? JSONEncoder().encode(value)
            set(data, forKey: defaultName)
        }
    
}
