//
//  NetworkService.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit

class NetworkService {

    func getLogins() -> [String: String] {
        return [
            "": "",
            "admin": "123"
        ]
    }

    func getUsers() -> Users {
        var users: Users = Users()
        for index in 1...30 {
            users.append(id: index,
                         name: "\(Randoms.randomFakeName())",
                         image: "User-\(Int.random(1, 12))")
        }
        return users
    }

    func getGroups() -> [Group] {
        var array: [Group] = []
        for index in 1...30 {
            array.append(
                Group(id: index,
                      name: Randoms.randomFakeTitle(),
                      image: "Group-\(Int.random(1, 15))"))
        }
        return array
    }

    func getPhotos(_ user: User?) -> Photos {
        var photos: [Photo] = []
//        if user != nil {
            (0...Int.random(0, 50))
                .forEach { _ in photos.append(Photo()) }
//        }
        return Photos(array: photos)
    }

    func getNews() -> [News] {
        var news: [News] = []
        (0...Int.random(1, 50))
            .forEach { _ in news.append(News()) }
        return news
    }

    func isLoginValid(login: String, password: String) -> Bool {
        let logins = getLogins()
        guard let passwordFromDB = logins[login.lowercased()] else { return false }
        return password == passwordFromDB
    }

}

class Photos {
    var array: [Photo]
    var count: Int {
        return array.count
    }

    init(array: [Photo]) {
        self.array = array
    }

    func switchLike(index: Int) {
        var element = array.remove(at: index)
        element.switchLike()
        array.insert(element, at: index)
    }

    func getItem(index: Int) -> Photo? {
        if index >= 0 && index < array.count {
            return array[index]
        }
        return nil
    }
}
