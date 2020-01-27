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
    var dismissSubject: BehaviorRelay<Bool> { get }
    var name: BehaviorRelay<String?> { get }
    var birthday: BehaviorRelay<Date?> { get }
    var iconImageURL: BehaviorRelay<URL?> { get }
    var uploadImage: BehaviorRelay<UIImage?> { get }
    var presentViewController: Driver<UIViewController> { get }
    func handleChangeImageButton(_ imagePickerController: UIImagePickerController)
    func handleSubmitButton()
    func imagePicker(_ picker: UIImagePickerController, info: [UIImagePickerController.InfoKey: Any], viewController: UserRegistrationViewController)
    func cropView(_ cropViewController: CropViewController, image: UIImage)
}

final class UserRegistrationViewModel {

    var dismissSubject = BehaviorRelay<Bool>(value: false)
    var name = BehaviorRelay<String?>(value: nil)
    var birthday = BehaviorRelay<Date?>(value: nil)
    var iconImageURL = BehaviorRelay<URL?>(value: nil)

    var uploadImage = BehaviorRelay<UIImage?>(value: nil)

    private var presentViewControllerSubject = PublishRelay<UIViewController>()
    var presentViewController: Driver<UIViewController> {
        return presentViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    private let disposeBag = DisposeBag()
    private let type: UserRegistrationType
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
    func handleChangeImageButton(_ imagePickerController: UIImagePickerController) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            presentViewControllerSubject.accept(imagePickerController)
        }
    }

    func handleSubmitButton() {
        guard let name = name.value, let birthday = birthday.value else {
            let errorAlert = UIAlertController.singleErrorAlert(message: "未入力の項目があります")
            presentViewControllerSubject.accept(errorAlert)
            return
        }
        let entity = UserRealmEntity()
        switch type {
        case .create(let lineUser):
            guard let userId = lineUser.userId else {
                let errorAlert = UIAlertController.singleErrorAlert(message: "エラーが発生しました。再度ログインし直してください。") {
                    self.dismissSubject.accept(true)
                }
                presentViewControllerSubject.accept(errorAlert)
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
            case .failure:
                let errorAlert = UIAlertController.singleErrorAlert(message: "保存に失敗しました")
                self?.presentViewControllerSubject.accept(errorAlert)
            }
        }
    }
}

// MARK: imagePickerController
extension UserRegistrationViewModel {
    func imagePicker(_ picker: UIImagePickerController, info: [UIImagePickerController.InfoKey: Any], viewController: UserRegistrationViewController) {
        if let image = info[.originalImage] as? UIImage {
            let cropViewController = CropViewController(croppingStyle: .circular, image: image)
            cropViewController.delegate = viewController
            picker.pushViewController(cropViewController, animated: true)
        }
    }
}

// MARK: CropViewController
extension UserRegistrationViewModel {
    func cropView(_ cropViewController: CropViewController, image: UIImage) {
        uploadImage.accept(image)
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
