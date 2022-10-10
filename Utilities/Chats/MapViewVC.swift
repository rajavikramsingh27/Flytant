//
//  MapViewVC.swift
//  Flytant
//
//  Created by Vivek Rai on 12/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import MapKit

class MapViewVC: UIViewController {

    var location: CLLocation!
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = true
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsBuildings = true
        mapView.showsTraffic = true
        mapView.showsUserLocation = true
        return mapView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()
        setLocationOnMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Location"
        createRightBarButton()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
       
    }
    
    private func configureMapView(){
        view.addSubview(mapView)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    private func setLocationOnMapView(){
        var region = MKCoordinateRegion()
        region.center.latitude = location.coordinate.latitude
        region.center.longitude = location.coordinate.longitude
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    
    private func createRightBarButton(){
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Open in Maps", style: .done, target: self, action: #selector(openInMaps))]
    }
   
    @objc private func openInMaps(){
        let regionDistance: CLLocationDistance = 10000
        let coordinate = location.coordinate
        let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = "User's Location"
        mapItem.openInMaps(launchOptions: options)
    }

}
