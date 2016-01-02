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
    let imageDownloader = ImageDownloadHelper()
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
    
    let colorGreen : UIColor = UIColor(red:0.16862745100000001, green:0.7725490196, blue:0.36862745099999999, alpha:1)
    let colorYellow : UIColor = UIColor(red:1, green:1, blue:0, alpha:1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sightStore.subscribe(self, slot: "spotpicker")
        
        infoView.alpha = 0

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
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
        
        if (sightStore.isFavorite(sight) && !sightStore.isSelected(sight)) {
            marker.icon = GMSMarker.markerImageWithColor(colorYellow)
        }
        if sightStore.isSelected(sight) {
            marker.icon = GMSMarker.markerImageWithColor(colorGreen)
        }
        
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
            //TODO: Set button image as FILLED STAR. Below is temp color set
            favoriteButton.titleLabel?.textColor = UIColor.yellowColor()
        } else {
            //TODO: Set button image as EMPTY STAR. Below is temp color set
            favoriteButton.titleLabel?.textColor = UIColor.grayColor()
        }
 
        if (sightStore.isSelected(sight)) {
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
        
        imageDownloader.downloadImage(sight.imgurl, onCompletion: { response in
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
        let newSelected : Bool = !sightStore.isSelected(sight)
        sightStore.markSightSelected(sight, selected: newSelected)
        chosenMarker.icon = (newSelected) ? GMSMarker.markerImageWithColor(colorGreen) : nil
        
        // fade out bottom bar
        UIView.animateWithDuration(0.2, animations: {
            self.infoView.alpha = 0
        })
    }
    
    @IBAction func addFavorite(sender: AnyObject) {
        let sight = getSightByMarker(chosenMarker)
        let newFavorite : Bool = !sightStore.isFavorite(sight)
        sightStore.markSightAsFavorite(sight, favorite: newFavorite)
        if (!sightStore.isSelected(sight)) {
            chosenMarker.icon = (newFavorite) ? GMSMarker.markerImageWithColor(colorYellow) : nil
        }
        print(newFavorite)
        if newFavorite {
            //TODO: Set button image as FILLED STAR. Below is temp color set
            favoriteButton.backgroundColor = colorYellow
        } else {
            //TODO: Set button image as EMPTY STAR. Below is temp color set
            favoriteButton.backgroundColor = UIColor.grayColor()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

    
    
}
