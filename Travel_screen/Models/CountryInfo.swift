//
//  CountryInfo.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 17.06.2024.
//

import Foundation

struct CountryInfo: Identifiable {
    let id = UUID()
    let regionIdentifier: String
    let flag: String
    
    func localizedName(for locale: Locale = Locale.current) -> String {
        locale.localizedString(forRegionCode: regionIdentifier) ?? ""
    }
}
