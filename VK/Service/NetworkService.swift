//
//  NetworkService.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import Foundation

extension Notification.Name {
    static let didReceiveUsers = Notification.Name("didReceiveUsers")
    static let didReceiveGroups = Notification.Name("didReceiveGroups")
    static let didReceivePhotos = Notification.Name("didReceivePhotos")
    static let didReceiveNews = Notification.Name("didReceiveNews")
    static let didReceiveAccountInfo = Notification.Name("didReceiveAccountInfo")
}

class NetworkService {

    static let shared = NetworkService()
    static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        return URLSession(configuration: configuration,
                          delegate: nil, delegateQueue: nil)
    }()

//    lazy var session: URLSession = {
//        let configuration = URLSessionConfiguration.default
//        configuration.allowsCellularAccess = false
//        return URLSession(configuration: configuration,
//                          delegate: self, delegateQueue: nil)
//    }()

//    private let sessionDeligate = SessionDeligate()

    private init() {}

//    func nativeSession() -> URLSession {
//        let configuration = URLSessionConfiguration.default
//        configuration.allowsCellularAccess = false
//        return URLSession(configuration: configuration,
//                          delegate: nil, delegateQueue: nil)
//    }

//    func sessionAF() -> Alamofire.Session {
//        let configuration = URLSessionConfiguration.default
//        configuration.allowsCellularAccess = false
//        let session = Alamofire.Session(configuration: configuration)
//
//        return session
//    }
}

extension NetworkService {

    var versionAPI: String {
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
            URLQueryItem(name: "v", value: versionAPI)
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }

    func requestAPI(method: String, parameters: [String: String] = [:],
                    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {

        var queryItems = [
            URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
            URLQueryItem(name: "v", value: versionAPI)
        ]

        parameters.forEach { (name, value) in
            queryItems.append(URLQueryItem(name: name, value: value))
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/\(method)"
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30

        NetworkService.session.dataTask(with: request, completionHandler: completionHandler).resume()
    }

}

extension NetworkService {

    func getJSON(data: Data?, response: URLResponse?, error: Error?) -> Any? {
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            return json
        }
        if let error = error {
            print(error.localizedDescription)
        }
        return nil
    }

    func requestUsers() {
        let parameters = [
            "user_id": "\(Session.shared.userId)",
            "order": "name",
            "fields": "nickname"
        ]
        NetworkService.shared.requestAPI(method: "friends.get", parameters: parameters) { (data, response, error) in
            if let json = self.getJSON(data: data, response: response, error: error) {
                NotificationCenter.default.post(name: .didReceiveUsers, object: nil, userInfo: ["json": json])
            }
        }
    }

    func requestGroups() {
        let parameters = [
            "user_id": "\(Session.shared.userId)"
        ]
        NetworkService.shared.requestAPI(method: "groups.get", parameters: parameters) { (data, response, error) in
            if let json = self.getJSON(data: data, response: response, error: error) {
                NotificationCenter.default.post(name: .didReceiveGroups, object: nil, userInfo: ["json": json])
            }
        }
    }

    func requestPhotos() {
        let parameters = [
            "owner_id": "\(Session.shared.userId)"
        ]
        NetworkService.shared.requestAPI(method: "photos.getAll", parameters: parameters) { (data, response, error) in
            if let json = self.getJSON(data: data, response: response, error: error) {
                NotificationCenter.default.post(name: .didReceivePhotos, object: nil, userInfo: ["json": json])
            }
        }
    }

    func requestNews() {
        NetworkService.shared.requestAPI(method: "newsfeed.get") { (data, response, error) in
            if let json = self.getJSON(data: data, response: response, error: error) {
                NotificationCenter.default.post(name: .didReceiveNews, object: nil, userInfo: ["json": json])
            }
        }
    }

    func requestAccountInfo() {
        NetworkService.shared.requestAPI(method: "account.getInfo") { (data, response, error) in
            if let json = self.getJSON(data: data, response: response, error: error) {
                NotificationCenter.default.post(name: .didReceiveAccountInfo, object: nil)
            }
        }
    }

   func getNews() -> [News] {
        var news: [News] = []
        (0...Int.random(1, 50))
            .forEach { _ in news.append(News()) }
        return news
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

    func getLogins() -> [String: String] {
        return [
            "": "",
            "admin": "123"
        ]
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
