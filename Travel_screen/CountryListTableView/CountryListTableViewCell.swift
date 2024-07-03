//
//  CountryListTableViewCell.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 19.06.2024.
//

import UIKit

extension CountryListTableViewCell {
    protocol Delegate: AnyObject {
        func addRemoveCountryDidClick(at cell: CountryListTableViewCell)
    }

    protocol ViewCellItemProtocol {
        var flag: String { get }
        var name: String { get }
        var selected: Bool { get }
    }
}

class CountryListTableViewCell: UITableViewCell {
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addRemoveButton: UIButton!
    weak var delegate: Delegate?
    
    private var countrySelected = false {
        didSet { updateButtonView() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonView()
    }

    @IBAction func addRemoveCountryAction(_ sender: UIButton) {
        delegate?.addRemoveCountryDidClick(at: self)
    }
    
    func apply(_ item: ViewCellItemProtocol) {
        flagLabel.text = item.flag
        nameLabel.text = item.name
        countrySelected = item.selected
    }

    // MARK: - Private methods
    
    private func updateButtonView() {
        let systemImageName = countrySelected ? "checkmark" : "plus"
        guard let image = UIImage(systemName: systemImageName) else { return }

        addRemoveButton.setImage(image, for: .normal)
    }
}
