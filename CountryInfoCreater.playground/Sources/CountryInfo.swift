//
//  CountryInfo.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 17.06.2024.
//

import MapKit
import CoreLocation

struct CountryInfo: Identifiable, Codable {
    let id = UUID()
    var regionIdentifier: String
    var flag: String
    var centerCoordinate: CLLocationCoordinate2D
    
    func localizedName(for locale: Locale = Locale.current) -> String {
        locale.localizedString(forRegionCode: regionIdentifier) ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case regionIdentifier
        case flag
        case centerCoordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        regionIdentifier = try container.decode(String.self, forKey: .regionIdentifier)
        flag = try container.decode(String.self, forKey: .flag)
        centerCoordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .centerCoordinate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(regionIdentifier, forKey: .regionIdentifier)
        try container.encode(flag, forKey: .flag)
        try container.encode(centerCoordinate, forKey: .centerCoordinate)
    }
}

