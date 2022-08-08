//
//  ISSHomeViewController.swift
//  ISS_App
//
//  Created by Malkhasyan, Georgi on 8/8/22.
//

import UIKit
import MapKit

class ISSHomeViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    private var annotationPoint: MKPointAnnotation?
    private var issLocation: CLLocation?
    private var interval = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constraintSetup()
    }
    
    func constraintSetup() {
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        map.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        map.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    private func updateUI() {
        self.navigationItem.title = Constant.Common.issTitle
        
        view.addSubview(map)
    }
    
    private func setupMapView() {
        map.delegate = self
        annotationPoint = MKPointAnnotation()
        annotationPoint?.title = Constant.Common.issTitle
    }
    
    private func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: interval,
                             repeats: true) { [weak self] timer in
            self?.fetchSpaceStationPosition { [weak self] latitude, longitude  in
                if let lat = Double(latitude),
                   let lon = Double(longitude) {
                    self?.issLocation = CLLocation(latitude: lat, longitude: lon)
                }
            }
            self?.updateMapLocation()
        }
    }
    
    private func updateMapLocation() {
        guard let location = issLocation else {return}
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 4000000, longitudinalMeters: 4000000)
        
        guard let point = annotationPoint else { return }
        point.coordinate = coordinate
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.map.addAnnotation(point)
            self.map.setRegion(coordinateRegion, animated: true)
        })
    }
}

extension ISSHomeViewController: MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        if let latitude = issLocation?.coordinate.latitude, let longitude = issLocation?.coordinate.longitude {
            let currentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            return currentLocation
        }
        
        //Return default location
        let currentLocation = CLLocationCoordinate2D(latitude: 12.04777773, longitude: -84.4521356)
        return currentLocation
    }
}

extension ISSHomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constant.Common.issTitle)
        annotationView.markerTintColor = .blue
        annotationView.glyphImage = UIImage(named: "\(Constant.Common.issImageName)")
        
        return annotationView
    }
}
