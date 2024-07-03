//
//  CountryListTableViewController.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 17.06.2024.
//

import UIKit
import Combine

extension CountryListTableViewController {
    protocol Delegate: AnyObject {
        func cancelCountrySelection()
        func doneCountrySelection()
    }

    enum Section: Hashable {
        case main
    }
    
    struct Item: Identifiable, CountryListTableViewCell.ViewCellItemProtocol {
        let id = UUID()
        let flag: String
        let name: String
        var selected = false
        var cellReuseIdentifier: String {
            "СountryCellReusableIdentifier"
        }
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Item.ID>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item.ID>
    typealias ViewModel = CountryListTableViewModel
}

class CountryListTableViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DataSource!

    @IBOutlet weak var tableView: UITableView!
    var viewModel: ViewModel? {
        didSet {
            if oldValue !== viewModel {
                unsubscribeFromSnapshot()
                subscribeToSnapshot(from: viewModel)
            }
        }
    }
    weak var delegate: Delegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDiffableDataSource()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.cancelCountrySelection()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        delegate?.doneCountrySelection()
    }
    
    // MARK: - Private methods

    private func subscribeToSnapshot(from viewModel: ViewModel?) {
        guard let viewModel else { return }
        viewModel.$dataSourceSnapshot
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            })
            .store(in: &cancellables)
    }
    
    private func unsubscribeFromSnapshot() {
        cancellables.removeAll()
    }
    
    private func configureDiffableDataSource() {
        dataSource = DataSource(tableView: tableView) { [weak viewModel] tableView, indexPath, itemID in
            guard let item = viewModel?.countryListItem(for: itemID) else { return nil }
            let result = tableView.dequeueReusableCell(withIdentifier: item.cellReuseIdentifier, for: indexPath)
            if let cell = result as? CountryListTableViewCell {
                cell.apply(item)
                cell.delegate = self
            }
            
            return result
        }
    }
}

extension CountryListTableViewController: ViewControllerStoryboardInstantiation {
    static var storyboardName: String {
        "Main"
    }
    
    static var storyboardID: String {
        "CountryListTableViewControllerStoryboardID"
    }
}

extension CountryListTableViewController: CountryListTableViewCell.Delegate {
    func addRemoveCountryDidClick(at cell: CountryListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
        let itemID = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel?.toogleSelection(for: itemID)
    }
}

extension CountryListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchText = searchText
    }
}
