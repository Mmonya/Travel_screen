//
//  ProfileInfo.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 26.06.2024.
//

import Foundation

struct ProfileInfo: Codable {
    var name = "John Doe"
    var description = "Here, you can add some additional information"
    var visitedCountries = [CountryInfo]()
    var planedCountries = [CountryInfo]()
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case visitedCountries
        case planedCountries
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        visitedCountries = try container.decode([String].self, forKey: .visitedCountries).compactMap { CountryInfoProvider.shared.country(for: $0) }
        planedCountries = try container.decode([String].self, forKey: .planedCountries).compactMap { CountryInfoProvider.shared.country(for: $0) }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(visitedCountries.map { $0.regionIdentifier }, forKey: .visitedCountries)
        try container.encode(planedCountries.map { $0.regionIdentifier }, forKey: .planedCountries)
    }
}
