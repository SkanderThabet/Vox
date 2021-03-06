//
//  FavoritePodcastCell.swift
//  Vox
//
//  Created by Skander Thabet on 26/4/2022.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
    
    var podcast: Podcast! {
        didSet {
            nameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            
            let url = URL(string: podcast.artworkUrl600 ?? "")
            imageView.sd_setImage(with: url)
            
        }
    }
    
    let imageView = UIImageView(image: UIImage(named: "Group 4922"))
    let nameLabel = UILabel()
    let artistNameLabel = UILabel()
    
    fileprivate func styleUI() {
        nameLabel.text = "Podcast name"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        artistNameLabel.text = "Podcast artist name"
        artistNameLabel.font = UIFont.systemFont(ofSize:  14)
        artistNameLabel.textColor = .lightGray
    }
    
    fileprivate func setupAnchors() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageView , nameLabel,artistNameLabel])
        
        stackView.axis = .vertical
        //auto layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        styleUI()
        setupAnchors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder: has not been implemented")
    }
}
