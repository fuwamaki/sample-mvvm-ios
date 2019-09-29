//
//  ItemRegisterViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/29.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ItemRegisterViewModelable {
    
}

final class ItemRegisterViewModel {

    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()

    var isLoading = BehaviorRelay<Bool>(value: false)

}

extension ItemRegisterViewModel: ItemRegisterViewModelable {
}
