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

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsAutor: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    @IBOutlet weak var newsImages: UICollectionView!

    func setContent(news: News) {
        newsImage.image = news.user.image.image
        newsAutor.text = news.user.name
        newsDate.text = news.date
        newsContent.text = news.text

    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//
}
