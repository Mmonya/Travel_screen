//
//  ProfileDetailViewController.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 12.06.2024.
//

import UIKit

class ProfileDetailViewController: UIViewController {
//    private let profileViewControllerSegueIdentifier = "ProfileViewControllerSegueIdentifier"
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
    
//    @IBAction func unwindFromProfileViewControllerAction(unwindSegue: UIStoryboardSegue) {
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let shadowViewClass = NSClassFromString("UIDropShadowView")
//        var currentView = view
//        while let someView = currentView {
//            print("\(someView)")
//            if someView as? (shadowViewClass ?? UIView) {
//                
//            }
//            
//            currentView = currentView?.superview
//        }
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == profileViewControllerSegueIdentifier {
//            
//        }
//    }
    
//    override var sheetPresentationController: UISheetPresentationController? {
//        SmallSizePresentationController(presentedViewController: self, presenting: presentingViewController)
//    }
}

//class SmallSizePresentationController : UISheetPresentationController {
//    override var frameOfPresentedViewInContainerView: CGRect {
//        get {
//            guard let theView = containerView else {
//                return CGRect.zero
//            }
//            return CGRect(x: 0, y: theView.bounds.height * 0.5, width: theView.bounds.width, height: theView.bounds.height * 0.5)
//        }
//    }
//}
