//
//  ProfileViewController.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 12.06.2024.
//

import UIKit

class ProfileViewController: UIViewController {
//    weak var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        showProfileDetailViewController()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        showProfileDetailViewController()
        super.viewIsAppearing(animated)
    }
    
    func showProfileDetailViewController() {
        let viewControllerToPresent = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController<ProfileDetailViewController>(identifier: "ProfileDetailViewControllerStoryboardID", creator: nil)
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .threeQuarters()]
            sheet.largestUndimmedDetentIdentifier = .threeQuarters
//            sheet.containerView
        }
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
