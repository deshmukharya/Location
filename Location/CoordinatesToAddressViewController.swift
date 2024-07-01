//
//  CoordinatesToAddressViewController.swift
//  Location
//
//  Created by E5000861 on 25/06/24.
//

import UIKit
import MapKit
import CoreLocation

class CoordinatesToAddressViewController: UIViewController {
    
    let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter latitude"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter longitude"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let convertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Convert", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(convertCoordinates), for: .touchUpInside)
        return button
    }()
    
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeTextField)
        view.addSubview(convertButton)
        view.addSubview(mapView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            latitudeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            latitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            latitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            longitudeTextField.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 20),
            longitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            longitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            convertButton.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 20),
            convertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mapView.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func convertCoordinates() {
        guard let latText = latitudeTextField.text, let lonText = longitudeTextField.text, let latitude = Double(latText), let longitude = Double(lonText) else { return }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        reverseGeocodeLocation(location: location)
    }
    
    func reverseGeocodeLocation(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            if let address = placemark.name {
                print("Address: \(address)")
                self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
            }
        }
    }
}

