//
//  ViewControllerStoryboardInstantiation.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 19.06.2024.
//

import UIKit

protocol ViewControllerStoryboardInstantiation: AnyObject {
    static var storyboardName: String { get }
    static var storyboardID: String { get }
}

extension ViewControllerStoryboardInstantiation where Self: UIViewController {
    static func instantiateFromStoryboard() -> Self {
        return UIStoryboard(name: storyboardName, bundle: nil)
            .instantiateViewController<Self>(identifier: storyboardID, creator: nil)
    }
}
