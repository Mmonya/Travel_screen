//
//  ProfileCountryListTableViewController.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 14.06.2024.
//

import UIKit
import Combine

extension ProfileCountryListTableViewController {
    enum Section: Int, CaseIterable {
        case visitedCountryList
        case bucketCountryList
        
        func description() -> String {
            switch self {
            case .visitedCountryList:
                "I’ve been to"
            case .bucketCountryList:
                "My bucket list"
            }
        }
    }
    
    enum CellType {
        case country(CountryData)
        case showHideMore(ShowHideData)
        case hint(HintData)

        struct CountryData: ProfileCountryListCountryTableViewCell.ViewCellItemProtocol {
            var flag: String
            var name: String
        }

        struct ShowHideData: ProfileCountryListShowHideMoreTableViewCell.ViewCellItemProtocol {
            var collapsed: Bool
            var message: String
        }

        struct HintData: ProfileCountryListHintTableViewCell.ViewCellItemProtocol {
            var message: String
        }
    }
    
    struct Item: Identifiable {
        let id = UUID()
        var cellType: CellType
        
        func cellReuseIdentifier() -> String {
            switch cellType {
            case .country(_):
                "ProfileСountryCellReusableIdentifier"
            case .showHideMore(_):
                "ProfileShowHideMoreCellReusableIdentifier"
            case .hint(_):
                "ProfileHintCellReusableIdentifier"
            }
        }
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Item.ID>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item.ID>
    typealias ViewModel = ProfileCountryListTableViewModel
    
    private static let sectionHeaderViewReuseIdentifier = String(describing: ProfileCountryListSectionHeaderView.self)
}

class ProfileCountryListTableViewController: UITableViewController {
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DataSource!

    @IBOutlet weak var countryCountLabel: UILabel!
    @IBOutlet weak var worldPercentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureDiffableDataSource()
    }
    
    var viewModel: ViewModel? {
        didSet {
            if oldValue !== viewModel {
                unsubscribeFromValues()
                subscribeToValues(from: viewModel)
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Self.sectionHeaderViewReuseIdentifier) as? ProfileCountryListSectionHeaderView else { return nil }
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfig.backgroundColor = .white
        view.backgroundConfiguration = backgroundConfig
        
        view.title.text = Section(rawValue: section)?.description() ?? "List with number: \(section)"
        view.tag = section
        view.delegate = self
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = contextualActions(forRowAt: indexPath)
        guard !actions.isEmpty else { return nil }
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    // MARK: - Private methods
    
    private func subscribeToValues(from viewModel: ViewModel?) {
        guard let viewModel else { return }
        viewModel.$dataSourceSnapshot
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            })
            .store(in: &cancellables)
        
        viewModel.$countryCount
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.updateCountryInfo(with: value)
            })
            .store(in: &cancellables)
        
        viewModel.$worldPercent
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.updateWorldInfo(with: value)
            })
            .store(in: &cancellables)
    }
    
    private func unsubscribeFromValues() {
        cancellables.removeAll()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: Self.sectionHeaderViewReuseIdentifier, bundle: nil),
                           forHeaderFooterViewReuseIdentifier: Self.sectionHeaderViewReuseIdentifier)
    }
    
    private func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak viewModel] tableView, indexPath, itemID in
            guard let item = viewModel?.visibleItem(for: itemID) else { return nil }
            let result = tableView.dequeueReusableCell(withIdentifier: item.cellReuseIdentifier(), for: indexPath)
            switch item.cellType {
            case let .country(info):
                guard let cell = result as? ProfileCountryListCountryTableViewCell else { break }
                cell.apply(info)
            case let .showHideMore(info):
                guard let cell = result as? ProfileCountryListShowHideMoreTableViewCell else { break }
                cell.apply(info)
                cell.delegate = self
            case let .hint(info):
                guard let cell = result as? ProfileCountryListHintTableViewCell else { break }
                cell.apply(info)
            }
            
            return result
        }
    }
    
    private func contextualActions(forRowAt indexPath: IndexPath) -> [UIContextualAction] {
        guard let itemID = dataSource.itemIdentifier(for: indexPath),
              viewModel?.canItemBeRemove(for: itemID) ?? false else { return [] }
        
        let remove = UIContextualAction(style: .destructive, title: "Remove") { [weak self] (action, view, completionHandler) in
            self?.viewModel?.removeVisibleItem(for: itemID)
            completionHandler(true)
        }
        
        return [remove]
    }
    
    private func updateCountryInfo(with count: Int) {
        countryCountLabel.text = "\(count)"
    }
    
    private func updateWorldInfo(with percent: Double) {
        var value = percent.formatted(.percent.rounded(rule: .toNearestOrAwayFromZero, increment: 0.1))
        worldPercentLabel.text = "\(value)"
    }
}

extension ProfileCountryListTableViewController: ProfileCountryListShowHideMoreTableViewCell.Delegate {
    func onShowHide(for cell: ProfileCountryListShowHideMoreTableViewCell) {
        guard let sectionIndex = tableView.indexPath(for: cell)?.section,
              let section = dataSource.sectionIdentifier(for: sectionIndex) else { return }
        viewModel?.toogleCollapseState(in: section)
    }
}

extension ProfileCountryListTableViewController: ProfileCountryListSectionHeaderView.Delegate {
    func addCoutryDidClick(on button: UIButton, for headerView: ProfileCountryListSectionHeaderView) {
        showCountryListViewController(on: button, for: .init(rawValue: headerView.tag) ?? .bucketCountryList)
    }
    
    private func showCountryListViewController(on anchorView: UIView, for section: Section) {
        let viewControllerToPresent = CountryListTableViewController.instantiateFromStoryboard()
        let countryInfos = self.viewModel?.unselectedCountryInfos(for: section) ?? []
        let viewModel = CountryListTableViewModel(countryInfos: countryInfos)
        viewModel.tagValue = section.rawValue
        viewControllerToPresent.viewModel = viewModel
        if let popoverPresentationController = viewControllerToPresent.popoverPresentationController {
            popoverPresentationController.sourceView = anchorView
        }
        viewControllerToPresent.delegate = self
                
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}

extension ProfileCountryListTableViewController: CountryListTableViewController.Delegate {
    func cancelCountrySelection() {
        dismiss(animated: true)
    }
    
    func doneCountrySelection() {
        guard let controller = presentedViewController as? CountryListTableViewController,
            let countries = controller.viewModel?.selectedCountries,
            let sectionRawValue = controller.viewModel?.tagValue,
            let section = Section(rawValue: sectionRawValue) else { return }
        dismiss(animated: true)
        
        viewModel?.add(countryInfos: countries, at: section)
    }
}
