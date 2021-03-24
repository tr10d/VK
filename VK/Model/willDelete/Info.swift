//
//  Info.swift
//  VK
//
//  Created by  Sergei on 19.02.2021.
//

import Foundation

// MARK: - Info
struct Info: Codable {

    let response: Response

    // MARK: - Response
    struct Response: Codable {
        let country: String
    }

}
