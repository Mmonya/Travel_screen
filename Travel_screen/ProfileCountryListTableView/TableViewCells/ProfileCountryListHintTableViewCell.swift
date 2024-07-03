//
//  ProfileCountryListHintTableViewCell.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 01.07.2024.
//

import UIKit

extension ProfileCountryListHintTableViewCell {
    protocol ViewCellItemProtocol {
        var message: String { get }
    }
}

class ProfileCountryListHintTableViewCell: UITableViewCell {
    @IBOutlet private weak var messageLabel: UILabel!

    func apply(_ item: ViewCellItemProtocol) {
        messageLabel.text = item.message
    }
}
