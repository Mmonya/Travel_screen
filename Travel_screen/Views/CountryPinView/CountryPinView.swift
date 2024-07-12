//
//  CountryPinView.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 08.07.2024.
//

import UIKit

class CountryPinView: UIView {
    @IBOutlet private weak var pinCheckedImage: UIImageView!
    @IBOutlet private weak var flagLabel: UILabel!
    
    var checked = false {
        didSet { updateCheckedUI() }
    }

    var flag = "" {
        didSet { updateFlagUI() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
    }
    
    // MARK: - Private methods
    
    private func updateUI() {
        updateCheckedUI()
        updateFlagUI()
    }
    
    private func updateCheckedUI() {
        pinCheckedImage.isHidden = !checked
    }
    
    private func updateFlagUI() {
        flagLabel.text = flag
    }
}

extension CountryPinView: ViewNibInstantiation {
}
