//
//  APIGatewayProtocol.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol APIGatewayProtocol {
    // MARK: - Item
    func fetchItems() -> Single<[Item]>
    func postItem(item: Item) -> Completable
    func deleteItem(id: Int) -> Completable
    func putItem(id: Int, item: Item) -> Completable
    // MARK: - Github
    func fetchGithubRepositories(query: String) -> Single<[GithubRepository]>
}
