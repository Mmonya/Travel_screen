//
//  ProfileViewController.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 12.06.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    typealias ViewModel = ProfileViewModel
    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

//        showProfileDetailViewController()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        showProfileDetailViewController()
        super.viewIsAppearing(animated)
    }
    
    func showProfileDetailViewController() {
        let viewControllerToPresent = ProfileDetailViewController.instantiateFromStoryboard()
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .threeQuarters()]
            sheet.largestUndimmedDetentIdentifier = .threeQuarters
        }
        viewControllerToPresent.viewModel = ViewModelsFactory.shared.profileDetailViewModel()
        viewControllerToPresent.isModalInPresentation = true
        present(viewControllerToPresent, animated: false, completion: nil)
    }
}

extension UISheetPresentationController.Detent.Identifier {
    static let threeQuarters = UISheetPresentationController.Detent.Identifier("threeQuarters")
}

extension UISheetPresentationController.Detent {
    static func threeQuarters() -> UISheetPresentationController.Detent {
        .custom(identifier: .threeQuarters) { context in
            0.75 * context.maximumDetentValue
        }
    }
}
