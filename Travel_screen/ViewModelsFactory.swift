//
//  ViewModelsFactory.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 26.06.2024.
//

import Foundation

class ViewModelsFactory {
    static let shared = ViewModelsFactory()

    private var appModel: AppModel!
    
    func setup(appModel: AppModel) {
        self.appModel = appModel
    }
    
    func profileViewModel() -> ProfileViewModel {
        ProfileViewModel(appModel: appModel)
    }
    
    func profileDetailViewModel() -> ProfileDetailViewModel {
        ProfileDetailViewModel(appModel: appModel)
    }
    
    func profileCountryListTableViewModel() -> ProfileCountryListTableViewModel {
        ProfileCountryListTableViewModel(appModel: appModel)
    }
    
    // MARK: - private methods

    private init() {
    }
}
