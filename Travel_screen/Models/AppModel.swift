//
//  AppModel.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 26.06.2024.
//

import Foundation
import Combine

extension AppModel {
    static private let ProfileInfoStorageKey = "ProfileInfoStorageKey"
}

class AppModel {
    private var cancellables = Set<AnyCancellable>()
    @Published var profileInfo = ProfileInfo()
    
    init() {
        restoreProfileInfo()
        subscribeOnProfileInfo()
    }
    
    // MARK: - Private methods
    
    private func restoreProfileInfo() {
        guard let data = storage().object(forKey: Self.ProfileInfoStorageKey) as? Data else { return }
        let decoder = JSONDecoder()
        if let decodedProfile = try? decoder.decode(ProfileInfo.self, from: data) {
            profileInfo = decodedProfile
        }
    }

    private func storeProfileInfo() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(profileInfo) else { return }
        storage().set(data, forKey: Self.ProfileInfoStorageKey)
    }
    
    private func storage() -> UserDefaults {
        UserDefaults.standard
    }

    private func subscribeOnProfileInfo() {
        $profileInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.storeProfileInfo()
            }
            .store(in: &cancellables)
    }
}
