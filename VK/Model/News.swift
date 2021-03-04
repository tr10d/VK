//
//  News.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import Foundation

struct News {
//    let user: User
    let date: String
    let text: String
    let images: Photos?

    init() {
//        self.user = User()
        self.date = "\(Randoms.randomDate())"
        self.text = (1...Randoms.randomInt(1, 30)).reduce("", { string, _ in string + " \(Randoms.randomFakeTitle())" })
//        if Randoms.randomBool() {
//            self.images = NetworkService.shared.getPhotos(self.user)
//        } else {
            self.images = nil
//        }
    }
}
