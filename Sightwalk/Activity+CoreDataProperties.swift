//
//  Activity+CoreDataProperties.swift
//  
//
//  Created by Nigel de Mie on 10/01/16.
//
//

import Foundation
import CoreData

extension Activity {
    @NSManaged var userChosen: String
    @NSManaged var jsonResponse: String
    @NSManaged var dateTime: String
    @NSManaged var name: String
}
