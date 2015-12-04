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
    
    var sights = [Sight]();
    var userChosen = [Sight]();
    
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
        infoView.hidden = true

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
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        infoButton.setTitle("Toevoegen", forState: .Normal)
        infoButton.backgroundColor = UIColor(red:0.16862745100000001, green:0.7725490196, blue:0.36862745099999999, alpha:1)
        if ((userChosen.filter() { $0.title != marker.title }.count) != userChosen.count) {
            infoButton.setTitle("Verwijderen", forState: .Normal)
            infoButton.backgroundColor = UIColor.redColor()
        }
        chosenMarker = marker
        Alamofire.request(.GET, marker.imageurl!).response {
            (req, res, data, error) in
            if error == nil {
                let image = UIImage(data: data!)
                infoImage.image = image
            }
        }
        infoName.text = marker.title
        infoText.text = marker.userData.string
        infoView.hidden = false
        return true
    }
    
    @IBAction func addSight(sender: AnyObject) {
        if ((userChosen.filter() { $0.title != chosenMarker.title }.count) != userChosen.count) {
            userChosen = userChosen.filter() { $0.title != chosenMarker.title }
            chosenMarker.icon = nil
            infoView.hidden = true
        } else {
            let sight = Sight();
            sight.title = chosenMarker.title
            sight.name = chosenMarker.title
            sight.location = chosenMarker.position
            chosenMarker.icon = GMSMarker.markerImageWithColor(UIColor(red:0.16862745100000001, green:0.7725490196, blue:0.36862745099999999, alpha:1))
            userChosen.append(sight)
            infoView.hidden = true
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
