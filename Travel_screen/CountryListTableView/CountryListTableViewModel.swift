//
//  CountryListTableViewModel.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 19.06.2024.
//

import Combine

extension CountryListTableViewModel {
    typealias DataSourceSnapshot = CountryListTableViewController.DataSourceSnapshot
    typealias Item = CountryListTableViewController.Item
}

class CountryListTableViewModel {
    private var countries: [Item] = []
    private var countryInfos: [CountryInfo] = []
    @Published private(set) var dataSourceSnapshot = DataSourceSnapshot()
    var searchText = "" {
        didSet { invalidateDataSourceSnapshot() }
    }
    var selectedCountries: [CountryInfo] {
        var result = [CountryInfo]()
        for (index, item) in countries.enumerated() {
            guard item.selected else { continue }
            result.append(countryInfos[index])
        }
        return result
    }
    var tagValue = 0

    init(countryInfos: [CountryInfo]) {
        self.countryInfos = countryInfos
        initialize()
    }
    
    func toogleSelection(for id: Item.ID) {
        guard let index = countries.firstIndex(where: { $0.id == id }) else { return }
        toogleSelectionAndUpdateSnapshot(for: index)
    }

    func countryListItem(for id: Item.ID) -> Item? {
        countries.first { $0.id == id }
    }
    
    // MARK: - Private methods
    
    private func initialize() {
        setupCountryList(for: countryInfos)
        invalidateDataSourceSnapshot()
    }
    
    private func createDataSourceSnapshot(for countries: [Item]) -> DataSourceSnapshot {
        let ids = countries.map { $0.id }
        var result = DataSourceSnapshot()
        result.appendSections([.main])
        result.appendItems(ids)
        return result
    }

    private func reconfigureDataSourceSnapshot(for countries: [Item]) {
        let ids = countries.map { $0.id }
        dataSourceSnapshot.reconfigureItems(ids)
    }

    private func setupCountryList(for countryInfos: [CountryInfo]) {
        var newCountries = [Item]()
        for countryInfo in countryInfos {
            let item = Item(flag: countryInfo.flag, name: countryInfo.localizedName(), selected: false)
            newCountries.append(item)
        }
        
        countries = newCountries
    }
    
    private func invalidateDataSourceSnapshot() {
        let countries = countryList(flteredBy: searchText)
        dataSourceSnapshot = createDataSourceSnapshot(for: countries)
    }
    
    private func countryList(flteredBy text: String) -> [Item] {
        guard !text.isEmpty else { return countries }
        return countries.filter {
            $0.name.localizedStandardContains(text)
        }
    }

    func toogleSelectionAndUpdateSnapshot(for index: Int) {
        countries[index].selected.toggle()
        let item = countries[index]
        reconfigureDataSourceSnapshot(for: [item])
    }
}
