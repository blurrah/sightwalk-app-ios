//
//  RouteMapViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 15-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class RouteMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet private var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    private var currentStep : Int = 0
    private var activity : Activity?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setActivity(activity : Activity) {
        self.activity = activity
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        mapView.delegate = self
        
        for sight in activity!.getSights() {
            let marker = GMSMarker(position: sight.location)
            marker.title = sight.title
            marker.snippet = String(sight.id)
            marker.userData = sight.shortdesc
            marker.icon = GMSMarker.markerImageWithColor(UIColor(red:0.102, green:0.788, blue:0.341, alpha:1))
            marker.map = mapView
        }
        addPolylines()
        
    }
    
    func updateSight(newStep: Int) {
        self.currentStep = newStep
        self.addPolylines()
    }
    
    func addPolylines() {
        for (index, steps) in activity!.getPolylines() {
            for step in steps {
                let path = GMSPath(fromEncodedPath: step)
                let polyline = GMSPolyline(path: path)
                
                if index == self.currentStep {
                    polyline.strokeColor = UIColor.blueColor()
                } else {
                    polyline.strokeColor = UIColor.grayColor()
                }
                
                polyline.strokeWidth = 4.0
                polyline.map = mapView
                mapView.camera = GMSCameraPosition(target: path.coordinateAtIndex(0), zoom: 15, bearing: 0, viewingAngle: 0)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        return true
    }
    
    func center(coordinates : CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.cameraWithTarget(coordinates, zoom: mapView.camera.zoom)
        mapView.animateToCameraPosition(camera)
    }

}
