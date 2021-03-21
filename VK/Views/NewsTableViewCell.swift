//
//  NewsTableViewCell.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    static let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
    static let identifier = "Cell"

    @IBOutlet weak var newsUserImg: UIImageView!
    @IBOutlet weak var newsUser: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    @IBOutlet weak var newsImages: UIImageView!

    func setContent(news: News) {
        newsDate.text = news.date
        newsContent.text = news.text
        if let photos = news.images {
            if photos.count > 0 {
                newsImages.image = photos[0]?.image
            }
        }
    }

}
