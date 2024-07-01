//
//  DistanceCalculationViewController.swift
//  Location
//
//  Created by E5000861 on 25/06/24.
//

import UIKit
import CoreLocation

class DistanceCalculationViewController: UIViewController {
    
    let startTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter start address"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let endTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter end address"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate Distance", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculateDistance), for: .touchUpInside)
        return button
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Distance: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(startTextField)
        view.addSubview(endTextField)
        view.addSubview(calculateButton)
        view.addSubview(distanceLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            startTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            startTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            endTextField.topAnchor.constraint(equalTo: startTextField.bottomAnchor, constant: 20),
            endTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            endTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            calculateButton.topAnchor.constraint(equalTo: endTextField.bottomAnchor, constant: 20),
            calculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func calculateDistance() {
        guard let startAddress = startTextField.text, let endAddress = endTextField.text else { return }
        geocodeAddresses(start: startAddress, end: endAddress)
    }
    
    func geocodeAddresses(start: String, end: String) {
        geocoder.geocodeAddressString(start) { (startPlacemarks, error) in
            guard let startPlacemark = startPlacemarks?.first, let startLocation = startPlacemark.location else { return }
            self.geocoder.geocodeAddressString(end) { (endPlacemarks, error) in
                guard let endPlacemark = endPlacemarks?.first, let endLocation = endPlacemark.location else { return }
                let distance = startLocation.distance(from: endLocation)
                self.distanceLabel.text = "Distance: \(distance / 1000) km"
                self.openGoogleMaps(from: startLocation.coordinate, to: endLocation.coordinate)
            }
        }
    }
    
    func openGoogleMaps(from startCoordinate: CLLocationCoordinate2D, to endCoordinate: CLLocationCoordinate2D) {
        let googleURL = "comgooglemaps://?saddr=\(startCoordinate.latitude),\(startCoordinate.longitude)&daddr=\(endCoordinate.latitude),\(endCoordinate.longitude)&directionsmode=driving"
        
        if let url = URL(string: googleURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Google Maps is not installed on this device.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


