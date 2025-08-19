//
//  DataBaseHelper.swift
//  NewsReader
//
//  Created by Prajjwal on 19/08/25.
//

import Foundation
import CoreData
import UIKit

class DataBaseHelper {
    
    static var shareInstance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func save(object: [String:String]) {
        let savedNewsArticle = NSEntityDescription.insertNewObject(forEntityName: "ArticleEntity", into: context!) as! ArticleEntity
        savedNewsArticle.title = object["title"]
        savedNewsArticle.author = object["author"]
        savedNewsArticle.urlToImage = object["urlToImage"]
        savedNewsArticle.isBookmarked = false
        
        do{
            try context?.save()
        }catch{
            print("News article is not saved", error.localizedDescription)
        }
    }
    
    func fetchArticles() -> [ArticleEntity] {
        guard let context = context else { return [] }
        do {
            return try context.fetch(ArticleEntity.fetchRequest())
        } catch {
            print("Failed to fetch", error.localizedDescription)
            return []
        }
    }
    
    func fetchBookMarkedArticles() -> [ArticleEntity] {
        guard let context = context else { return [] }
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isBookmarked == %@", NSNumber(value: true))
        do {
            return try context.fetch(request)
        } catch{
            print("Failed to fetched bookmarked article: ", error.localizedDescription)
            return []
        }
    }
    func updateBookMark(for title: String, isBookmarked: Bool) {
        guard let context = context else { return }
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        do {
            let results = try context.fetch(request)
            if let article = results.first {
                article.isBookmarked = isBookmarked
                try context.save()
                print("BookMarked updated for: \(title)")
            }
        } catch {
            print("", error.localizedDescription)
        }
    }
}
