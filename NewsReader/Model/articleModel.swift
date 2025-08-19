//
//  Article_model.swift
//  NewsReader
//
//  Created by Prajjwal on 19/08/25.
//

import Foundation

struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let author: String?
    let urlToImage: String?
}

struct Source: Codable {
    let name: String
}
