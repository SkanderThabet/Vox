//
//  Podcast.swift
//  Vox
//
//  Created by Skander Thabet on 15/4/2022.
//

import Foundation

class Podcast : NSObject, Decodable, NSCoding , NSSecureCoding{
    static var supportsSecureCoding: Bool = {
        return true
    }()
    
    func encode(with coder: NSCoder) {
        print("Trying to turn Data into Podcast")
        
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        coder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
        coder.encode(feedUrl ?? "", forKey: "feedKey")
    }
    
    required init?(coder: NSCoder) {
        print("Trying to transform Podcast into Data")
        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = coder.decodeObject(forKey: "artworkKey") as? String
        self.feedUrl = coder.decodeObject(forKey: "feedKey") as? String
    }
    
    
    
        
    var trackName: String?
    var artistName : String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
}



    

