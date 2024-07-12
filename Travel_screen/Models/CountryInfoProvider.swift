//
//  CountryInfoProvider.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 17.06.2024.
//

import UIKit

protocol CountryInfoProviderProtocol {
    var countries: [CountryInfo] { get }

    func country(for regionIdentifier: String) -> CountryInfo?
}

class CountryInfoProvider: CountryInfoProviderProtocol {
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
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
        countries = readCountryInfosFromJSON()
    }
    
    private func readCountryInfosFromJSON() -> [CountryInfo] {
        guard let data = NSDataAsset(name: .countryInfoJSONAssetName)?.data else { return [] }
        let decoder = jsonDecoder

        var result = [CountryInfo]()
        do {
            result = try decoder.decode([CountryInfo].self, from: data)
        } catch {
            print("Error occures when read json file \(error)")
        }
        
        return result
    }
    
    private func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) }
            )
        ))
    }
}
