//
//  CustomHeaderMenu.swift
//  Vox
//
//  Created by Skander Thabet on 3/5/2022.
//

import UIKit

class CustomHeaderMenu: UIView {
    
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let statusLabel = UILabel()
    let profileImageView = ProfileImageView()
    
    let user = UserDefaults.standard.callingUser(forKey: "user")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupComponents()
        setupStackView()
    }
    
    //MARK: - Setup Functions
    fileprivate func setupComponents() {
        //custom components for the menu header
        nameLabel.text = "\(user?.user.firstname ?? "") \(user?.user.lastname ?? "" )"
        nameLabel.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
        usernameLabel.text = "@\(user?.user.username ?? "")"
        statusLabel.text = "Online"
        guard let url = URL(string: user?.user.avatar ?? "") else { return }
        profileImageView.sd_setImage(with: url)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.clipsToBounds = true
        
    }
    
    fileprivate func setupStackView() {
        let arrangedSubViews = [
            UIView(),
            UIStackView(arrangedSubviews: [profileImageView,UIView()]),
            nameLabel,
            usernameLabel,
            SpacerView(space: 16),
            statusLabel
        ]
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
