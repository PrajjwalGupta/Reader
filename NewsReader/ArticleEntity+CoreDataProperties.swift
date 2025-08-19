//
//  ArticleEntity+CoreDataProperties.swift
//  NewsReader
//
//  Created by Prajjwal on 19/08/25.
//
//

import Foundation
import CoreData


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var isBookmarked: Bool

    

}

extension ArticleEntity : Identifiable {

}
