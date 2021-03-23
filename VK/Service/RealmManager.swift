//
//  RealmManager.swift
//  VK
//
//  Created by  Sergei on 22.03.2021.
//

import Foundation
import RealmSwift

protocol RealmManagerDataProtocol {
    func getRealmObject() -> [Object]
}

// MARK: - RealmManager

final class RealmManager {

    static let shared = RealmManager()

    private let realm: Realm

    private init?() {
        let configurator = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configurator) else { return nil }
        self.realm = realm
        #if DEBUG
            print(realm.configuration.fileURL ?? "New Realm error")
        #endif
    }

}

extension RealmManager {

    static func getUsers(offset: Int = 0, completion: @escaping (Results<RealmUser>) -> Void) {
        guard let realmData = shared?.realm.objects(RealmUser.self).sorted(byKeyPath: "lastName") else { return }
        if realmData.count == offset {
            RealmManager.responseUsers(offset: offset) { completion(realmData) }
        } else {
            completion(realmData)
        }
    }

    static func getPhotos(realmUser: RealmUser?, offset: Int = 0, completion: @escaping (Results<RealmPhoto>) -> Void) {
        guard let realmUser = realmUser else { return }
        guard let realmPhoto = shared?.realm.objects(RealmPhoto.self)
                .filter("ownerID == %@", realmUser.id) else { return }

        if realmPhoto.count == offset {
            RealmManager.responsePhotos(realmUser: realmUser, offset: offset) {
                completion(realmPhoto)
            }
        } else {
            completion(realmPhoto)
        }
    }

    static func getGroups(offset: Int = 0, completion: @escaping (Results<RealmGroup>) -> Void) {
        guard let realmData = shared?.realm.objects(RealmGroup.self) else { return }
        if realmData.count == offset {
            RealmManager.responseGroups(offset: offset) { completion(realmData) }
        } else {
            completion(realmData)
        }
    }

    static func getNews(offset: Int = 0, completion: @escaping (Results<RealmNews>) -> Void) {
        guard let realmData = shared?.realm.objects(RealmNews.self) else { return }
        if realmData.count == offset {
            RealmManager.responseNews(offset: offset) { completion(realmData) }
        } else {
            completion(realmData)
        }
    }

    static func responseUsers3(offset: Int = 0, completionHandler: @escaping () -> Void) {
        NetworkManager.shared.requestUsers { (data, _, _) in
            guard let data = data else { return }
            do {
                let usersJson = try JSONDecoder().decode(UsersJson.self, from: data)
                let realmUsers = usersJson.response?.items.map { RealmUser(user: $0) }
                DispatchQueue.main.async {
                    saveData(data: realmUsers!)
                    completionHandler()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func responseUsers(offset: Int = 0, completionHandler: @escaping () -> Void) {
        NetworkManager.shared.requestUsers { (data, _, _) in
            guard let data = data else { return }
            do {
                let realmData = try JSONDecoder().decode(UsersJson.self, from: data).getRealmObject()
                guard !realmData.isEmpty else { return }
                DispatchQueue.main.async {
                    RealmManager.saveData(data: realmData)
                    completionHandler()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func responsePhotos(realmUser: RealmUser?, offset: Int = 0, completionHandler: @escaping () -> Void) {
        guard let realmUser = realmUser else { return }

        NetworkManager.shared.requestPhotos(userId: realmUser.id, offset: offset) { (data, _, _) in
            guard let data = data else { return }
            do {
                let realmData = try JSONDecoder().decode(PhotoJSON.self, from: data).getRealmObject()
                guard !realmData.isEmpty else { return }
                DispatchQueue.main.async {
                    RealmManager.saveData(data: realmData)
                    completionHandler()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func responseGroups(offset: Int = 0, completionHandler: @escaping () -> Void) {
        NetworkManager.shared.requestGroups { (data, _, _) in
            guard let data = data else { return }
            do {
                let groups = try JSONDecoder().decode(Groups.self, from: data)
                let realmGroups = groups.response?.items.map { RealmGroup(group: $0) }
                if let realmGroups = realmGroups {
                    DispatchQueue.main.async {
                        RealmManager.saveData(data: realmGroups)
                        completionHandler()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func responseNews(offset: Int = 0, completionHandler: @escaping () -> Void) {
        NetworkManager.shared.requestNews(offset: offset) { (data, _, _) in
            guard let data = data else { return }
            do {
                let realmData = try JSONDecoder().decode(News.self, from: data).getRealmObject()
                guard !realmData.isEmpty else { return }
                DispatchQueue.main.async {
                    RealmManager.saveData(data: realmData)
                    completionHandler()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func saveData(data: [Object]) {
        do {
            try shared?.realm.write {
                shared?.realm.add(data, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension RealmManager {

    func add<T: Object>(object: T) throws {
        try realm.write {
            realm.add(object)
        }
    }

    func add<T: Object>(objects: [T]) throws {
        try realm.write {
            realm.add(objects, update: .all)
        }
    }

    func delete<T: Object>(object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }

    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }

    func update(closure: (() -> Void)) throws {
        try realm.write {
            closure()
        }
    }

    func getObjects<T: Object>() -> Results<T> {
        let result = realm.objects(T.self)
        if result.isEmpty {

        }
        return result
    }

}
