//
//  ProfileCountryListShowHideMoreTableViewCell.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 27.06.2024.
//

import UIKit

extension ProfileCountryListShowHideMoreTableViewCell {
    protocol Delegate: AnyObject {
        func onShowHide(for cell: ProfileCountryListShowHideMoreTableViewCell)
    }

    protocol ViewCellItemProtocol {
        var collapsed: Bool { get }
        var message: String { get }
    }
}

class ProfileCountryListShowHideMoreTableViewCell: UITableViewCell {
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    weak var delegate: Delegate?
    
    @IBAction func showHideAction(_ sender: Any) {
        delegate?.onShowHide(for: self)
    }
    
    func apply(_ item: ViewCellItemProtocol) {
        let imageName = item.collapsed ? "chevron.right" : "chevron.down"
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        arrowImageView.image = image
        messageLabel.text = item.message
    }
}
