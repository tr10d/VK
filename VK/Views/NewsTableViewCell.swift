//
//  NewsTableViewCell.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    static let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
    static let identifier = "Cell"

    @IBOutlet private weak var newsUserImg: UIImageView!
    @IBOutlet private weak var newsUser: UILabel!
    @IBOutlet private weak var newsDate: UILabel!
    @IBOutlet private weak var newsContent: UILabel!
    @IBOutlet private weak var newsImages: UIImageView!

//    func setContent(news: News) {
//        newsDate.text = news.date
//        newsContent.text = news.text
//        if let photos = news.images {
//            if photos.count > 0 {
//                newsImages.image = photos[0]?.image
//            }
//        }
//    }

    func configure(news: RealmNews?) {
        guard let news = news else {
            return
        }

    }
}
