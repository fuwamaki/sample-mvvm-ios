//
//  UserRealmRepository.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/26.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserRealmModelable: Object {
    dynamic var userId: String { get }
}

final class UserRealmRepository<Model: UserRealmModelable> {

    static func find(completion: @escaping (Result<[Model], NSError>) -> Void) {
        do {
            let realm = try Realm()
            let objects = realm.objects(Model.self)
            let models: [Model] = objects.map { $0 }
            completion(.success(models))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    static func find(userId: String, completion: @escaping (Result<Model?, NSError>) -> Void) {
        do {
            let realm = try Realm()
            let object = realm.objects(Model.self).filter { $0.userId == userId }.first
            completion(.success(object))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    static func save(user: UserRealmModelable, completion: @escaping (Result<Any?, NSError>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(user)
                completion(.success(nil))
            }
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    static func delete(user: UserRealmModelable, completion: @escaping (Result<Any?, NSError>) -> Void) {
        do {
            let realm = try Realm()
            let deleteUser = realm.objects(Model.self).filter { $0.userId == user.userId }
            try realm.write {
                realm.delete(deleteUser)
                completion(.success(nil))
            }
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    static func update(user: UserRealmModelable, completion: @escaping (Result<Any?, NSError>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(user, update: .all)
                completion(.success(nil))
            }
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
}
