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
    func handleChangeImageButton()
    func handleSubmitButton()
}

final class UserRegistrationViewModel {
}

extension UserRegistrationViewModel: UserRegistrationViewModelable {
    func handleChangeImageButton() {
        
    }

    func handleSubmitButton() {
        
    }
}
