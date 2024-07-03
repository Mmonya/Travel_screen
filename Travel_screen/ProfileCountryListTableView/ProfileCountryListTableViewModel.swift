//
//  ProfileCountryListTableViewModel.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 21.06.2024.
//

import Foundation
import Combine

extension ProfileCountryListTableViewModel {
    typealias DataSourceSnapshot = ProfileCountryListTableViewController.DataSourceSnapshot
    typealias Item = ProfileCountryListTableViewController.Item
    typealias Section = ProfileCountryListTableViewController.Section
    typealias CellType = ProfileCountryListTableViewController.CellType

    static private let thresholdOfFirstVisibleItems = 4
}

class ProfileCountryListTableViewModel {
    private var appModel: AppModel
    private var countryInfoProvider: CountryInfoProviderProtocol
    private var baseItemsAndInfos = [Item.ID : CountryInfo.ID]()
    private var allItems = [Section: [Item]]()
    private var separatorItemIndexes = [Section: Int]()
    private var visibleItems = [Section: [Item]]()
    @Published private(set) var dataSourceSnapshot = DataSourceSnapshot()
    @Published private(set) var countryCount = 0
    @Published private(set) var worldPercent = 0.0

    init(appModel: AppModel, countryInfoProvider: CountryInfoProviderProtocol = CountryInfoProvider.shared) {
        self.appModel = appModel
        self.countryInfoProvider = countryInfoProvider
        
        initialize()
    }
    
    func visibleItem(for id: Item.ID) -> Item? {
        return allItems.values.flatMap { $0 }.first { $0.id == id }
    }
    
    func unselectedCountryInfos(for section: Section) -> [CountryInfo] {
        let selectedItemIds = allItems[section]?.map { $0.id } ?? []
        let infoIDs = countryInfoIDs(from: selectedItemIds)
        
        return countryInfoProvider.countries.filter {
            !infoIDs.contains($0.id)
        }.sorted {
            $0.localizedName() < $1.localizedName()
        }
    }
    
    func add(countryInfos: [CountryInfo], at section: Section) {
        guard !countryInfos.isEmpty else { return }
        addToAllBaseItems(countryInfos: countryInfos, at: section)
        invalidateVisibleItems()
        initializeDataSourceSnapshot()
        storeCountryInfos()
        updateCountryNumbers()
    }
    
    func toogleCollapseState(in section: Section) {
        toogleSeparatorState(in: section)
        invalidateVisibleItems()
        initializeDataSourceSnapshot()
    }
    
    func canItemBeRemove(for itemID: Item.ID) -> Bool {
        guard let item = visibleItem(for: itemID),
              case .country(_) = item.cellType else { return false }
        
        return true
    }
    
    func removeVisibleItem(for itemID: Item.ID) {
        guard canItemBeRemove(for: itemID) else { return }
        
        removeItemFromAllBaseItems(with: itemID)
        invalidateVisibleItems()
        initializeDataSourceSnapshot()
        storeCountryInfos()
        updateCountryNumbers()
    }
    
    // MARK: - Private methods
    
    private func initialize() {
        initializeAllBaseItems()
        invalidateVisibleItems()
        initializeDataSourceSnapshot()
        updateCountryNumbers()
    }
    
    private func initializeAllBaseItems() {
        for section in Section.allCases {
            let countryInfos = storedCountryInfos(for: section)
            allItems[section] = [createPlaceholderItem()]
            addToAllBaseItems(countryInfos: countryInfos, at: section)
        }
    }
    
    private func addToAllBaseItems(countryInfos: [CountryInfo], at section: Section) {
        guard !countryInfos.isEmpty else { return }
        let (items, mapping) = createItems(for: countryInfos)
        baseItemsAndInfos.merge(mapping) { (current, _) in current }
        
        var (separatorIndex, separatorItem) = removeSeparatorItem(at: section)
        var currentItems = allItems[section] ?? []
        
        if currentItems.count == 1,
           case .hint(_) = currentItems[0].cellType {
            currentItems = items
        } else {
            currentItems.insert(contentsOf: items, at: 0)
        }
        
        addIfNeededNewOrUpdatedSeparator(with: separatorItem, separatorIndex: &separatorIndex, at: &currentItems)
        separatorItemIndexes[section] = separatorIndex
        
        allItems[section] = currentItems
    }

    private func removeItemFromAllBaseItems(with itemID: Item.ID) {
        guard let (section, _) = sectionAndIndex(for: itemID) else { return }
        
        var (separatorIndex, separatorItem) = removeSeparatorItem(at: section)
        var currentItems = allItems[section] ?? []
        if let (_, index) = sectionAndIndex(for: itemID) {
            currentItems.remove(at: index)
        }

        if currentItems.count == 0 {
            currentItems = [createPlaceholderItem()]
        }

        addIfNeededNewOrUpdatedSeparator(with: separatorItem, separatorIndex: &separatorIndex, at: &currentItems)
        separatorItemIndexes[section] = separatorIndex
        
        allItems[section] = currentItems
        baseItemsAndInfos[itemID] = nil
    }
    
