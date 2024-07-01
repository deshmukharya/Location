//
//  ViewController.swift
//  Location
//
//  Created by E5000861 on 24/06/24.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController{
    
    
    var locationManager : CLLocationManager!
    var gecoder:CLGeocoder!
    var userLocation = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        gecoder = CLGeocoder()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        // Do any additional setup after loading the view.

       
    }
    
  
   
}

extension ViewController : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           switch manager.authorizationStatus {
           case .denied: // Setting option: Never
               print("LocationManager didChangeAuthorization denied")
           case .notDetermined: // Setting option: Ask Next Time
               print("LocationManager didChangeAuthorization notDetermined")
           case .authorizedWhenInUse: // Setting option: While Using the App
               print("LocationManager didChangeAuthorization authorizedWhenInUse")
           case .authorizedAlways: // Setting option: Always
               print("LocationManager didChangeAuthorization authorizedAlways")
           case .restricted: // Restricted by parental control
               print("LocationManager didChangeAuthorization restricted")
           default:
               print("LocationManager didChangeAuthorization")
           }
       }
       //Handle the location information
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           print("locations:\(locations)")
           if let location = locations.first{
               print("altitude: \(location.altitude)")
               print("floor level: \(location.floor?.level)")
               print("horizontalAccuracy: \(location.horizontalAccuracy)")
               print("verticalAccuracy: \(location.verticalAccuracy)")
               print("speedAccuracy: \(location.speedAccuracy)")
               print("speed: \(location.speed)")
               print("timestamp: \(location.timestamp)")
               print("courseAccuracy: \(location.courseAccuracy)")
               print("course: \(location.course)")
           }
       }
       //Invoked when an error has occurred
 
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("error:\(error)")
       }
     
   
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("newHeading\(newHeading)")
    }
    
    func getAddressByLatLong(latitude:CLLocationDegrees,long:CLLocationDegrees) {
        var location = CLLocation(latitude: latitude, longitude: long)
        gecoder.reverseGeocodeLocation(location) {(parameters, error) in
            if let error = error {
                print(error.localizedDescription)
            }else if let address = parameters?.first {
                print("\(address.locality ?? "") , \(address.postalCode) , \(address.country)")
            }
        }
    }
    
    @IBAction func traceDirection(_ sender: Any) {
        var coordinates = CLLocationCoordinate2D(latitude: 22.593845, longitude:88.385784)
        presentActionSheet(coordinate: coordinates)
    }
//latitude: 22.593845, longitude: 88.385784
    func presentActionSheet(coordinate: CLLocationCoordinate2D){
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        
        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alert = UIAlertController(title: nil,
                                      message: "Choose application",
                                      preferredStyle: .actionSheet)
        alert.addAction(cancel)
        self.present(alert, animated: false, completion: nil)
    }
    private static func openMap(app: (String, URL)) {
        guard UIApplication.shared.canOpenURL(app.1) else {
            debugPrint("Unable to open the map.")
            return
        }
        UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
    }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("LocationManager didExitRegion \(region)")
     }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("LocationManager didExitRegion \(region)")
     }
   
  

