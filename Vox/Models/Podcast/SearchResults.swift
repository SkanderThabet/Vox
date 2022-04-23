//
//  SearchResults.swift
//  Vox
//
//  Created by Skander Thabet on 20/4/2022.
//

import Foundation

public struct SearchResults: Decodable {
    // MARK: - Properties
    let resultCount:Int
    let results: [Podcast]
    
}
