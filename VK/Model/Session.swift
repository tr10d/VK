//
//  Session.swift
//  VK
//
//  Created by  Sergei on 04.02.2021.
//

import Foundation

typealias SessionItem = (token: String, userId: Int)

class Session {

    static let shared = Session()

    var token: String
    var userId: Int

    private init() {
        token = ""
        userId = 0
    }

}

extension Session {

    enum UserDefaultsKeys: String {
        case token = "vk.token"
        case user = "vk.userId"
    }

    func setItem(token: String, userId: Int) {
        Session.shared.token = token
        Session.shared.userId = userId
        seveItem()
    }

    func seveItem() {
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.token.rawValue)
        UserDefaults.standard.set(userId, forKey: UserDefaultsKeys.user.rawValue)
    }
    
    func isKeysExist() -> Bool {
        guard let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.token.rawValue) else { return false }
        setItem(token: token,
            userId: UserDefaults.standard.integer(forKey: UserDefaultsKeys.user.rawValue))
        return true
    }

}
