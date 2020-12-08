//
//  UserRegistrationViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/25.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa
import CropViewController

protocol UserRegistrationViewModelable {
    var type: UserRegistrationType { get }
    var dismissSubject: BehaviorRelay<Bool> { get }
    var completedSubject: BehaviorRelay<Bool> { get }
    var name: BehaviorRelay<String?> { get }
    var birthday: BehaviorRelay<Date?> { get }
    var iconImageUrl: BehaviorRelay<URL?> { get }
    var iconImage: BehaviorRelay<UIImage?> { get }
    var presentScreen: Driver<Screen> { get }
    func handleChangeImageButton()
    func handleSubmitButton()
    func imagePicker(_ picker: UIImagePickerController, info: [UIImagePickerController.InfoKey: Any])
    func cropView(image: UIImage)
}

final class UserRegistrationViewModel {

    private(set) var dismissSubject = BehaviorRelay<Bool>(value: false)
    private(set) var cropDismissSubject = BehaviorRelay<Bool>(value: false)
    private(set) var completedSubject = BehaviorRelay<Bool>(value: false)
    private(set) var name = BehaviorRelay<String?>(value: nil)
    private(set) var birthday = BehaviorRelay<Date?>(value: nil)
    private(set) var iconImageUrl = BehaviorRelay<URL?>(value: nil)
    private(set) var iconImage = BehaviorRelay<UIImage?>(value: nil)

    private var presentScreenSubject = PublishRelay<Screen>()
    var presentScreen: Driver<Screen> {
        return presentScreenSubject.asDriver(onErrorJustReturn: .other)
    }

    private let disposeBag = DisposeBag()
    var type: UserRegistrationType
    private let token: String

    init(type: UserRegistrationType) {
        self.type = type
        switch type {
        case .createAppleUser(let user):
            token = user.token
            name.accept(user.name)
        case .createLineUser(let user):
            token = user.token
            name.accept(user.displayName)
            iconImageUrl.accept(user.pictureUrl)
        case .update(let user):
            token = user.token
            name.accept(user.name)
            birthday.accept(user.birthday)
            if let data = user.iconImage,
               let image = UIImage(data: data) {
                iconImage.accept(image)
            }
        }
    }

    private func createUser(name: String, birthday: Date) -> (userEntity: UserRealmEntity, user: User) {
        let entity = UserRealmEntity()
        switch type {
        case .createAppleUser(let user):
            entity.userType = UserType.apple.rawValue
            entity.userId = user.userId
            entity.name = user.name
            entity.birthday = birthday
            entity.iconImageData = iconImage.value?.pngData() ?? Data()
            let value = User(userType: .apple, token: user.token, userId: user.userId,
                             name: name, birthday: birthday, iconImage: iconImage.value?.pngData())
            return (entity, value)
        case .createLineUser(let user):
            entity.userType = UserType.line.rawValue
            entity.userId = user.userId
            entity.name = name
            entity.birthday = birthday
            entity.iconImageData = iconImage.value?.pngData() ?? Data()
            let value = User(userType: .line, token: user.token, userId: user.userId,
                             name: name, birthday: birthday, iconImage: iconImage.value?.pngData())
            return (entity, value)
        case .update(let user):
            entity.userType = user.userType.rawValue
            entity.userId = user.userId
            entity.name = name
            entity.birthday = birthday
            entity.iconImageData = iconImage.value?.pngData() ?? Data()
            let value = User(userType: user.userType, token: user.token, userId: user.userId,
                             name: name, birthday: birthday, iconImage: iconImage.value?.pngData())
            return (entity, value)
        }
    }
}

// MARK: UserRegistrationViewModelable
extension UserRegistrationViewModel: UserRegistrationViewModelable {
    func handleChangeImageButton() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            presentScreenSubject.accept(.imagePicker)
        }
    }

    func handleSubmitButton() {
        guard let name = name.value,
              let birthday = birthday.value else {
            presentScreenSubject.accept(
                .errorAlert(message: R.string.localizable.error_not_input()))
            return
        }
        let value = createUser(name: name, birthday: birthday)
        UserRealmRepository<UserRealmEntity>.save(user: value.userEntity) { [weak self] result in
            switch result {
            case .success:
                UserDefaultsRepository.shared.createUser(user: value.user)
                self?.dismissSubject.accept(true)
                self?.completedSubject.accept(true)
            case .failure:
                self?.presentScreenSubject.accept(
                    .errorAlert(message: R.string.localizable.error_realm_save()))
            }
        }
    }
}

// MARK: imagePickerController
extension UserRegistrationViewModel {
    func imagePicker(_ picker: UIImagePickerController, info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            presentScreenSubject.accept(.crop(picker: picker, image: image))
        }
    }
}

// MARK: CropViewController
extension UserRegistrationViewModel {
    func cropView(image: UIImage) {
        iconImage.accept(image)
        cropDismissSubject.accept(true)
    }
}
