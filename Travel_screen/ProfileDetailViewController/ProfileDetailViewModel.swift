//
//  ProfileDetailViewModel.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 26.06.2024.
//

import Foundation
import Combine

class ProfileDetailViewModel {
    private var appModel: AppModel
    private var cancellables = Set<AnyCancellable>()

    @Published var name = ""
    @Published var description = ""

    init(appModel: AppModel) {
        self.appModel = appModel
        
        updateValues()
        subscribeOnValues()
    }
    
    // MARK: - Private methods
    
    private func subscribeOnValues() {
        $description
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.appModel.profileInfo.description = value
            }
            .store(in: &cancellables)

        $name
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.appModel.profileInfo.name = value
            }
            .store(in: &cancellables)
    }
    
    private func updateValues() {
        name = appModel.profileInfo.name
        description = appModel.profileInfo.description
    }
}
