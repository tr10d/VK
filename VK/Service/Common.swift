//
//  Common.swift
//  VK
//
//  Created by  Sergei on 09.03.2021.
//

import UIKit

struct API {
    static let version = "5.130"
    static let clientId = "7763397"
    static let cacheLifeTime: Double = 30 * 24 * 60 * 60

    enum Scopes: Int {
        case friends = 2
        case photos = 4
        case wall = 8192
        case groups = 262144
    }

    enum FilterItems: String {
        case post
        case photo
    }

    struct FiltersNewsFeed {
        let post = FilterItems.post.rawValue
        let photo = FilterItems.photo.rawValue
    }

    struct Filters {
        let newsFeed = FiltersNewsFeed()
    }

}

extension Array where Element == Int {

    var indexPaths: [IndexPath] {
        self.map { IndexPath(item: $0, section: 0) }
    }

}

extension Array where Element == API.Scopes {

    var scope: String {
        self.reduce(0) { result, element in
            result + element.rawValue
        }.description
    }
}

extension Array where Element == API.FilterItems {

    var filters: String {
        self.map {
            $0.rawValue
        }.joined(separator: ",")
    }
}

extension UIImageView {

    func setLikes(_ isLikes: Bool) {
        if isLikes {
            self.image = UIImage(systemName: "suit.heart.fill")
        } else {
            self.image = UIImage(systemName: "suit.heart")
        }
    }

}

extension Int {

    var date: String {
        let date = Date(timeIntervalSince1970: Double(self))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .long
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }

}

final class CachedData {

    static let shared = CachedData()

    private init() {}

    private enum Sources {
        case fastCache, cache, net
    }

    private var fastCache = [String: UIImage]()
    private let pathName: String = {
        let pathName = "images"
        guard
            let cachesDirectory = FileManager.default
                .urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()

}

extension CachedData {

    private func getFilePath(url: String) -> String? {
        guard
            let cachesDirectory = FileManager.default
                .urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(self.pathName + "/" + hashName).path
    }

    private func saveImageToCache(url: String, image: UIImage) {
        guard
            let fileName = getFilePath(url: url),
            let data = image.pngData() else { return }
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }

    private func getImage(url: String, _ source: Sources) -> UIImage? {
        switch source {
        case .fastCache:
            return fastCache[url]

        case .cache:
            guard
                let fileName = getFilePath(url: url),
                let info = try? FileManager.default.attributesOfItem(atPath: fileName),
                let modificationDate = info[FileAttributeKey.modificationDate] as? Date,
                Date().timeIntervalSince(modificationDate) <= API.cacheLifeTime,
                let image = UIImage(contentsOfFile: fileName) else { return nil }
            return image

        case .net:
            guard
                let urlObject = URL(string: url),
                let data = try? Data(contentsOf: urlObject),
                let image = UIImage(data: data) else { return nil }
            return image
        }
    }

    private func addImage(url: String, image: UIImage, _ source: Sources) {
        switch source {
        case .fastCache:
            fastCache[url] = image

        case .cache:
            OperationQueue().addOperation {
                self.saveImageToCache(url: url, image: image)
            }

        case .net:
            break
        }
    }

    func image(url: String?) -> UIImage? {

        guard let url = url else { return nil }

        if let image = getImage(url: url, .fastCache) {
            return image
        }

        if let image = getImage(url: url, .cache) {
            addImage(url: url, image: image, .fastCache)
            return image
        }

        if let image = getImage(url: url, .net) {
            addImage(url: url, image: image, .fastCache)
            addImage(url: url, image: image, .cache)
            return image
        }
        return nil
    }

}
