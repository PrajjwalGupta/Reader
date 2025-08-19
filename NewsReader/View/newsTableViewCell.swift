//
//  NewsTableViewCell.swift
//  NewsReader
//
//  Created by Prajjwal on 19/08/25.
//

import Foundation
import UIKit

final class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    private var isBookmark = false
    var onBookmarkTapped: ((Bool) -> Void)?

    private let titleLabel: UILabel = {
        let titleText = UILabel()
        titleText.font = .systemFont(ofSize: 20, weight: .bold)
        titleText.numberOfLines = 2
        return titleText
    }()
    
    private let authorLabel: UILabel = {
        let authorText = UILabel()
        authorText.font = .systemFont(ofSize: 14)
        authorText.textColor = UIColor.gray.withAlphaComponent(0.5)
        
        return authorText
    }()

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(bookmarkButton)

        bookmarkButton.addTarget(self, action: #selector(didTapBookmark), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        newsImageView.frame = CGRect(x: 15, y: 10, width: 90, height: 90)
        let textWidth = contentView.bounds.width - newsImageView.frame.maxX - 12
        titleLabel.frame = CGRect(x:  newsImageView.frame.maxX + 12, y: 10, width: textWidth, height: 90)
        authorLabel.frame = CGRect(
            x: newsImageView.frame.maxX + 12,
            y: titleLabel.frame.minY + 4,
            width: 200,
            height: 20)
        bookmarkButton.frame = CGRect(x: contentView.bounds.width - 40, y: 10, width: 14, height: 14)
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
    }
    
    @objc private func didTapBookmark() {

        isBookmark.toggle()
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let imageName = isBookmark ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        
        if let title = titleLabel.text {
            DataBaseHelper.shareInstance.updateBookMark(for: title, isBookmarked: isBookmark)
        }
        onBookmarkTapped?(isBookmark)
    }

    func configure(with viewModel: CellViewModel, isBookMarked: Bool = false) {
        
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        
        let imageName = isBookmark ? "bookmark.fill" : "bookmark"
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        bookmarkButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)

        guard let url = viewModel.imageURL else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async { self?.newsImageView.image = img }
        }.resume()
    }
    
}
