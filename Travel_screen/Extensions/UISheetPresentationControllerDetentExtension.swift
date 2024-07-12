//
//  UISheetPresentationControllerDetentExtension.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 04.07.2024.
//

import UIKit

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
