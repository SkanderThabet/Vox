//
//  SpacerView.swift
//  Vox
//
//  Created by Skander Thabet on 3/5/2022.
//

import UIKit

class SpacerView: UIView {
    
    let space: CGFloat

    override var intrinsicContentSize: CGSize {
        return .init(width: space, height: space)
    }
    
    init(space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

