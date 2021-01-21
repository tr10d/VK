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
        var users = Users()
        users.append(id: 1, name: "Б - Friend 1", image: "Friend-1")
        users.append(id: 2, name: "Г - Friend 2", image: "Friend-2")
        users.append(id: 3, name: "Е - Friend 3", image: "Friend-3")
        users.append(id: 4, name: "Г - Friend 4", image: "Friend-4")
        users.append(id: 5, name: "У - Friend 5", image: "Friend-5")
        users.append(id: 6, name: "Friend 6", image: "Friend-6")
        return users
    }

    func getGroups() -> [Group] {
        return [
            Group(id: 1, name: "Group 1", image: "Group-1"),
            Group(id: 2, name: "Group 2", image: "Group-2"),
            Group(id: 3, name: "Group 3", image: "Group-3"),
            Group(id: 4, name: "Group 4", image: "Group-4"),
            Group(id: 5, name: "Group 5", image: "Group-5")
        ]
    }

    func getPhotos(user: User) -> Photos {
        var photos = [Photo]()
        switch user.id {
        case 1:
            photos.append(Photo(like: 10, image: "1-1", isLiked: true))
            photos.append(Photo(like: 0, image: "1-2"))
            photos.append(Photo(like: 77, image: "1-3"))
            photos.append(Photo(like: 0, image: "1-4"))
            photos.append(Photo(like: 0, image: "1-5"))
        case 2:
            photos.append(Photo(like: 1, image: "2-1", isLiked: true))
            photos.append(Photo(like: 10, image: "2-2"))
        case 3:
            photos.append(Photo(like: 10, image: "3-1", isLiked: true))
        default:
            break
        }
        return Photos(array: photos)
    }

    func isLoginValid(login: String, password: String) -> Bool {
        let logins = getLogins()
        guard let passwordFromDB = logins[login.lowercased()] else { return false }
        return password == passwordFromDB
    }

}

class Photos {
    var array: [Photo]

    init(array: [Photo]) {
        self.array = array
    }

    func switchLike(index: Int) {
        var element = array.remove(at: index)
        element.switchLike()
        array.insert(element, at: index)
    }

    func getItem(index: Int) -> Photo {
        return array[index]
    }
}
