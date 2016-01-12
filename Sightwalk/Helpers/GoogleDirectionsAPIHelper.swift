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

class GoogleDirectionsAPIHelper {
    class var sharedInstance: GoogleDirectionsAPIHelper {
        struct Singleton {
            static let instance = GoogleDirectionsAPIHelper()
        }
        return Singleton.instance
    }
    
    let key = GoogleConstants.webKey
    
    func getDirections(origin: String, destination: String, sights: [Sight], onCompletion: JSON -> ()) {
        let waypointsString = self.generateSightParameters(sights)
        
        let urlParameters = [
            "origin": origin,
            "waypoints": waypointsString,
            "destination": destination,
            "mode": "walking",
            "language": "nl-NL",
            "key": key
        ]
        
        Alamofire.request(.GET, GoogleConstants.Directions.url, parameters: urlParameters)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .Success:
                print("GoogleDirections API Request: success!")
                let jsonResponse = JSON(response.result.value!)
                
                print(response.result.value!)
                print(jsonResponse.rawString()!)
 
                
                let string = jsonResponse.rawString()!
                let trimmed = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                print(trimmed)
                
                let oj = JSON(jsonResponse.rawString()!)
                print(oj.rawString()!)

                onCompletion(jsonResponse)
                break
            case .Failure:
                print(response.request)
                print("gefaald!")
                break
            }
        })
    }
    
    private func generateSightParameters(sights: [Sight]) -> String {
        let joinCharacter = "|"
        var markerStrings = [String]()
        
        for item in sights {
            let position = item.location
            let lat = "\(position.latitude)"
            let lon = "\(position.longitude)"
            markerStrings.append("\(lat),\(lon)")
        }
        
        let result = markerStrings.joinWithSeparator(joinCharacter)
        
        return result
    }
}