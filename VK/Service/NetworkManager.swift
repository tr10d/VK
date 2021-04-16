//
//  NetworkService.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit
import PromiseKit

final class NetworkManager {
  static let shared = NetworkManager()
  static let session: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.allowsCellularAccess = false
    return URLSession(
      configuration: configuration,
      delegate: nil,
      delegateQueue: nil
    )
  }()

  private init() {}
}

// MARK: - API reqests

extension NetworkManager {

    func urlVK(with method: String, parameters: [String: String] = [:]) -> URL? {
        let queryItems = [
            URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
            URLQueryItem(name: "v", value: API.version)
        ] + parameters.map { URLQueryItem(name: $0, value: $1) }

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/\(method)"
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    func requestAuth() -> URLRequest? {

        let scope = [
            API.Scopes.friends,
            API.Scopes.photos,
            API.Scopes.wall,
            API.Scopes.groups
        ].scope

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: API.clientId),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: API.version)
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }

    func requestAPI(method: String, parameters: [String: String] = [:],
                    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {

        guard let url = urlVK(with: method, parameters: parameters) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30

        NetworkManager.session.dataTask(with: request, completionHandler: completionHandler).resume()

    }

    func request<T: Codable>(method: String,
                             parameters: [String: String],
                             json: T.Type,
                             completionHandler: @escaping (T) -> Void) {
        NetworkManager.shared.requestAPI(method: method, parameters: parameters) { (data, _, _) in
             #if DEBUG
             self.printJSON(data: data)
             #endif
             guard let data = data else { return }
             do {
                let decodeJson = try JSONDecoder().decode(json, from: data)
                OperationQueue.main.addOperation {
                     completionHandler(decodeJson)
                 }
             } catch {
                 print(error.localizedDescription)
             }
         }
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

// MARK: - get News

extension NetworkManager {
  func getNews(startFrom: String) -> Promise<Json.News> {
    let url = urlVK(
      with: API.News.method,
      parameters: API.News.parameters(startFrom: startFrom)
    )!

    return firstly {
      NetworkManager.session.dataTask(.promise, with: url)
    }.compactMap {
      try JSONDecoder().decode(Json.News.self, from: $0.data)
    }
  }
}

// MARK: - Misc. Func

extension NetworkManager {
  func image(url: String?) -> UIImage? {
    CachedData.shared.image(url: url)
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
