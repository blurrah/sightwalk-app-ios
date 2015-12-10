//
//  PickSpotsViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 02-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import Alamofire

class PickSpotsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    let sightStore = SightStore.sharedInstance
    
    var sights = SightStore.sharedInstance.sights
    
    @IBOutlet var infoButton: GenericViewButton!
    @IBOutlet var infoText: UILabel!
    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var infoName: UILabel!
    @IBOutlet var infoView: UIView!
    @IBOutlet var mapView: GMSMapView!
    var chosenMarker: GMSMarker!
    let locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.alpha = 0

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
                let marker = GMSMarker(position: sight.location)
                marker.title = sight.title
                marker.snippet = String(sight.id)
                marker.userData = sight.text
                marker.map = mapView
            }
            
            mapView.delegate = self
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(51.571915, 4.768323), zoom: 10, bearing: 0, viewingAngle: 0)
        }
    }	
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }
    }
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        let sightId = sights.indexOf() { $0.id == Int(marker.snippet) }
        
        infoButton.setTitle("Toevoegen", forState: .Normal)
        infoButton.backgroundColor = UIColor(red:0.16862745100000001, green:0.7725490196, blue:0.36862745099999999, alpha:1)
        if sights[sightId!].chosen {
            infoButton.setTitle("Verwijderen", forState: .Normal)
            infoButton.backgroundColor = UIColor.redColor()
        }
        chosenMarker = marker
       
        infoName.text = marker.title
        infoText.text = marker.userData.string
        UIView.animateWithDuration(0.5, animations: {
            self.infoView.alpha = 1
        })
        return true
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        UIView.animateWithDuration(0.5, animations: {
            self.infoView.alpha = 0
        })
    }
    
    @IBAction func addSight(sender: AnyObject) {
        
        let sightId = sights.indexOf() { $0.id == Int(chosenMarker.snippet) }
        
        if sights[sightId!].chosen {
            sights[sightId!].changeState()
            
            chosenMarker.icon = nil
            UIView.animateWithDuration(0.5, animations: {
                self.infoView.alpha = 0
            })
        } else {
            sights[sightId!].changePriority(sightStore.userPriority)
            sightStore.userPriority++
            sights[sightId!].changeState()
            
            chosenMarker.icon = GMSMarker.markerImageWithColor(UIColor(red:0.16862745100000001, green:0.7725490196, blue:0.36862745099999999, alpha:1))
            UIView.animateWithDuration(0.5, animations: {
                self.infoView.alpha = 0
            })
        }
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
