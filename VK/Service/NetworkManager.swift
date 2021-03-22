//
//  NetworkService.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import Foundation
import Alamofire

fileprivate struct API {
    static let version = "5.130"
}

final class NetworkManager {

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

    static let shared = NetworkManager()
    static let session = Sessions()

    private init() {}

}

// MARK: - API reqests

extension NetworkManager {

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
            URLQueryItem(name: "v", value: API.version)
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }

    func requestAPI(method: String, parameters: [String: String] = [:],
                    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {

        var queryItems = [
            URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
            URLQueryItem(name: "v", value: API.version)
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

        NetworkManager.session.native.dataTask(with: request, completionHandler: completionHandler).resume()

    }

    func requestAPIAF(method: String, parameters: [String: String] = [:],
                      completionHandler: @escaping (AFDataResponse<Any>) -> Void) {

        var queryItems: [String: String] = [
            "access_token": "\(Session.shared.token)",
            "v": API.version
        ]
        parameters.forEach { (name, value) in
            queryItems[name] = value
        }

        let url = "https://api.vk.com/method/\(method)"

        NetworkManager.session.alamofire
            .request(url, method: .post, parameters: queryItems)
            .responseJSON(completionHandler: completionHandler)

    }
}

// MARK: - Requests

extension NetworkManager {

    func requestUsers(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameters = [
            "user_id": "\(Session.shared.userId)",
            "fields": "photo_50"
        ]
        NetworkManager.shared.requestAPI(method: "friends.get",
                                         parameters: parameters,
                                         completionHandler: completionHandler)
    }

    func requestPhotos(userId: Int, offset: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameters = [
            "owner_id": "\(userId)",
            "offset": "\(offset)",
            "extended": "1",
            "photo_sizes": "1",
            "skip_hidden": "1"
        ]
        NetworkManager.shared.requestAPI(method: "photos.getAll",
                                         parameters: parameters,
                                         completionHandler: completionHandler)
    }

    func requestGroups(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameters = [
            "user_id": "\(Session.shared.userId)",
            "extended": "1"
      ]
        NetworkManager.shared.requestAPI(method: "groups.get",
                                         parameters: parameters,
                                         completionHandler: completionHandler)
    }

    func requestSearchGroups(searchinText: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameters = [
            "type": "group",
            "future": "0",
            "market": "0",
            "sort": "0",
            "q": "\(searchinText)"
     ]
        NetworkManager.shared.requestAPI(method: "groups.search",
                                         parameters: parameters,
                                         completionHandler: completionHandler)
    }

    func requestNews(offset: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameters = [
            "offset": "\(offset)",
            "filters": "post",
            "return_banned": "0",
            "start_time": "",
            "end_time": "",
            "max_photos": "",
            "source_ids": "",
            "start_from": "",
            "count": "50",
            "fields": "",
            "section": ""
        ]
       NetworkManager.shared.requestAPI(method: "newsfeed.get",
                                        parameters: parameters,
                                        completionHandler: completionHandler)
    }

    func printJSON(data: Data?) {
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Data is missing")
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

// MARK: - Func

extension NetworkManager {

    func image(url: String?) -> UIImage? {
        guard let urlString = url,
              let urlObject = URL(string: urlString),
              let data = try? Data(contentsOf: urlObject),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }

    func url2str(url: String?) -> String {
        guard let urlString = url,
              let urlObject = URL(string: urlString),
              let data = try? Data(contentsOf: urlObject) else {
            return ""
        }
        return data.base64EncodedString()
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
