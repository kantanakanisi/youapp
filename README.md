# ①アプリケーションについて
## URL
URL:  現在進行中
github: https://github.com/Nakanisi-Kanta/youapp
## 概要
- アプリケーション名:「PUSHAR」
- 内容：プログラミングに関するサイトのURLを共有するアプリケーションです。
- 作成理由：関連するキーワードから、興味のあるWebサイトのURLのみを簡単に検索・保存するアプリが欲しいと感じたから。<br>『プログラミング学習において関連ページにどんどん進んで行ってしまうとGoogleタグの溜まりすぎで目的のページを見失ってしまうことがあったので、URLのみを共有できれば』の問題を**Programming + URL + Sharing**で解決することをコンセプトにしたアプリケーションです。<br>
![リロード機能](https://user-images.githubusercontent.com/35006561/91413161-aed96a80-e885-11ea-89a8-dcf338d116b3.gif)



# ②アプリケーションの詳細について
## 機能
- ログイン機能(firebase, 新規登録、ログイン、ログアウト, 退会も出来ます)<br><br>
![ログイン機能](https://user-images.githubusercontent.com/35006561/91411057-c6632400-e882-11ea-93ea-cf61bf4993c6.gif)
- パスワード再設定(firebase, 登録したメールアドレスにパスワード再設定用のurl発行できます)<br><br>
![パスワード再設定機能](https://user-images.githubusercontent.com/35006561/91411711-ad0ea780-e883-11ea-88df-48a7ebd976c0.gif)
- URL投稿機能(CRUD),modalによる投稿画面<br><br>
![URL投稿機能](https://user-images.githubusercontent.com/35006561/91411711-ad0ea780-e883-11ea-88df-48a7ebd976c0.gif)
- URL検索機能(Vueでのリアルタイム検索, URLに関する情報を検索出来ます)<br><br>
![URL検索機能](https://user-images.githubusercontent.com/35006561/91411711-ad0ea780-e883-11ea-88df-48a7ebd976c0.gif)
- アバター, 画像保存機能(activestorage, ユーザー画像をアップロード出来ます)<br>
![アバター画像保存機能](https://user-images.githubusercontent.com/35006561/91411711-ad0ea780-e883-11ea-88df-48a7ebd976c0.gif)
- プロフィール編集機能(ユーザーを登録、プロフィールを編集・削除出来ます)<br><br>
![プロフィール編集機能](https://user-images.githubusercontent.com/35006561/91411711-ad0ea780-e883-11ea-88df-48a7ebd976c0.gif)
- 自分の投稿へのピックアップ機能(自分投稿からイチオシをピックアップして、編集・削除出来ます)<br><br>
![ピックアップ機能](https://user-images.githubusercontent.com/35006561/91411711-ad0ea780-e883-11ea-88df-48a7ebd976c0.gif)
- 投稿へのストック機能(他人の投稿を簡単に保存可能です)<br><br>
![ストック機能](https://user-images.githubusercontent.com/35006561/91411711-ad0ea780-e883-11ea-88df-48a7ebd976c0.gif)
- フォロー,フォロワー機能(ユーザー同士でフォロー・フォロー解除出来ます)<br><br>
![フォロー・フォロワー機能](https://user-images.githubusercontent.com/35006561/91411711-ad0ea780-e883-11ea-88df-48a7ebd976c0.gif)

## 使用技術
- フロントエンド：Nuxt.js
- バックエンド: Ruby on Rails(api), rspec, rubocop
- インフラ: AWSを予定

## 現状
- 本番環境に関してはECSでのデプロイを予定しております。

# ③補足
## データベース(テーブル設計)
## User テーブル

| Column           | Type   | Options                       |
| ---------------- | ------ | ----------------------------- |
| name             | string | null: false                   |
| email            | email  | null: false, uniqueness: true |
| uid              | string | null: false                   |
| profile          | text   | null: false                   |


### アソシエーション

- has_one_attached :avatar
- has_many :posts
- has_many :likes
- has_many :pickups
- has_many :following_relationships, foreign_key: 'follower_id', class_name: 'Relationship'
- has_many :followings, through: :following_relationships
- has_many :follower_relationships, foreign_key: 'following_id', class_name: 'Relationship'
- has_many :followers, through: :follower_relationships

## Post テーブル

| Column         | Type       | Options                  |
| -------------- | ---------- | ------------------------ |
| user           | references | null: false, foreign_key |
| title          | string     | null: false              |
| point          | text       | null: false              |

### アソシエーション

- belongs_to :user
- has_many :links
- has_many :likes
- has_many :pickups

## Link テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| post          | references | null: false, foreign_key: true |
| url           | string     |                                |
| og_title      | string     |                                |
| og_image      | text       |                                |
| og_description| string     |                                |
| og_url        | string     |                                |

### アソシエーション

- belongs_to :post


## Like テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| user          | references | null: false, foreign_key       |
| post          | references | null: false, foreign_key: true | 

### アソシエーション

- belongs_to :user
- belongs_to :post


## Pickup テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | -----------------------------  |
| user          | references | null: false, foreign_key       |
| post          | references | null: false, foreign_key: true | 

### アソシエーション

- belongs_to :post
- belongs_to :user

## Relationship テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | -----------------------------  |
| follower_id   | integer    | null: false, uniqueness: true  |
| following_id  | integer    | null: false, uniqueness: true  |

### アソシエーション

- belongs_to :follower, class_name: 'User'
- belongs_to :following, class_name: 'User'

## インフラ構成図
作成中
