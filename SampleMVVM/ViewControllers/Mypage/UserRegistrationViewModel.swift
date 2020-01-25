//
//  UserRegistrationViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/25.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UserRegistrationViewModelable {
    var residence: BehaviorRelay<Date> { get }
    func handleChangeImageButton()
    func handleSubmitButton()
}

final class UserRegistrationViewModel {

    var residence = BehaviorRelay<Date>(value: Date())
}

extension UserRegistrationViewModel: UserRegistrationViewModelable {
    func handleChangeImageButton() {
    }

    func handleSubmitButton() {
    }
}
