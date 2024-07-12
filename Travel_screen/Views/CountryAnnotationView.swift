//
//  CountryAnnotationView.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 08.07.2024.
//

import MapKit

extension CountryAnnotationView {
    protocol Annotation: MKAnnotation {
        var flag: String { get }
        var checked: Bool { get }
    }
}

class CountryAnnotationView: MKAnnotationView {
    private var pinView: CountryPinView!
    override var annotation: (any MKAnnotation)? {
        didSet { updateUI() }
    }

    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func updateUI() {
        guard let annotation = annotation as? Annotation else { return }
        pinView.flag = annotation.flag
        pinView.checked = annotation.checked
    }
    
    private func setupUI() {
        let view = CountryPinView.instantiateFromNib()
        view.translatesAutoresizingMaskIntoConstraints = true
        frame.size = view.frame.size
        addSubview(view)
        pinView = view
        
        backgroundColor = .clear
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }
}
