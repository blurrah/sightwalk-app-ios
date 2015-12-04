//
//  GoogleDirectionsAPIHelper.swift
//  Sightwalk
//
//  Created by Boris Besemer on 03-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Marker {
    let name: String!
    let lat: Double!
    let lon: Double!
    let userPrio: Int!
    
    init(name: String, lat: Double, lon: Double, userPrio: Int) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.userPrio = userPrio
    }
}


struct Directions {
    let name = "directions"
}


class GoogleDirectionsAPIHelper {
    class var sharedInstance: GoogleDirectionsAPIHelper {
        struct Singleton {
            static let instance = GoogleDirectionsAPIHelper()
        }
        return Singleton.instance
    }
    
    let key = GoogleConstants.key
    
    func getDirections(origin: String, markers: [Marker], onCompletion: JSON -> ()) {
        let waypointsString = self.generateMarkerParameters(markers)
        
        let urlParameters = [
            "origin": origin,
            "destination": origin,
            "waypoints": waypointsString,
            "mode": "walking",
            "language": "nl-NL",
            "key": key
        ]
        
        Alamofire.request(.GET, GoogleConstants.Directions.url, encoding: .JSON, headers: urlParameters)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .Success:
                let jsonResponse = JSON(response.result.value!)
                
                onCompletion(jsonResponse)
                break
            case .Failure:
                print("gefaald!")
                break
            }
        })
    }
    
    private func generateMarkerParameters(markers: [Marker]) -> String {
        let joinCharacter = "|"
        var markerStrings = [String]()
        
        for item in markers {
            let lon = "\(item.lon)"
            let lat = "\(item.lat)"
            markerStrings.append("\(lon),\(lat)")
        }
        
        let result = markerStrings.joinWithSeparator(joinCharacter)
        
        return result
    }
}