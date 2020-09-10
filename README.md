## 概要

本リポジトリは、iOSのMVVMアーキテクチャを採用したサンプルコードである。
MVVMアーキテクチャを採用したコードの形は、開発チームによって、人によって異なり、公式で定義されていない。
このリポジトリのMVVMは、以下のサイト・本などに参考にし、独自に定義したものである。

- https://medium.com/macoclock/an-overview-of-the-mvvm-design-pattern-ee0293663e1f
- https://speakerdeck.com/sansanbuildersbox/architecture-to-support-eight-ios-2
- https://peaks.cc/books/iOS_architecture
- https://yktech.hatenablog.com/entry/2019/01/03/234757

このリポジトリはあくまでMVVMの一例であり、これを見た人で意見があれば、ぜひissueでコメントして欲しい。

## MVVMアーキテクチャについて

iOSのMVVMとは、Model, ViewController, ViewModelの3つの層に分けた、
アーキテクチャ構造のことを指す。

本リポジトリでは、以下の図の構造を意識している。

<img width="1208" alt="MVVM" src="https://user-images.githubusercontent.com/30719264/73118195-53b06400-3f94-11ea-8ba6-e04a5e157396.png">

以下補足。

- ViewController層: UI層。画面遷移などUI操作を行うが、ロジックは持たない。ViewControllerだけでなく、Viewクラスも含む。
- ViewModel層: UI層のビジネスロジックを持ち、加えてModel層のビジネスロジックを持つ層。Model層のビジネスロジックをUseCase層が持つMVVMアーキテクチャのケースもあるが、UseCase層があると頻繁にコード内容が薄くなり、レイヤーが増えるのでコード全体でみると見通しが悪くなりかねないので、本リポジトリではViewModel層に統合する形を採用した。UnitTestの対象。
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

| アイテム一覧 | アイテム登録 | アイテム削除 | アイテム更新 |
| --- | --- | --- | --- |
| <img src="https://user-images.githubusercontent.com/30719264/74211635-1e19b380-4cd4-11ea-99ca-f555a76138f7.png"> | <img src="https://user-images.githubusercontent.com/30719264/74211632-1ce88680-4cd4-11ea-8a02-23601be50489.png"> | <img src="https://user-images.githubusercontent.com/30719264/74211633-1d811d00-4cd4-11ea-9c55-a8ae2f054ebb.png"> | <img src="https://user-images.githubusercontent.com/30719264/74211631-1ce88680-4cd4-11ea-8566-408482dc932c.png"> |

### 2. 並列処理で複数のAPI取得

複数のAPIの扱いを学ぶために。
Githubのリポジトリ一覧取得APIでお気に入り登録したもの、
Qiitaの記事一覧取得APIでお気に入り登録したものを、まとめて一覧で表示する。

- GithubリポジトリとQiita記事のお気に入り表示: ListViewControllerなど
- Githubのリポジトリ一覧取得とお気に入り登録: GithubViewControllerなど
- Qiitaの記事一覧取得とお気に入り登録: QiitaViewControllerなど

| お気に入りリスト | Github検索 | Qiita検索 |
| --- | --- | --- |
| <img src="https://user-images.githubusercontent.com/30719264/74211630-1bb75980-4cd4-11ea-8cab-a680ce7b44d8.png" width=320px> | <img src="https://user-images.githubusercontent.com/30719264/74211628-1b1ec300-4cd4-11ea-96bf-26ff301d4043.png" width=320px> | <img src="https://user-images.githubusercontent.com/30719264/74211627-19ed9600-4cd4-11ea-8ec3-b48bd1eb2213.png" width=320px> |

### 3. 新規登録・ログイン

ローカルデータの扱いを学ぶために。
新規登録・ログインは、UrlSchemeとUniversalLink周りも学べるLINEログインを採用した。

- 新規登録・ログインへの導線、ユーザ情報の表示: MypageViewControllerなど

| マイページ 未ログイン | マイページ ログイン済み | ユーザ情報入力
| --- | --- | --- |
| <img src="https://user-images.githubusercontent.com/30719264/74211623-18bc6900-4cd4-11ea-90a5-e3ffe5a83062.png" width=320px> | <img src="https://user-images.githubusercontent.com/30719264/74211626-1954ff80-4cd4-11ea-9703-1c5228b49a3f.png" width=320px> | <img src="https://user-images.githubusercontent.com/30719264/74211622-178b3c00-4cd4-11ea-9fa1-b95fb29fe2e7.png" width=320px> |

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
