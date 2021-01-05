//
//  NetworkService.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit

//protocol Image {
//    var image: ItemImage { get }
//}

struct ItemImage {
    let name: String
    var image: UIImage? {
        UIImage(named: name)
    }
}


//extension Image {
//    var image: ItemImage
//    init(id: Int, name: String, image: String) {
//        self.id = id
//        self.name = name
//        self.image = ItemImage(name: image)
//    }
//}

struct User: Equatable {
    let id: Int
    let name: String
    let image: ItemImage
    init(id: Int, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = ItemImage(name: image)
    }
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

struct Group: Equatable {
    let id: Int
    let name: String
    let image: ItemImage
    init(id: Int, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = ItemImage(name: image)
    }
    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.id == rhs.id
    }
}

struct Photo {
    let image: ItemImage
}

//struct User2: Equatable {
//    let id: Int
//    let name: String
//    let imageName: String
//    var image: UIImage? {
//        UIImage(named: imageName)
//    }
//}

//struct Group2: Equatable {
//    let name: String
//    let imageName: String
//    var image: UIImage? {
//        UIImage(named: imageName)
//    }
//}

class NetworkService {

    private let loginsDB = [
        "": "",
        "admin": "123"
    ]

//    private let users = [User2]()
//    private let groups = [Group2]()
//    private let photos = [Int: [Photo]]()
//    let logins: [String: String]
//
//    init() {
//        self.logins = getLogins()
//    }
//
//    func getLogins() -> [String: String] {
//        return [
//            "": "",
//            "admin": "123"
//        ]
//    }
//
    // "users": [ { "id": 1, "name": "Friend 1", "image": "Friend-1" } ]
    
    func getUsers() -> [User] {
        let data = [
            User(id: 1, name: "Friend 1", image: "Friend-1"),
            User(id: 2, name: "Friend 2", image: "Friend-2"),
            User(id: 3, name: "Friend 3", image: "Friend-3"),
            User(id: 4, name: "Friend 4", image: "Friend-4"),
            User(id: 5, name: "Friend 5", image: "Friend-5")
        ]
        return data
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

    func getPhotos(user: User) -> [UIImage?] {
        var photos = [UIImage?]()
        switch user.name {
        case "Friend 1":
            photos.append(UIImage(systemName: "play"))
            photos.append(UIImage(systemName: "pause"))
            photos.append(UIImage(systemName: "stop.circle"))
            photos.append(UIImage(systemName: "backward.fill"))
            photos.append(UIImage(systemName: "forward.end.alt.fill"))
            photos.append(UIImage(systemName: "shuffle.circle.fill"))
            photos.append(UIImage(systemName: "shuffle"))
        case "Friend 2":
            photos.append(UIImage(systemName: "cross.circle.fill"))
            photos.append(UIImage(systemName: "cross.case.fill"))
            photos.append(UIImage(systemName: "waveform.path.ecg"))
        case "Friend 3":
            photos.append(UIImage(systemName: "sum"))
            photos.append(UIImage(systemName: "function"))
            photos.append(UIImage(systemName: "percent"))
            photos.append(UIImage(systemName: "x.squareroot"))
        default:
            break
        }
        return photos
    }

    func isLoginValid(login: String, password: String) -> Bool {
        guard let passwordFromDB = loginsDB[login.lowercased()] else { return false }
        return password == passwordFromDB
    }

}
