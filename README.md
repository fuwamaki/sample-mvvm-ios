## 概要

本リポジトリは、iOSのMVVMアーキテクチャを採用したサンプルコードである。
MVVMアーキテクチャを採用したコードの形は、チームによって、あるいは人によって異なる。
このリポジトリはあくまで一例であり、これを見た人で意見があれば、ぜひissueでコメントして欲しい。

## MVVMアーキテクチャについて

iOSのMVVMとは、Model, ViewController, ViewModelの3つの層に分けた、
アーキテクチャ構造のことを指す。

本リポジトリでは、以下の図の構造を意識している。

<img width="1208" alt="MVVM" src="https://user-images.githubusercontent.com/30719264/73118195-53b06400-3f94-11ea-8ba6-e04a5e157396.png">

以下補足。

- ViewController層: UI層。画面遷移などUI操作を行うが、ロジックは持たない。ViewControllerだけでなく、Viewクラスも含む。
- ViewModel層: UI層・Model層のロジックを持つ層。UnitTestの対象。
- Model層: データの管理や操作を行う層。
  - Entity: オブジェクトクラス。UnitTestの対象。
  - Repository: ローカルデータの読込・検索・削除・更新などを行うクラス。UnitTestの対象。
  - APIClient: APIアクセスを行うクラス。

## 実現している機能

MVVMアーキテクチャを採用したシステム、以下の機能を実現している。

### 1. Itemの取得・追加・削除・更新

APIのGET・POST・DELETE・PUTを学ぶために。

- Itemの一覧表示・削除: ItemViewControllerなど
- Itemの登録・更新: ItemRegisterViewControllerなど

### 2. 並列処理で複数のAPI取得

複数のAPIの扱いを学ぶために。
Githubのリポジトリ一覧取得APIでお気に入り登録したもの、
Qiitaの記事一覧取得APIでお気に入り登録したものを、まとめて一覧で表示する。

- GithubリポジトリとQiita記事のお気に入り表示: ListViewControllerなど
- Githubのリポジトリ一覧取得とお気に入り登録: GithubViewControllerなど
- Qiitaの記事一覧取得とお気に入り登録: QiitaViewControllerなど

### 3. 新規登録・ログイン

ローカルデータの扱いを学ぶために。
新規登録・ログインは、UrlSchemeとUniversalLink周りも学べるLINEログインを採用した。

- 新規登録・ログインへの導線、ユーザ情報の表示: MypageViewControllerなど

## 使用ライブラリ

- Rx系: ViewModelのbindingを実現するために
  - https://github.com/ReactiveX/RxSwift
  - https://github.com/RxSwiftCommunity/RxOptional
  - https://github.com/ReactiveX/RxSwift/tree/master/RxTest
  - https://github.com/ReactiveX/RxSwift/tree/master/RxBlocking
- RealmSwift: ローカルデータを管理しやすくするために
  - https://github.com/realm/realm-cocoa
- PINRemoteImage: 画像を取得しやすくするために
  - https://github.com/pinterest/PINRemoteImage
- Alamofire: APIアクセスしやすくするために
  - https://github.com/Alamofire/Alamofire
- LineSDKSwift: LINEログインのために
  - https://github.com/line/line-sdk-ios-swift
- SwiftLint: 静的解析ツール
  - https://github.com/realm/SwiftLint
- R.swift: imageやstoryboardなどのtypo防止
  - https://github.com/mac-cain13/R.swift

## 具体的なコードの説明

詳しい説明はReadmeには記載しない。
コードにコメントを書いたりしているので、コードを見て欲しい。