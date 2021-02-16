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
//        //https://oauth.vk.com/blank.html#access_token=0daeaefb70fc4766adf38bdc81ec5a18f8561053b64f60bd72ab1bc63592ecd341455187ef7e811c52aa2&expires_in=86400&user_id=191195760
//        UserDefaults.standard.set("0daeaefb70fc4766adf38bdc81ec5a18f8561053b64f60bd72ab1bc63592ecd341455187ef7e811c52aa2", forKey: "vk.token")
//        UserDefaults.standard.set(191195760, forKey: "vk.userId")
        token = ""
        userId = 0
    }

}

extension Session {

    func set(token: String, userId: Int) {
        Session.shared.token = token
        Session.shared.userId = userId
        seveItem()
    }

    func isSaved() -> Bool {
        guard let token = UserDefaults.standard.string(forKey: "vk.token") else { return false }

        if let request = NetworkService.shared.requestAPI(method: "", parameters: ["fields": "country"]) {

            var isExist = false
            let dataTask = NetworkService.session.dataTask(with: request) { (data, _, error) in
                if let data = data,
                   let _ = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    isExist = true
                    self.token = token
                    self.userId = UserDefaults.standard.integer(forKey: "vk.userId")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
            return isExist
        }
        return false
    }

    func seveItem() {
        UserDefaults.standard.set(token, forKey: "vk.token")
        UserDefaults.standard.set(userId, forKey: "vk.userId")
    }

}
