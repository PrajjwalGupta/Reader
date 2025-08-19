//
//  cellViewModel.swift
//  NewsReader
//
//  Created by Prajjwal on 19/08/25.
//

import UIKit

final class CellViewModel {
    let title: String
    let author: String
    let imageURL: URL?
    init(title: String, author: String, imageURL: URL?) {
        self.title = title
        self.author = author
        self.imageURL = imageURL
    }
}
