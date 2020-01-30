//
//  ItemRealmRepository.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

protocol ItemRealmModelable: Object {
    dynamic var itemId: Int { get }
    dynamic var keyword: String { get }
    dynamic var typeString: String { get }
}

final class ItemRealmRepository<Model: ItemRealmModelable> {

    static func find() -> Observable<[Model]> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let objects = realm.objects(Model.self)
                let models: [Model] = objects.map { $0 }
                observer.onNext(models)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    static func find(keyword: String, type: ListRealmType) -> Observable<Model?> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let object = realm.objects(Model.self)
                    .filter { $0.keyword == keyword && $0.typeString == type.rawValue }
                    .first
                observer.onNext(object)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    static func save(item: ItemRealmModelable, completion: @escaping (Result<Any?, NSError>) -> Void) {
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

    static func delete(item: ItemRealmModelable, completion: @escaping (Result<Any?, NSError>) -> Void) {
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

    static func update(item: ItemRealmModelable, completion: @escaping (Result<Any?, NSError>) -> Void) {
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
