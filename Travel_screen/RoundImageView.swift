//
//  RoundImageView.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 13.06.2024.
//

import UIKit

class RoundImageView: UIImageView {
    var masksToBounds = true {
        didSet { setNeedsLayout() }
    }
    var borderWidth = 4.0 {
        didSet { setNeedsLayout() }
    }
    var borderColor = UIColor.white {
        didSet { setNeedsLayout() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let layer = self.layer
        layer.borderWidth = borderWidth
        layer.masksToBounds = masksToBounds
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
}
