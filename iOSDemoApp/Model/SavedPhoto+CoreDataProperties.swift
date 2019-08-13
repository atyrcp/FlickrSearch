//
//  SavedPhoto+CoreDataProperties.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/13.
//  Copyright © 2019 z. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedPhoto> {
        return NSFetchRequest<SavedPhoto>(entityName: "SavedPhoto")
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?

}
