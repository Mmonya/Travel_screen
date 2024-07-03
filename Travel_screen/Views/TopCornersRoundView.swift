//
//  TopCornersRoundView.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 13.06.2024.
//

import UIKit

class TopCornersRoundView: UIView {
    var cornerRadius = 16.0 {
        didSet { setNeedsLayout() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
    }
}
