//
//  RouteMapViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 15-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class RouteMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: GMSMapView!
    let chosenSights = SightStore.sharedInstance.userChosen
    let locationManager = CLLocationManager()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        mapView.delegate = self
        
        for sight in chosenSights {
            let marker = GMSMarker(position: sight.location)
            marker.title = sight.title
            marker.snippet = String(sight.id)
            marker.userData = sight.shortdesc
            marker.icon = GMSMarker.markerImageWithColor(UIColor(red:0.16862745100000001, green:0.7725490196, blue:0.36862745099999999, alpha:1))
            marker.map = mapView
        }
        
        let path = GMSPath(fromEncodedPath: RouteStore.sharedInstance.chosenRoute!)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        let startGreen = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        let redYellow = GMSStrokeStyle.gradientFromColor(startGreen, toColor:UIColor.redColor())
        polyline.spans = [GMSStyleSpan(style: GMSStrokeStyle.solidColor(startGreen)),
            GMSStyleSpan(style: GMSStrokeStyle.solidColor(UIColor.yellowColor())),
            GMSStyleSpan(style: redYellow)]
        
        polyline.map = mapView
        
        mapView.camera = GMSCameraPosition(target: path.coordinateAtIndex(0), zoom: 15, bearing: 0, viewingAngle: 0)

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

}
