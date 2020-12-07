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
    var iconImageURL: BehaviorRelay<URL?> { get }
    var uploadImage: BehaviorRelay<UIImage?> { get }
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
    private(set) var iconImageURL = BehaviorRelay<URL?>(value: nil)

    var uploadImage = BehaviorRelay<UIImage?>(value: nil)

    private var presentScreenSubject = PublishRelay<Screen>()
    var presentScreen: Driver<Screen> {
        return presentScreenSubject.asDriver(onErrorJustReturn: .other)
    }

    private let disposeBag = DisposeBag()
    var type: UserRegistrationType
    private let lineAccessToken: String

    init(type: UserRegistrationType) {
        self.type = type
        switch type {
        case .create(let lineUser):
            lineAccessToken = lineUser.accessToken
            name.accept(lineUser.displayName)
            iconImageURL.accept(lineUser.pictureURL)
        case .update(let user):
            lineAccessToken = user.lineAccessToken
            name.accept(user.name)
            birthday.accept(user.birthday)
            iconImageURL.accept(user.iconImageURL)
            if let data = user.iconImage, let image = UIImage(data: data) {
                uploadImage.accept(image)
            }
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
        guard let name = name.value, let birthday = birthday.value else {
            presentScreenSubject.accept(.errorAlert(message: "未入力の項目があります"))
            return
        }
        let entity = UserRealmEntity()
        switch type {
        case .create(let lineUser):
            guard let userId = lineUser.userId else {
                presentScreenSubject.accept(.errorAlertAndDismiss(message: "エラーが発生しました。再度ログインし直してください。"))
                return
            }
            entity.userId = userId
            entity.name = name
            entity.birthday = birthday
            entity.iconImageUrl = iconImageURL.value?.absoluteString ?? ""
            entity.iconImageData = uploadImage.value?.pngData() ?? Data()
        case .update(let user):
            entity.userId = user.userId
            entity.name = name
            entity.birthday = birthday
            entity.iconImageUrl = iconImageURL.value?.absoluteString ?? ""
            entity.iconImageData = uploadImage.value?.pngData() ?? Data()
        }
        UserRealmRepository<UserRealmEntity>.save(user: entity) { [weak self] result in
            switch result {
            case .success:
                UserDefaultsRepository.shared.userId = entity.userId
                UserDefaultsRepository.shared.lineAccessToken = self?.lineAccessToken
                UserDefaultsRepository.shared.name = entity.name
                UserDefaultsRepository.shared.birthday = DateFormat.yyyyMMdd.string(from: entity.birthday)
                if entity.iconImageUrl != "", let imageUrl = URL(string: entity.iconImageUrl) {
                    UserDefaultsRepository.shared.pictureUrl = imageUrl
                }
                if let iconImage = self?.uploadImage.value {
                    UserDefaultsRepository.shared.iconImage = iconImage.pngData()
                }
                self?.dismissSubject.accept(true)
                self?.completedSubject.accept(true)
            case .failure:
                self?.presentScreenSubject.accept(.errorAlert(message: "保存に失敗しました"))
            }
        }
    }
}

// MARK: imagePickerController
extension UserRegistrationViewModel {
    func imagePicker(_ picker: UIImagePickerController,
                     info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            presentScreenSubject.accept(.crop(picker: picker, image: image))
        }
    }
}

// MARK: CropViewController
extension UserRegistrationViewModel {
    func cropView(image: UIImage) {
        uploadImage.accept(image)
        cropDismissSubject.accept(true)
    }
}
