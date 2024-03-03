//
//  Item+CoreDataProperties.swift
//  Clip
//
//  Created by Usman Ayobami on 8/11/23.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var dataType: Int16
    @NSManaged public var isValueHidden: Bool
    @NSManaged public var textValue: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var category: Category?

}

extension Item : Identifiable {

}