    private func sectionAndIndex(for itemID: Item.ID) -> (Section, Int)? {
        for (section, items) in allItems {
            guard let index = items.firstIndex(where: { $0.id == itemID }) else { continue }
            return (section, index)
        }
        
        return nil
    }
    
    private func createPlaceholderItem() -> Item {
        Item(cellType: .hint(.init(message: "None")))
    }
    
    private func separatorCellType(for collapsed: Bool, itemsCount: Int) -> CellType {
        let count  = itemsCount - Self.thresholdOfFirstVisibleItems + 1
        let message = separatorItemMessage(for: collapsed, count: count)
        return .showHideMore(.init(collapsed: collapsed, message: message))
    }
    
    private func separatorItemMessage(for collapsed: Bool, count: Int) -> String {
        collapsed ? "See \(count) more" : "Hide next \(count)"
    }
    
    private func removeSeparatorItem(at section: Section) -> (Int?, Item?) {
        var separatorItem: Item?
        let separatorIndex = separatorItemIndexes[section]
        if let separatorIndex {
            separatorItem = allItems[section]?.remove(at: separatorIndex)
        }
        return (separatorIndex, separatorItem)
    }
    
    private func addIfNeededNewOrUpdatedSeparator(with separatorItem: Item?, separatorIndex: inout Int?, at items: inout [Item]) {
        var item = separatorItem
        if items.count > Self.thresholdOfFirstVisibleItems {
            if case let .showHideMore(info) = item?.cellType {
                item?.cellType = separatorCellType(for: info.collapsed, itemsCount: items.count)
            } else {
                item = Item(cellType: separatorCellType(for: true, itemsCount: items.count))
                separatorIndex = Self.thresholdOfFirstVisibleItems - 1
            }
        } else {
            separatorIndex = nil
        }
        
        if let item, let separatorIndex {
            items.insert(item, at: separatorIndex)
        }
    }
    
    private func toogleSeparatorState(in section: Section) {
        guard let separatorIndex = separatorItemIndexes[section],
              let items = allItems[section]  else { return }
        
        var separatorItem = items[separatorIndex]
        guard case var .showHideMore(info) = separatorItem.cellType else { return }
        info.collapsed.toggle()
        separatorItem.cellType = separatorCellType(for: info.collapsed, itemsCount: items.count - 1)
        
        allItems[section]?[separatorIndex] = separatorItem
    }
    
    private func invalidateVisibleItems() {
        visibleItems.removeAll()
        for (section, items) in allItems {
            var newItems = [Item]()
            if let separatorIndex = separatorItemIndexes[section] {
                let separatorItem = items[separatorIndex]
                if case let .showHideMore(info) = separatorItem.cellType,
                   !info.collapsed {
                    newItems = items
                } else {
                    newItems = Array(items[0...separatorIndex])
                }
            } else {
                newItems = items
            }
            
            visibleItems[section] = newItems
        }
    }
    
    private func initializeDataSourceSnapshot() {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections(Section.allCases)
        for (section, items) in visibleItems {
            snapshot.appendItems(items.map { $0.id }, toSection: section)
            if let separatorIndex = separatorItemIndexes[section] {
                snapshot.reconfigureItems([items[separatorIndex].id])
            }
        }
        
        self.dataSourceSnapshot = snapshot
    }
    
    private func createItems(for countryInfos: [CountryInfo]) -> ([Item], [Item.ID : CountryInfo.ID]) {
        var items = [Item]()
        var mapping = [Item.ID : CountryInfo.ID]()
        for info in countryInfos {
            let item = Item(cellType: .country(.init(flag: info.flag, name: info.localizedName())))
            mapping[item.id] = info.id
            items.append(item)
        }
        
        return (items, mapping)
    }
    
    private func countryInfoIDs(from itemIDs: [Item.ID]) -> Set<CountryInfo.ID> {
        var infoIDs = Set<UUID>()
        for itemId in itemIDs {
            if let infoID = baseItemsAndInfos[itemId] {
                infoIDs.insert(infoID)
            }
        }
        return infoIDs
    }
    
    private func storedCountryInfos(for section: Section) -> [CountryInfo] {
        switch section {
        case .visitedCountryList:
            appModel.profileInfo.visitedCountries
        case .bucketCountryList:
            appModel.profileInfo.planedCountries
        }
    }
    
    private func storeCountryInfos() {
        for (section, items) in allItems {
            let infoIDs = countryInfoIDs(from: items.map { $0.id } )
            let countryInfos = countryInfoProvider.countries.filter {
                infoIDs.contains($0.id)
            }

            switch section {
            case .visitedCountryList:
                appModel.profileInfo.visitedCountries = countryInfos
            case .bucketCountryList:
                appModel.profileInfo.planedCountries = countryInfos
            }
        }
    }
    
    private func updateCountryNumbers() {
        let allCountryCount = countryInfoProvider.countries.count
        countryCount = appModel.profileInfo.visitedCountries.count
        worldPercent = Double(countryCount) / Double(allCountryCount)
    }
}
