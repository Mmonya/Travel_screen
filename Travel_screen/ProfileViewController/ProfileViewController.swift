//
//  ProfileViewController.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 12.06.2024.
//

import UIKit
import MapKit
import Combine

extension ProfileViewController {
    typealias ViewModel = ProfileViewModel
    
    private static let countryAnnotationViewClass = CountryAnnotationView.self
    private static let countryAnnotationViewReuseIdentifier = String(describing: countryAnnotationViewClass)
}

class ProfileViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var mapView: MKMapView!
    
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

        mapView.register(Self.countryAnnotationViewClass,
                         forAnnotationViewWithReuseIdentifier: Self.countryAnnotationViewReuseIdentifier)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        showProfileDetailViewController()
        super.viewIsAppearing(animated)
    }
    
    @IBAction func testAction(_ sender: Any) {
        
        centerMapOnCountry(regionIdentifier: "US")
    }
    
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//        
//    }
    
    // MARK: - Private methods
    
    private func subscribeToValues(from viewModel: ViewModel?) {
        guard let viewModel else { return }
        viewModel.$annotations
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                self?.updateMapAnnotations()
            })
            .store(in: &cancellables)
    }
    
    private func unsubscribeFromValues() {
        cancellables.removeAll()
    }
    
    private func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(viewModel?.annotations ?? [])
    }

    private func showProfileDetailViewController() {
        let viewControllerToPresent = ProfileDetailViewController.instantiateFromStoryboard()
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .threeQuarters()]
            sheet.largestUndimmedDetentIdentifier = .threeQuarters
        }
        viewControllerToPresent.viewModel = ViewModelsFactory.shared.profileDetailViewModel()
        viewControllerToPresent.isModalInPresentation = true
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    private func centerMapOnCountry(regionIdentifier: String) {
        let geocoder = CLGeocoder()
        
        // Використовуємо код країни для отримання місцезнаходження
        geocoder.geocodeAddressString(regionIdentifier) { [weak self] (placemarks, error) in
            guard let self else { return }
            guard error == nil, let placemark = placemarks?.first else {
                print("Помилка отримання місцезнаходження: \(String(describing: error))")
                return
            }
            
            // Отримання координат країни
            if let location = placemark.location {
                let coordinate = location.coordinate
                
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000000, longitudinalMeters: 10000000)
                
                mapView.setRegion(region, animated: true)
                
                //                    mapView.setVisibleMapRect(mapView.visibleMapRect,
                //                                              edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 500, right: 20),
                //                                              animated: true)
            }
        }
    }
    
    private func addAnnotation(at location: CLLocationCoordinate2D) {
        
    }
}

extension ProfileViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard nil != annotation as? CountryAnnotationView.Annotation else { return nil }
        
        return mapView.dequeueReusableAnnotationView(withIdentifier: Self.countryAnnotationViewReuseIdentifier,
                                                         for: annotation)
    }
}

//extension ProfileViewController: UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        SheetPresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}
//
//class SheetPresentationController: UISheetPresentationController {
//    override func containerViewWillLayoutSubviews() {
//        super.containerViewWillLayoutSubviews()
//        
////        self.additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 450, right: 0)
//
//    }
//}
