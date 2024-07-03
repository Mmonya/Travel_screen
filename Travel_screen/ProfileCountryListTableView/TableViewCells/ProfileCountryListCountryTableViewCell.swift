//
//  ProfileCountryListCountryTableViewCell.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 17.06.2024.
//

import UIKit

extension ProfileCountryListCountryTableViewCell {
    protocol ViewCellItemProtocol {
        var flag: String { get }
        var name: String { get }
    }
}

class ProfileCountryListCountryTableViewCell: UITableViewCell {
    @IBOutlet private weak var flagLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    func apply(_ item: ViewCellItemProtocol) {
        flagLabel.text = item.flag
        nameLabel.text = item.name
    }
}
