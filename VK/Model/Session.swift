//
//  Session.swift
//  VK
//
//  Created by  Sergei on 04.02.2021.
//

import Foundation

class Session {

    private static let shared = Session()

    private var token: String
    private var userId: Int

    private init() {
        token = ""
        userId = 0
    }

    static func set(token: String, userId: Int) {
        Session.shared.token = token
        Session.shared.userId = userId
        print("Set session: \(get())")
    }

    static func get() -> (token: String, userId: Int) {
        (Session.shared.token, Session.shared.userId)
    }

}
