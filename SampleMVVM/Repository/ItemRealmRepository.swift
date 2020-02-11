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

    static func save(item: ItemRealmModelable) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(item)
                    completable(.completed)
                }
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }

    static func delete(item: ItemRealmModelable) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                let deleteItem = realm.objects(Model.self).filter { $0.itemId == item.itemId }
                try realm.write {
                    realm.delete(deleteItem)
                    completable(.completed)
                }
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }

    static func update(item: ItemRealmModelable) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(item, update: .all)
                    completable(.completed)
                }
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
