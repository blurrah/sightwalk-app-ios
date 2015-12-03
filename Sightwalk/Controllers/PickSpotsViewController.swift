//
//  PickSpotsViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 02-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class PickSpotsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var sights = [Sight]();
    
    @IBOutlet var mapView: GMSMapView!
    let locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
            
            let sqlh = SQLiteHelper.sharedInstance
            sights = sqlh.getSights()!
            
            for sight in sights {
                let marker = GMSMarker(position: sight.location!)
                marker.title = sight.title
                marker.userData = sight.text
                marker.map = mapView
            }
            
            mapView.delegate = self
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }	
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        view.addSubview(NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindowView)
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
        super.viewDidAppear(animated)
        
        
    }

}
