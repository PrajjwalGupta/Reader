//
//  apiService.swift
//  NewsReader
//
//  Created by Prajjwal on 19/08/25.
//

import Foundation

final class NewsService {
    static let shared = NewsService()
    static let APIKEY="YOUR_NEWSAPI_KEY"
    private init() {}
   

    private struct Constants {
        static let topHeadlinesURL = URL(
            string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(APIKEY)"
        )
    }

    func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        URLSession.shared.dataTask(with: Constants.topHeadlinesURL!) { data, _, error in
            if let error = error { return completion(.failure(error)) }
            guard let data = data else { return completion(.success([])) }
            do {
                let res = try JSONDecoder().decode(NewsResponse.self, from: data)
                print("Fetched articles:", res.articles.count)
                completion(.success(res.articles))
            } catch {
                print("Decode error:", error)
                completion(.failure(error))
            }
        }.resume()
    }
}


