//
//  SightSyncer.swift
//  Sightwalk
//
//  Created by frank kuipers on 12/17/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SightSyncer: NSObject, CLLocationManagerDelegate {

    private var client : SightSyncInterface
    
    private let locationManager = CLLocationManager()
    
    init(client : SightSyncInterface) {
        self.client = client
        
        super.init()
        setupGpsPolling()
    }
    
    private func setupGpsPolling() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location : CLLocation = locations.first!

        getSightsFromServer(location.coordinate)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("nou nee")
    }
    
    private func getSightsFromServer(coordinates: CLLocationCoordinate2D) {
        getSightsFromServer(coordinates.latitude.description, longitude: coordinates.longitude.description)
    }

    private func getSightsFromServer(latitude : String, longitude : String) {
        print("http://kuipers.solutions:3000\(ServerConstants.Sight.getInRange)\(latitude)/\(longitude)/10")
        
        
        LoginPersistenceHelper.SharedInstance.accessToken({ token in
            
            let URL = NSURL(string: "http://kuipers.solutions:3000")!
            let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(ServerConstants.Sight.getInRange + "/" + latitude + "/" + longitude + "/10"))
            
            let manager = Manager.sharedInstance
            
            manager.session.configuration.HTTPAdditionalHeaders = [
            "AuthToken": token
            ]
            
            
            print(token)
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authtoken": token]
            
            
            //Alamofire.request(.GET, "\(ServerConstants.address)\(ServerConstants.Sight.getInRange)")
            Alamofire.request(.GET, URLRequest)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .Success:
                        let jsonResponse = JSON(response.result.value!)
                        
                        let success = jsonResponse["success"].bool!
                        
                        guard success == true else {
                            
                            return
                        }
                        
                        let token = jsonResponse["token"].string!
                        
                    case .Failure(let error):
                        print("Could not read sights from server")
                    }
                })
        })
        
        
    }

}

protocol SightSyncInterface {
    func getAllSights() -> [Sight]
    func triggerRemoveSight(sight : Sight)
    func triggerAddSight(sight : Sight)
}