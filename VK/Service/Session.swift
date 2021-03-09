//
//  Session.swift
//  VK
//
//  Created by  Sergei on 04.02.2021.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

class Session {

    static let shared = Session()

    @UserDefault(key: "VK_TOKEN", defaultValue: "")
    var token: String

    @UserDefault(key: "VK_USER_ID", defaultValue: -1)
    var userId: Int

}

extension Session {

    func set(token: String, userId: Int) {
        self.token = token
        self.userId = userId
    }

    func isKeysExist() -> Bool {
        guard token.isEmpty || userId == -1 else { return false }
        return true
    }

}
