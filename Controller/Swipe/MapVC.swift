//
//  MapVC.swift
//  Flytant
//
//  Created by Vivek Rai on 29/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapVC: UIViewController, MKMapViewDelegate {
    
//    MARK: - Properties
    
    var users = [Users]()
    var currentTransportType = MKDirectionsTransportType.automobile
    var currentRoute: MKRoute?
    
//    MARK: - Views
    
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

    let backButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.systemFont(ofSize: 12))

    let segmentedControl = UISegmentedControl(items: ["Car", "Walking"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureBackButton()
        configureSegmentedControl()
        addAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
//    MARK: - Configure Views
    
    private func configureMapView(){
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func configureBackButton(){
        view.addSubview(backButton)
        backButton.setImage(UIImage(named: "backButtonIcon"), for: .normal)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 28)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
    }
    
    private func configureSegmentedControl(){
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 128, height: 32)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        segmentedControl.backgroundColor = UIColor.secondarySystemBackground
        segmentedControl.layer.cornerRadius = 5
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControl(coordinate:)), for: .valueChanged)
        segmentedControl.isHidden = true
    }
    
    private func addAnnotations(){
        var nearByAnnotations = [MKAnnotation]()
        for user in users{
            let geoPoint = user.geoPoint
            let location = CLLocation(latitude: geoPoint?.latitude ?? 0, longitude: geoPoint?.longitude ?? 0)
            let annotation = UserAnnotations()
            annotation.title = user.username
            if let dob = user.dateOfBirth{
                annotation.subtitle = "\(calculateAge(dob: dob)) yrs"
            }
            if let gender = user.gender{
                annotation.gender = gender
            }
            if let profileImageURL = user.profileImageURL{
                guard let url = URL(string: profileImageURL) else {return}
                let data = try? Data(contentsOf: url)
                  annotation.profileImage = UIImage(data: data!)
            }
            annotation.coordinate = location.coordinate
            nearByAnnotations.append(annotation)
        }
        self.mapView.showAnnotations(nearByAnnotations, animated: true)
    }
    
    private func calculateAge(dob: String) -> Int{
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        if let date = dateformatter.date(from: dob ){
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.year], from: date, to: Date())
            return components.year ?? 20
        }else{
            return 20
        }
    }

    
//    MARK: - MapView Delegates
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        var annotationView: MKAnnotationView?

        // reuse the annotation if possible

        if annotation.isKind(of: MKUserLocation.self) {
            //annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            //annotationView?.image = UIImage(named: "icon-user")
        } else if let deqAno = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = deqAno
            annotationView?.annotation = annotation
        } else {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annoView.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
            annotationView = annoView
        }

        if let annotationView = annotationView, let anno = annotation as? UserAnnotations {
            annotationView.canShowCallout = true

            let image = anno.profileImage
            let resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            resizeRenderImageView.layer.cornerRadius = 25
            resizeRenderImageView.clipsToBounds = true
            resizeRenderImageView.contentMode = .scaleAspectFill
            resizeRenderImageView.image = image

            UIGraphicsBeginImageContextWithOptions(resizeRenderImageView.frame.size, false, 0.0)
            resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            annotationView.image = thumbnail

            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "mapDirectionIcon"), for: UIControl.State.normal)
            annotationView.rightCalloutAccessoryView = btn

            let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            if let gender = anno.gender {
                if gender == "Male"{
                    leftIconView.image = UIImage(named: "maleIcon")
                }else if gender == "Female"{
                    leftIconView.image = UIImage(named: "femaleIcon")
                }else{
                    leftIconView.image = UIImage(named: "bothIcon")
                }
            }
            annotationView.leftCalloutAccessoryView = leftIconView
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let coordinate = view.annotation?.coordinate{
            handleSegmentedControl(coordinate: coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .automobile) ? UIColor(red: 246/255, green: 101/255, blue: 11/255, alpha: 1) : UIColor.orange
        renderer.lineWidth = 3.0
        return renderer
    }
    
//    MARK: - Handlers
    
    @objc private func handleBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleSegmentedControl(coordinate: CLLocationCoordinate2D){
        switch segmentedControl.selectedSegmentIndex {
        case 0: self.currentTransportType = .automobile
        case 1: self.currentTransportType = .walking
        default: break
        }
        segmentedControl.isHidden = false
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(coordinate: coordinate)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransportType
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (routeResponse, error) in
            guard let routeResponse = routeResponse else {
                if let error = error {
                    debugPrint("Error :\(error.localizedDescription)")
                }
                return
            }
            
            let route = routeResponse.routes[0]
            self.currentRoute = route
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            
            self.mapView.setRegion(MKCoordinateRegion.init(rect), animated: true)
        }
    }
}
