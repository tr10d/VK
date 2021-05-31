//
//  Adapter.swift
//  VK
//
//  Created by  Sergei on 19.05.2021.
//

import Foundation

protocol FetchDataProtocol {
  func getString() -> String
}

class FetchData: FetchDataProtocol {
  private let data: String = "Данные в виде строки"

  func getString() -> String {
    return data
  }
}

final class ExternalFetchData {
  private let data = ["Дата", "в", "виде", "массива", "слов"]

  var count: Int {
    data.count
  }

  func getWord(by number: Int) -> String {
    return data[number - 1]
  }
}

class AdapterFromExternalFetchData: FetchData {
  private let service: ExternalFetchData

  init(_ service: ExternalFetchData) {
    self.service = service
  }

  override func getString() -> String {
    var result = ""
    let service = ExternalFetchData()
    for number in 1...service.count {
      result += service.getWord(by: number)
      result += " "
    }
    return result
  }
}

class UsingAdapter {
  func get(service: FetchDataProtocol) -> String {
    service.getString()
  }

  func using() {
    let internalFetch = FetchData()
    let externalFetch = ExternalFetchData()
    let externalFetchAdapted = AdapterFromExternalFetchData(externalFetch)
    _ = get(service: internalFetch)
    _ = get(service: externalFetchAdapted)

    _ = internalFetch.getString()
    _ = externalFetchAdapted.getString()
  }
}

