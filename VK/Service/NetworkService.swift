//
//  NetworkService.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import Foundation
import Alamofire

class NetworkService {

    struct Sessions {
        let native: URLSession = {
            let configuration = URLSessionConfiguration.default
            configuration.allowsCellularAccess = false
            return URLSession(configuration: configuration,
                              delegate: nil, delegateQueue: nil)
        }()
        let alamofire: Alamofire.Session = {
            let configuration = URLSessionConfiguration.default
            configuration.allowsCellularAccess = false
            return Alamofire.Session(configuration: configuration)
        }()
    }

    static let shared = NetworkService()
    static let session = Sessions()

    private init() {}

}

// MARK: - API reqests

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

        NetworkService.session.native.dataTask(with: request, completionHandler: completionHandler).resume()

    }

    func requestAPIAF(method: String, parameters: [String: String] = [:],
                      completionHandler: @escaping (AFDataResponse<Any>) -> ()) {
        
        var queryItems: [String: String] = [
            "access_token": "\(Session.shared.token)",
            "v": versionAPI
        ]
        parameters.forEach { (name, value) in
            queryItems[name] = value
        }
        
        let url = "https://api.vk.com/method/\(method)"
        
        NetworkService.session.alamofire.request(url, method: .post, parameters: queryItems).responseJSON(completionHandler: completionHandler)

    }
}

// MARK: - Requests

extension NetworkService {

    func requestUsers() {
        let parameters = [
            "user_id": "\(Session.shared.userId)",
            "order": "name",
            "fields": "nickname"
        ]
        NetworkService.shared.requestAPIAF(method: "friends.get", parameters: parameters) { (response) in
            switch response.result {
            case .success:
                if let data = response.data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
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

}

// MARK: - Notification.Name

extension Notification.Name {
    static let didReceiveUsers = Notification.Name("didReceiveUsers")
    static let didReceiveGroups = Notification.Name("didReceiveGroups")
    static let didReceivePhotos = Notification.Name("didReceivePhotos")
    static let didReceiveNews = Notification.Name("didReceiveNews")
    static let didReceiveAccountInfo = Notification.Name("didReceiveAccountInfo")
}

// MARK: - willDelete

extension NetworkService {

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
