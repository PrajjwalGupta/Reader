//
//  BookMarkViewContoller.swift
//  NewsReader
//
//  Created by Prajjwal on 19/08/25.
//

import Foundation
import UIKit

class BookmarksViewController: UITableViewController {
    private var bookmarkedArticles: [ArticleEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.rowHeight = 110
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        loadBookmarks()
    }
    
    private func loadBookmarks() {
        bookmarkedArticles = DataBaseHelper.shareInstance.fetchBookMarkedArticles()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedArticles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        let article = bookmarkedArticles[indexPath.row]
        
        let viewModel = CellViewModel(
            title: article.title ?? "",
            author: article.author ?? "Unknown",
            imageURL: URL(string: article.urlToImage ?? "")
        )
        cell.configure(with: viewModel, isBookMarked: false)
        return cell
    }
}

