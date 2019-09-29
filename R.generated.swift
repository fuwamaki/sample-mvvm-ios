//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.image` struct is generated, and contains static references to 2 images.
  struct image {
    /// Image `first`.
    static let first = Rswift.ImageResource(bundle: R.hostingBundle, name: "first")
    /// Image `second`.
    static let second = Rswift.ImageResource(bundle: R.hostingBundle, name: "second")
    
    /// `UIImage(named: "first", bundle: ..., traitCollection: ...)`
    static func first(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.first, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "second", bundle: ..., traitCollection: ...)`
    static func second(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.second, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 4 nibs.
  struct nib {
    /// Nib `CollectionListCell`.
    static let collectionListCell = _R.nib._CollectionListCell()
    /// Nib `GithubCollectionCell`.
    static let githubCollectionCell = _R.nib._GithubCollectionCell()
    /// Nib `ItemTableCell`.
    static let itemTableCell = _R.nib._ItemTableCell()
    /// Nib `QiitaCollectionCell`.
    static let qiitaCollectionCell = _R.nib._QiitaCollectionCell()
    
    /// `UINib(name: "CollectionListCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.collectionListCell) instead")
    static func collectionListCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.collectionListCell)
    }
    
    /// `UINib(name: "GithubCollectionCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.githubCollectionCell) instead")
    static func githubCollectionCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.githubCollectionCell)
    }
    
    /// `UINib(name: "ItemTableCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.itemTableCell) instead")
    static func itemTableCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.itemTableCell)
    }
    
    /// `UINib(name: "QiitaCollectionCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.qiitaCollectionCell) instead")
    static func qiitaCollectionCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.qiitaCollectionCell)
    }
    
    static func collectionListCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> CollectionListCell? {
      return R.nib.collectionListCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? CollectionListCell
    }
    
    static func githubCollectionCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GithubCollectionCell? {
      return R.nib.githubCollectionCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GithubCollectionCell
    }
    
    static func itemTableCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> ItemTableCell? {
      return R.nib.itemTableCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ItemTableCell
    }
    
    static func qiitaCollectionCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> QiitaCollectionCell? {
      return R.nib.qiitaCollectionCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? QiitaCollectionCell
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 6 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `CollectionListCell`.
    static let collectionListCell: Rswift.ReuseIdentifier<CollectionListCell> = Rswift.ReuseIdentifier(identifier: "CollectionListCell")
    /// Reuse identifier `GithubCollectionCell`.
    static let githubCollectionCell: Rswift.ReuseIdentifier<GithubCollectionCell> = Rswift.ReuseIdentifier(identifier: "GithubCollectionCell")
    /// Reuse identifier `GithubTableCell`.
    static let githubTableCell: Rswift.ReuseIdentifier<GithubTableCell> = Rswift.ReuseIdentifier(identifier: "GithubTableCell")
    /// Reuse identifier `ItemTableCell`.
    static let itemTableCell: Rswift.ReuseIdentifier<ItemTableCell> = Rswift.ReuseIdentifier(identifier: "ItemTableCell")
    /// Reuse identifier `QiitaCollectionCell`.
    static let qiitaCollectionCell: Rswift.ReuseIdentifier<QiitaCollectionCell> = Rswift.ReuseIdentifier(identifier: "QiitaCollectionCell")
    /// Reuse identifier `QiitaTableCell`.
    static let qiitaTableCell: Rswift.ReuseIdentifier<QiitaTableCell> = Rswift.ReuseIdentifier(identifier: "QiitaTableCell")
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 6 storyboards.
  struct storyboard {
    /// Storyboard `ItemRegisterViewController`.
    static let itemRegisterViewController = _R.storyboard.itemRegisterViewController()
    /// Storyboard `ItemViewController`.
    static let itemViewController = _R.storyboard.itemViewController()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `ListViewController`.
    static let listViewController = _R.storyboard.listViewController()
    /// Storyboard `MainTabBarViewController`.
    static let mainTabBarViewController = _R.storyboard.mainTabBarViewController()
    /// Storyboard `MypageViewController`.
    static let mypageViewController = _R.storyboard.mypageViewController()
    
    /// `UIStoryboard(name: "ItemRegisterViewController", bundle: ...)`
    static func itemRegisterViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.itemRegisterViewController)
    }
    
    /// `UIStoryboard(name: "ItemViewController", bundle: ...)`
    static func itemViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.itemViewController)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "ListViewController", bundle: ...)`
    static func listViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.listViewController)
    }
    
    /// `UIStoryboard(name: "MainTabBarViewController", bundle: ...)`
    static func mainTabBarViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.mainTabBarViewController)
    }
    
    /// `UIStoryboard(name: "MypageViewController", bundle: ...)`
    static func mypageViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.mypageViewController)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 2 localization tables.
  struct string {
    /// This `R.string.launchScreen` struct is generated, and contains static references to 0 localization keys.
    struct launchScreen {
      fileprivate init() {}
    }
    
    /// This `R.string.localizable` struct is generated, and contains static references to 1 localization keys.
    struct localizable {
      /// en translation: yen
      /// 
      /// Locales: en, ja
      static let yen = Rswift.StringResource(key: "yen", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
      
      /// en translation: yen
      /// 
      /// Locales: en, ja
      static func yen(_: Void = ()) -> String {
        return NSLocalizedString("yen", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    struct _CollectionListCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = CollectionListCell
      
      let bundle = R.hostingBundle
      let identifier = "CollectionListCell"
      let name = "CollectionListCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> CollectionListCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? CollectionListCell
      }
      
      fileprivate init() {}
    }
    
    struct _GithubCollectionCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "GithubCollectionCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GithubCollectionCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GithubCollectionCell
      }
      
      func secondView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[1] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _ItemTableCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = ItemTableCell
      
      let bundle = R.hostingBundle
      let identifier = "ItemTableCell"
      let name = "ItemTableCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> ItemTableCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ItemTableCell
      }
      
      fileprivate init() {}
    }
    
    struct _QiitaCollectionCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = QiitaCollectionCell
      
      let bundle = R.hostingBundle
      let identifier = "QiitaCollectionCell"
      let name = "QiitaCollectionCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> QiitaCollectionCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? QiitaCollectionCell
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try itemRegisterViewController.validate()
      try itemViewController.validate()
      try launchScreen.validate()
      try listViewController.validate()
      try mainTabBarViewController.validate()
      try mypageViewController.validate()
    }
    
    struct itemRegisterViewController: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = ItemRegisterViewController
      
      let bundle = R.hostingBundle
      let name = "ItemRegisterViewController"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct itemViewController: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let itemViewController = StoryboardViewControllerResource<ItemViewController>(identifier: "ItemViewController")
      let name = "ItemViewController"
      
      func itemViewController(_: Void = ()) -> ItemViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: itemViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "a.circle", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'a.circle' is used in storyboard 'ItemViewController', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.itemViewController().itemViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'itemViewController' could not be loaded from storyboard 'ItemViewController' as 'ItemViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct listViewController: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let listViewController = StoryboardViewControllerResource<ListViewController>(identifier: "ListViewController")
      let name = "ListViewController"
      
      func listViewController(_: Void = ()) -> ListViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: listViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "b.circle", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'b.circle' is used in storyboard 'ListViewController', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.listViewController().listViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'listViewController' could not be loaded from storyboard 'ListViewController' as 'ListViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct mainTabBarViewController: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = MainTabBarViewController
      
      let bundle = R.hostingBundle
      let mainTabBarViewController = StoryboardViewControllerResource<MainTabBarViewController>(identifier: "MainTabBarViewController")
      let name = "MainTabBarViewController"
      
      func mainTabBarViewController(_: Void = ()) -> MainTabBarViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: mainTabBarViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.mainTabBarViewController().mainTabBarViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'mainTabBarViewController' could not be loaded from storyboard 'MainTabBarViewController' as 'MainTabBarViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct mypageViewController: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let mypageViewController = StoryboardViewControllerResource<MypageViewController>(identifier: "MypageViewController")
      let name = "MypageViewController"
      
      func mypageViewController(_: Void = ()) -> MypageViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: mypageViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "c.circle", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'c.circle' is used in storyboard 'MypageViewController', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.mypageViewController().mypageViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'mypageViewController' could not be loaded from storyboard 'MypageViewController' as 'MypageViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
