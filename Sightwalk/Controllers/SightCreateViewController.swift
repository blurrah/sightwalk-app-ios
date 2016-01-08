//
//  SightCreateViewController.swift
//  Sightwalk
//
//  Created by frank kuipers on 1/7/16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import UIKit
import JLToast

class SightCreateViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBAction func btnSave(sender: AnyObject) {
        if coordinates == nil {
            toastError("Selecteer een punt op de kaart")
            return
        }
        
        let name : String? = tfName.text
        let description : String? = tvDescription.text
        if name == nil || name!.characters.count == 0 {
            toastError("Voer een naam in")
            return
        }
        
        if description == nil || description!.characters.count == 0 {
            toastError("Voer een beschrijving in")
            return
        }
        
        // done checking, create sight!
        storeSight()
    }
    @IBAction func btnCloseClick(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToAddSights", sender: self)
    }
    
    @IBOutlet var mvCoordinateSelect: GMSMapView!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tvDescription: UITextView!
    
    private var coordinates : CLLocationCoordinate2D?
    private var marker : GMSMarker?
    private let locationManager = CLLocationManager()
    private var tapped : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mvCoordinateSelect.delegate = self
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        tapped = true
        
        // update coordinates
        updateMarker(coordinate)
    }
    
    private func updateMarker(coordinate : CLLocationCoordinate2D) {
        coordinates = coordinate
        if marker != nil {
            // remove old marker from map
            marker!.map = nil
            marker = nil
        }
        
        // add new marker
        marker = GMSMarker(position: coordinate)
        marker!.title = "Geselecteerde positie"
        marker!.map = mvCoordinateSelect
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
            mvCoordinateSelect.myLocationEnabled = true
            mvCoordinateSelect.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !tapped {
            if manager.location != nil {
                updateMarker(manager.location!.coordinate)
            }
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    private func toastError(text : String) {
        toastColor(text, color : UIColor.redColor())
    }
    
    private func toastSuccess(text : String) {
        toastColor(text, color : UIColor(red:0.102, green:0.788, blue:0.341, alpha:1))
    }
    
    private func toastColor(text : String, color : UIColor) {
        JLToastView.setDefaultValue(color,
            forAttributeName: JLToastViewBackgroundColorAttributeName,
            userInterfaceIdiom: .Phone)
        JLToast.makeText(text, delay: 0, duration: 2).show()
    }
    
    private func storeSight() {
        let path : String = ServerConstants.Sight.store
        
        var params : [String : NSObject] = [String : NSObject]()
        params["longitude"] = coordinates!.longitude
        params["latitude"] = coordinates!.latitude
        params["precision"] = 1
        params["name"] = tfName.text!
        params["type"] = "monument" // todo
        let desc : NSString = tvDescription.text!
        params["short_description"] = (desc.length > 100) ? desc.substringWithRange(NSRange(location: 0, length: 100)) : desc
        params["image_url"] = "https://pbs.twimg.com/profile_images/588458393444167680/jqP97Xwo.jpg"
        params["desription"] = desc
        params["external_photo"] = "https://pbs.twimg.com/profile_images/588458393444167680/jqP97Xwo.jpg"
        
        
        UserAPIHelper.sharedInstance.getAuthenticatedCall(path, method: .POST, parameters: params, success: { json in
            self.toastSuccess("De sight is aangemaakt!")
            self.performSegueWithIdentifier("unwindToAddSights", sender: self)
        }, failure: { error in
            print("failed")
            print(error)
            self.toastError("Er trad een fout op")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
