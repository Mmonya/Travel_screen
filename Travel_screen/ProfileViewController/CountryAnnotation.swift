//
//  CountryAnnotation.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 08.07.2024.
//

import MapKit

class CountryAnnotation: NSObject, CountryAnnotationView.Annotation {
    let id = UUID()
    @objc dynamic let coordinate: CLLocationCoordinate2D
    var flag: String
    var checked: Bool
    
    init(coordinate: CLLocationCoordinate2D, flag: String, checked: Bool) {
        self.coordinate = coordinate
        self.flag = flag
        self.checked = checked
    }
}

extension CountryAnnotation: Identifiable {
}
