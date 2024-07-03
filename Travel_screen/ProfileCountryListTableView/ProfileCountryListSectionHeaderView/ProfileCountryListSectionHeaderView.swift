//
//  ProfileCountryListSectionHeaderView.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 14.06.2024.
//

import UIKit

extension ProfileCountryListSectionHeaderView {
    protocol Delegate: AnyObject {
        func addCoutryDidClick(on button: UIButton, for headerView: ProfileCountryListSectionHeaderView)
    }
}

class ProfileCountryListSectionHeaderView: UITableViewHeaderFooterView {
    weak var delegate: Delegate?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var separator: UIView! // remove later
    
    @IBAction func addCoutryAction(_ sender: UIButton) {
        delegate?.addCoutryDidClick(on: sender, for: self)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }

//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
}
