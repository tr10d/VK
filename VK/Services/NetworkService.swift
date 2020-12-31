//
//  NetworkService.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit

class NetworkService {

    private let loginsDB = [
        "": "",
        "admin ": "123"
    ]

    func getUsers() -> [User] {
        return [
            User(name: "Friend 1", imageName: "Friend-1"),
            User(name: "Friend 2", imageName: "Friend-2"),
            User(name: "Friend 3", imageName: "Friend-3"),
            User(name: "Friend 4", imageName: "Friend-4"),
            User(name: "Friend 5", imageName: "Friend-5")
        ]
    }

    func getGroups() -> [Group] {
        return [
            Group(name: "Group 1", imageName: "Group-1"),
            Group(name: "Group 2", imageName: "Group-2"),
            Group(name: "Group 3", imageName: "Group-3"),
            Group(name: "Group 4", imageName: "Group-4"),
            Group(name: "Group 5", imageName: "Group-5")
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
