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
