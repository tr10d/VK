//
//  Promise.swift
//  VK
//
//  Created by  Sergei on 09.04.2021.
//

import Foundation

class Future<T> {

    private var callbacks: [(Result<T, Error>) -> Void] = []

    fileprivate var result: Result<T, Error>? {
        didSet {
            guard let result = result else { return }
            callbacks.forEach { $0(result)}
        }
    }

    func add(callback: @escaping (Result<T, Error>) -> Void) {
        callbacks.append(callback)
        result.map(callback)
    }
}

extension Future {

    func map<NewType>(with closure: @escaping (T) throws -> NewType) -> Future<NewType> {
        let promise = Promise<NewType>()
        add { result in
            switch result {
            case .success(let value):
                do {
                    let valueMapped = try closure(value)
                    promise.fulfill(with: valueMapped)
                } catch {
                    promise.reject(with: error)
                }
            case .failure(let error):
                promise.reject(with: error)
            }
        }
        return promise
    }

    func flatMap<NewType>(with closure: @escaping (T) throws -> Future<NewType>) -> Future<NewType> {
        let promise = Promise<NewType>()
        add { result in
            switch result {
            case .success(let value):
                do {
                    let promisesChained = try closure(value)
                    promisesChained.add { result in
                        switch result {
                        case .success(let value):
                            promise.fulfill(with: value)
                        case .failure(let error):
                            promise.reject(with: error)
                       }
                    }
                } catch {
                    promise.reject(with: error)
                }
            case .failure(let error):
                promise.reject(with: error)
            }
        }
        return promise
    }
}

class Promise<T>: Future<T> {

    init(value: T? = nil) {
        super.init()
        result = value.map(Result.success)
    }

    func fulfill(with value: T) {
        result = .success(value)
    }

    func reject(with error: Error) {
        result = .failure(error)
    }
}
