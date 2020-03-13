//
//  APIClient+LineLogin.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/26.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa
import LineSDK

extension APIClient {
    func lineLogin(viewController: UIViewController) -> Single<LineUser> {
        return Single<LineUser>.create { single in
            LoginManager.shared.login(permissions: [.profile, .openID], in: viewController) { result in
                switch result {
                case .success(let loginResult):
                    let lineUser = LineUser(loginResult: loginResult)
                    single(.success(lineUser))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
