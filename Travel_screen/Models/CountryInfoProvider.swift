//
//  CountryInfoProvider.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 17.06.2024.
//

import Foundation

protocol CountryInfoProviderProtocol {
    var countries: [CountryInfo] { get }
    
    func country(for regionIdentifier: String) -> CountryInfo?
}

class CountryInfoProvider: CountryInfoProviderProtocol {
    static let shared = CountryInfoProvider()
    private(set) var countries = [CountryInfo]()
    
    func country(for regionIdentifier: String) -> CountryInfo? {
        countries.first { $0.regionIdentifier == regionIdentifier }
    }
    
    // MARK: - private methods
    
    private init() {
        setupCountries()
    }
    
    private func setupCountries() {
        let regions = Locale.Region.isoRegions
        for region in regions {
            let regionIdentifier = region.identifier
            guard region.subRegions.isEmpty &&
                    regionIdentifier != "CQ" else { continue } // There is no standard flag for "CQ": "Sark"
            
            let flag = countryFlag(countryCode: regionIdentifier)
            let countryInfo = CountryInfo(regionIdentifier: regionIdentifier,
                                          flag: flag)
            countries.append(countryInfo)
        }
    }
    
    private func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) }
            )
        ))
    }
}
