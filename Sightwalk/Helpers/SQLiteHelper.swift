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
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    
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
            let longitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 2))
            let latitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 3))
            
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            
            let id = Int(sqlite3_value_int(sqlite3_column_value(statement, 0)))
            let type = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 1)))
            let name = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 4)))
            let title = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 5)))
            let text = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 6)))
            let imgurl = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 7)))
            let shortdesc = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 8)))
            
            let sight = Sight(id: id, type: type!, location: location, name: name!, title: title!, text: text!, imgurl: imgurl!, shortdesc: shortdesc!)

            sights.append(sight)
        }
        return sights
    }
    
    func removeSight(sight : Sight) {
        removeSights([Sight]([sight]))
    }
    
    func updateSight(oldSight : Sight, newSight : Sight) {
        removeSight(oldSight)
        storeSight(newSight)
        oldSight.commit(newSight)
    }
    
    func removeSights(sights : [Sight]) {

        var ids : String = ""
        for sight in sights {
            if ids.characters.count > 0 {
                ids += ","
            }
            
            ids += String(sight.id)
        }
        
        let query = "DELETE FROM sights WHERE `id` IN (" + ids + ")"
        // Prepare query and execute
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("Error in query: \(errmsg)!")
        }
    }
    
    func storeSight(sight : Sight) {
        let query : String = "INSERT INTO sights (id, type, longitude, latitude, name, title, text, imgurl, short_desc) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
        var statement: COpaquePointer = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("error preparing insert: \(errmsg)")
        }
        
        if  sqlite3_bind_int(statement, 1, Int32(sight.id)) != SQLITE_OK
            || sqlite3_bind_text(statement, 2, sight.type, -1, SQLITE_TRANSIENT) != SQLITE_OK
            || sqlite3_bind_text(statement, 3, sight.location.longitude.description, -1, SQLITE_TRANSIENT) != SQLITE_OK
            || sqlite3_bind_text(statement, 4, sight.location.latitude.description, -1, SQLITE_TRANSIENT) != SQLITE_OK
            || sqlite3_bind_text(statement, 5, sight.name, -1, SQLITE_TRANSIENT) != SQLITE_OK
            || sqlite3_bind_text(statement, 6, sight.title, -1, SQLITE_TRANSIENT) != SQLITE_OK
            || sqlite3_bind_text(statement, 7, sight.text, -1, SQLITE_TRANSIENT) != SQLITE_OK
            || sqlite3_bind_text(statement, 8, sight.imgurl, -1, SQLITE_TRANSIENT) != SQLITE_OK
            || sqlite3_bind_text(statement, 9, sight.shortdesc, -1, SQLITE_TRANSIENT) != SQLITE_OK
        {// \/
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("failure binding foo: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("failure inserting sight: \(errmsg)")
        }
    }
}