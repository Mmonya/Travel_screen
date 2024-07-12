//
//  ProfileViewModel.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 26.06.2024.
//

import MapKit
import Combine

class ProfileViewModel {
    private var cancellables = Set<AnyCancellable>()
    private var appModel: AppModel
    @Published private(set) var annotations = [CountryAnnotation]()
    
    init(appModel: AppModel) {
        self.appModel = appModel
        
        subscribeOnChanges()
        updateAnnotations()
    }
    
    // MARK: - Private methods

    private func updateAnnotations() {
        let createAnnotations = { (infos: [CountryInfo], checked: Bool) in
            var result = [CountryAnnotation]()
            for countryInfo in infos {
                let annotation = CountryAnnotation(coordinate: countryInfo.centerCoordinate,
                                                   flag: countryInfo.flag,
                                                   checked: checked)
                result.append(annotation)
            }
            return result
        }
        var annotations = createAnnotations(appModel.profileInfo.visitedCountries, true)
        annotations.append(contentsOf: createAnnotations(appModel.profileInfo.planedCountries, false))
        
        self.annotations = annotations
    }
    
    private func subscribeOnChanges() {
        appModel.$profileInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateAnnotations()
            }
            .store(in: &cancellables)
    }
}
