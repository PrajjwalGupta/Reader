//
//  NewsTableViewController.swift
//  NewsReader
//
//  Created by Prajjwal on 19/08/25.
//

import UIKit

class NewsTableViewController: UITableViewController {

    private var articles: [Article] = []
    private var filteredArticles: [Article] = []
    private let refresh = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Top Headlines"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Bookmarks", style: .plain, target: self, action: #selector(openBookmarks))
       
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier:NewsTableViewCell.identifier)
        tableView.rowHeight = 110
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search articles"
        definesPresentationContext = true
        
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
        fetch()
    }
    
    @objc private func openBookmarks() {
        let bookmarksVC = BookmarksViewController()
        navigationController?.pushViewController(bookmarksVC, animated: true)
    }
    
    @objc private func didPullToRefresh() {
         fetch()
     }

    private func fetch() {
        NewsService.shared.getTopStories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let arts):
                    self?.articles = arts
                    arts.forEach { art in
                         DataBaseHelper.shareInstance.save(object: [
                            "title": art.title,
                            "author": art.author ?? "Unknown",
                            "urlToImage": art.urlToImage ?? "",
                            ])
                        }
                    print("Reload rows:", arts.count)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Fetch failed:", error)
                    let cached = DataBaseHelper.shareInstance.fetchArticles()
                    self?.articles = cached.map {
                    Article(
                        source: Source(name: "Offline Cache"),
                        title: $0.title ?? "",
                        author: $0.author,
                        urlToImage: $0.urlToImage
                    )
                  }
                 self?.tableView.reloadData()
                }
                self?.refresh.endRefreshing()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive,
           let query = searchController.searchBar.text,
           !query.isEmpty {
            print("numberOfRowsInSection (search):", filteredArticles.count)
            return filteredArticles.count
        } else {
            print("numberOfRowsInSection (all):", articles.count)
            return articles.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        let article: Article
        if searchController.isActive,
           let query = searchController.searchBar.text,
           !query.isEmpty {
            article = filteredArticles[indexPath.row]
        } else {
            article = articles[indexPath.row]
        }
        let viewModel = CellViewModel(
            title: article.title,
            author: article.author ?? "Unknown",
            imageURL: URL(string: article.urlToImage ?? "")
        )
        cell.configure(with: viewModel)
        return cell
    }
}
extension NewsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            filteredArticles = articles
            tableView.reloadData()
            return
        }
        filteredArticles = articles.filter {
            $0.title.lowercased().contains(query.lowercased()) ||
            ($0.author?.lowercased().contains(query.lowercased()) ?? false)
        }
        tableView.reloadData()
    }
}
