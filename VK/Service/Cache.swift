//
//  Cache.swift
//  VK
//
//  Created by  Sergei on 15.04.2021.
//

import UIKit

final class CachedData {
  static let shared = CachedData()

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

  private enum Sources {
    case fastCache, cache, net
  }

  private init() {}
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
