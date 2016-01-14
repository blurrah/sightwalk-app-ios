//
//  PickSpotsViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 02-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import Alamofire

class PickSpotsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, SightManager {
    let sightStore = SightStore.sharedInstance
    
    var markers = [Sight: GMSMarker]()
    
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var infoButton: GenericViewButton!
    @IBOutlet var infoText: UILabel!
    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var infoName: UILabel!
    @IBOutlet var infoView: UIView!
    @IBOutlet var mapView: GMSMapView!
    var chosenMarker: GMSMarker!
    let locationManager: CLLocationManager = CLLocationManager()
    
    let colorGreen : UIColor = UIColor(red:0.102, green:0.788, blue:0.341, alpha:1)
    let colorYellow : UIColor = UIColor(red:1, green:1, blue:0, alpha:1)
    
    let star_unchecked = UIImage(named: "favorite_star_unchecked")! as UIImage
    let star_checked = UIImage(named: "favorite_star")! as UIImage
    
    private var activity : Activity?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sightStore.subscribe(self, slot: "spotpicker")
        
        infoView.alpha = 0

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setActivity(activity : Activity) {
        self.activity = activity
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
            
            sightStore.getAll(self)
            
            mapView.delegate = self
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(51.571915, 4.768323), zoom: 11.5, bearing: 0, viewingAngle: 0)
        }
    }
    
    func addSight(sight : Sight) {
        let marker = GMSMarker(position: sight.location)
        marker.title = sight.title
        marker.snippet = String(sight.id)
        marker.userData = sight.shortdesc
        marker.map = mapView
        marker.icon = getSightColor(sight)
        markers[sight] = marker
    }
    
    func removeSight(sight : Sight) {
        if let marker : GMSMarker = markers[sight] {
            marker.map = nil
            markers.removeValueForKey(sight)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let _ = locations.first {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {

        let sight = getSightByMarker(marker)
        
        if (sightStore.isFavorite(sight)) {
            favoriteButton.setImage(star_checked, forState: .Normal)
        } else {
            favoriteButton.setImage(star_unchecked, forState: .Normal)
        }
 
        if (activity!.isSelected(sight)) {
            infoButton.setTitle("-", forState: .Normal)
            infoButton.backgroundColor = UIColor.redColor()
        } else {
            infoButton.setTitle("+", forState: .Normal)
            infoButton.backgroundColor = colorGreen
        }
        
        infoButton.layer.borderColor = infoButton.backgroundColor!.CGColor
        
        chosenMarker = marker
       
        infoName.text = marker.title
        infoText.text = sight.shortdesc

        let camera = GMSCameraPosition(target: marker.position, zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.animateToCameraPosition(camera)
        
        ImageDownloadHelper.downloadImage(sight.imgurl, onCompletion: { response in
            self.infoImage.image = UIImage(data: response)
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.infoView.alpha = 1
        })
        
        return true
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        UIView.animateWithDuration(0.2, animations: {
            self.infoView.alpha = 0
        })
    }
    
    @IBAction func addSight(sender: AnyObject) {
        let sight = getSightByMarker(chosenMarker)
        
        // toggle selection of sight
        let newSelected : Bool = !activity!.isSelected(sight)
        activity!.markSightSelected(sight, selected: newSelected)
        chosenMarker.icon = getSightColor(sight)
        
        // fade out bottom bar
        UIView.animateWithDuration(0.2, animations: {
            self.infoView.alpha = 0
        })
    }
    
    @IBAction func tapAddSight(sender: AnyObject) {
        // Start een segue hier
        self.performSegueWithIdentifier("gotoAddSight", sender: nil)
    }
    
    @IBAction func addFavorite(sender: AnyObject) {
        let sight = getSightByMarker(chosenMarker)
        let newFavorite : Bool = !sightStore.isFavorite(sight)
        sightStore.markSightAsFavorite(sight, favorite: newFavorite)
        chosenMarker.icon = getSightColor(sight)
        
        if newFavorite {
            favoriteButton.setImage(star_checked, forState: .Normal)
        } else {
            favoriteButton.setImage(star_unchecked, forState: .Normal)
        }
    }

    func updateSight(oldSight: Sight, newSight: Sight) {
        removeSight(oldSight)
        addSight(newSight)
    }

    private func getSightByMarker(marker : GMSMarker) -> Sight {
        let (sight, _) = markers.filter() { $0.1 == marker }.first!
        return sight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSightColor(sight: Sight) -> UIImage {
        if (activity!.isSelected(sight)) {
            return GMSMarker.markerImageWithColor(colorGreen)
        } else if (sightStore.isFavorite(sight)) {
            return GMSMarker.markerImageWithColor(colorYellow)
        } else if (sightStore.isVisited(sight)) {
            return GMSMarker.markerImageWithColor(UIColor.blueColor())
        } else {
            return GMSMarker.markerImageWithColor(nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
    }
}
