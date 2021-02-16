//
//  NetworkService.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit

class NetworkService {

    static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        let session = URLSession(configuration: configuration)

        return session
    }()

//    private static let sessionAF: Alamofire.Session = {
//        let configuration = URLSessionConfiguration.default
//        configuration.allowsCellularAccess = false
//        let session = Alamofire.Session(configuration: configuration)
//
//        return session
//    }()

    static let shared = NetworkService()

    private init() {}

}

extension NetworkService {

    func version() -> String {
        "5.68"
    }
    func requestAuth() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7763397"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "\(version())")
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }

    func requestAPI(method: String, parameters: [String: String] = [:]) -> URLRequest? {

        var queryItems = [
            URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
            URLQueryItem(name: "v", value: "\(version())")
        ]

        parameters.forEach { (name, value) in
            queryItems.append(URLQueryItem(name: name, value: value))
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/\(method)"
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return nil}

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        return request
    }

    func getFriends() -> [Int] {
        return []
    }

}

extension NetworkService {

    func getUsers() -> Users {
        let parameters = [
            "user_id": "\(Session.shared.userId)",
            "order": "name",
            "fields": "nickname"
       ]
        if let request = NetworkService.shared.requestAPI(method: "friends.get", parameters: parameters) {
            let dataTask = NetworkService.session.dataTask(with: request) { (data, response, error) in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        }

        var users: Users = Users()
        for index in 1...30 {
            users.append(id: index,
                         name: "\(Randoms.randomFakeName())",
                         image: "User-\(Int.random(1, 12))")
        }
        return users
    }

    func getLogins() -> [String: String] {
        return [
            "": "",
            "admin": "123"
        ]
    }

    func getGroups() -> [Group] {
        let parameters = [
            "user_id": "\(Session.shared.userId)"
       ]
        if let request = NetworkService.shared.requestAPI(method: "groups.get", parameters: parameters) {
            let dataTask = NetworkService.session.dataTask(with: request) { (data, response, error) in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        }

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
        let parameters = [
            "owner_id": "\(Session.shared.userId)"
       ]
        if let request = NetworkService.shared.requestAPI(method: "photos.getAll", parameters: parameters) {
            let dataTask = NetworkService.session.dataTask(with: request) { (data, response, error) in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        }

        var photos: [Photo] = []
//        if user != nil {
            (0...Int.random(0, 50))
                .forEach { _ in photos.append(Photo()) }
//        }
        return Photos(array: photos)
    }

    func getNews() -> [News] {

        if let request = NetworkService.shared.requestAPI(method: "newsfeed.get") {
            let dataTask = NetworkService.session.dataTask(with: request) { (data, response, error) in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        }

        var news: [News] = []
        (0...Int.random(1, 50))
            .forEach { _ in news.append(News()) }
        return news
    }

    func isLoginValid(login: String, password: String) -> Bool {
        let logins = getLogins()
        guard let passwordFromDB = logins[login.lowercased()] else { return false }
        let isValid = password == passwordFromDB
//        if isValid {
//            Session.shared.token = token
//        }
        return isValid
    }

    func getSession(login: String) -> (token: String, userId: Int) {
        (login, Randoms.randomInt())
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
