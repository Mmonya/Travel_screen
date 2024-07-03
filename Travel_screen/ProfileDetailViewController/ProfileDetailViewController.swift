//
//  ProfileDetailViewController.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 12.06.2024.
//

import UIKit
import Combine

extension ProfileDetailViewController {
    private static let countryListTableViewControllerSegueIdentifier = "ProfileCountryListTableViewControllerSegueIdentifier"
    typealias ViewModel = ProfileDetailViewModel
}

class ProfileDetailViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private var isProfileEditing = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var viewModel: ViewModel? {
        didSet {
            if oldValue !== viewModel {
                unsubscribeFromValues()
                subscribeToValues(from: viewModel)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.countryListTableViewControllerSegueIdentifier,
           let controller = segue.destination as? ProfileCountryListTableViewController {
            controller.viewModel = ViewModelsFactory.shared.profileCountryListTableViewModel()
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
        isProfileEditing.toggle()
        nameTextField.isEnabled = isProfileEditing
        descriptionTextView.isEditable = isProfileEditing
        if isProfileEditing {
            nameTextField.becomeFirstResponder()
        } else {
            nameTextField.resignFirstResponder()
            descriptionTextView.resignFirstResponder()
        }
    }
    
    
    // MARK: - Private methods
    
    private func setupUI() {
//        descriptionTextView.textContainer.maximumNumberOfLines = Self.maximumNumberOfLinesForDescription
//        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        descriptionTextView.textContainer.heightTracksTextView = true
        descriptionTextView.textContainer.lineFragmentPadding = 0
    }
    
    private func subscribeToValues(from viewModel: ViewModel?) {
        guard let viewModel else { return }
        viewModel.$name
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                self?.updateNameUI()
            })
            .store(in: &cancellables)

        viewModel.$description
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                self?.updateDescriptionUI()
            })
            .store(in: &cancellables)
    }
    
    private func unsubscribeFromValues() {
        cancellables.removeAll()
    }
    
    private func updateNameUI() {
        nameTextField.text = viewModel?.name
    }
    
    private func updateDescriptionUI() {
        descriptionTextView.text = viewModel?.description
    }
}

extension ProfileDetailViewController: ViewControllerStoryboardInstantiation {
    static var storyboardName: String {
        "Main"
    }
    static var storyboardID: String {
        "ProfileDetailViewControllerStoryboardID"
    }
}

extension ProfileDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel?.description = textView.text
    }
}

extension ProfileDetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.name = textField.text ?? ""
    }
}
