//
//  RealmRepository.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmAction {
    case find, save, delete, update
}

protocol RealmModelable: Object {
    dynamic var itemId: Int { get }
}

final class ItemRealmRepository<Model: RealmModelable> {

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

    static func save(item: RealmModelable, completion: @escaping (Result<Any?, NSError>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(item)
                completion(.success(nil))
            }
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    static func delete(item: RealmModelable, completion: @escaping (Result<Any?, NSError>) -> Void) {
        do {
            let realm = try Realm()
            let deleteItem = realm.objects(Model.self).filter { $0.itemId == item.itemId }
            try realm.write {
                realm.delete(deleteItem)
                completion(.success(nil))
            }
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    static func updateItem(item: RealmModelable, completion: @escaping (Result<Any?, NSError>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(item, update: .all)
                completion(.success(nil))
            }
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
}
