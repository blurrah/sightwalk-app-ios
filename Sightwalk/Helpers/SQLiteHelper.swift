//
//  SQLiteHelper.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 03/12/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import MapKit

class SQLiteHelper: NSObject {
    
    static let sharedInstance = SQLiteHelper()
    var db : COpaquePointer = nil
    
    override init() {
        let path = NSBundle.mainBundle().pathForResource("sights", ofType: "sqlite");
        if sqlite3_open(path!, &db) != SQLITE_OK {
            print("Error opening database!")
        }
    }
    
    func getSights() -> [Sight]? {
        let query = "SELECT * FROM sights ORDER BY name ASC"
        // Prepare query and execute
        var statement : COpaquePointer = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("Error in query: \(errmsg)!")
            return .None
        }
        var sights = [Sight]()
        // Convert results to objects
        while sqlite3_step(statement) == SQLITE_ROW {
            let sight = Sight();
            
            sight.type = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 0)))
            
            let longitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 1))
            let latitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 2))
            sight.location = CLLocationCoordinate2DMake(latitude, longitude)
            
            sight.name = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 3)))
            sight.title = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 4)))
            sight.text = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 5)))
            sight.imgurl = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 6)))

            sights.append(sight)
        }
        return sights
    }
}