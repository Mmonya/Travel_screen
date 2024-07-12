//
//  ViewNibInstantiation.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 08.07.2024.
//

import UIKit

protocol ViewNibInstantiation: AnyObject {
    static var associatedNibName: String { get }
}

extension ViewNibInstantiation where Self: UIView {
    static var associatedNibName: String {
        String(describing: self)
    }
    
    static var associatedNib : UINib {
        UINib(nibName: associatedNibName, bundle: Bundle.main)
    }
    
    static func instantiateFromNib() -> Self {
        associatedNib.instantiate(withOwner:nil, options: nil)[0] as! Self
    }
}
