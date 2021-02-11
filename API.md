# API仕様
## エンドポイント
テスト環境では
```localhost:3000/api/v1```
## データ形式
```application/json```
## 認証
認証が必要なリクエストでは，予め```POST /login```でトークンを取得し，
```
Authorization: Token (取得したトークン)
```
をHTTPヘッダに付与してからリクエストを送る．
(トークンは発行してから１時間有効)
## エラーレスポンス
エラーが発生した場合は以下の形式のJSONが返ってくる．
```
{   
    "status":404,
    "error":"error message"
}
```

## POST /login
### 概要
ログインしてトークンを取得する．
### 認証
必要なし
### リクエストボディ
```
{   
    "email":"example@example.com",
    "password":"password"
}
```
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 204 | created |
```
{
    "token":"xxxxxxxxxxxx"
}
```

## DELETE /login
### 概要
トークンを破棄する．
### 認証
必要あり
### リクエストボディ
なし
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 200 | ok |
なし

## GET /user
### 概要
user情報を取得する
### 認証
必要あり
### リクエストボディ
なし
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 200 | ok |
```
{
    "id":1,
    "name":"username",
    "email":"example@example.com"
}
```

## POST /user
### 概要
新規ユーザーを作成する
### 認証
必要なし
### リクエストボディ
```
{
    "name":"username",
    "password":"password",
    "email":"example@example.com"
}
```

### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 204 | created |
```
{
    "id":1,
    "name":"username",
    "email":"example@example.com"
}
```

## PATCH/PUT /user
### 概要
ユーザー情報を更新する
### 認証
必要あり
### リクエストボディ
```
{
    "name":"username",
    "password":"password",
    "email":"example@example.com"
}
```
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 200 | ok |
```
{
    "id":1,
    "name":"username",
    "email":"example@example.com"
}
```

## DELETE /user
### 概要
ユーザーを削除する
### 認証
必要あり
### リクエストボディ
なし
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 200 | ok |
なし

## GET /tasks
### 概要
ユーザーが持つタスクの一覧を取得する
### クエリパラメータ
| key | value | 説明 |
|:---:|:---:|:---:|
| iscomp | true/false | タスクの完了状態によって絞り込み |
| start | yyyy-mm-dd | タスクの締切による絞り込み範囲の始点 |
| end | yyyy-mm-dd | タスクの締切による絞り込み範囲の終点 |
### 認証
必要あり
### リクエストボディ
なし
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 200 | ok |
```
[
  {
      "id":1,
      "title":"task1",
      "content":"This is a content.",
      "is_completed":false,
      "deadline":"2020-02-11"
  },
  {
      "id":2,
      "title":"task1,
      "content":"This is a content.",
      "is_completed":true,
      "deadline":"2020-02-11"
  }
]
```

## GET /tasks/:id
### 概要
idで指定されたタスクを取得する
### パスパラメータ
| key | 説明 |
|:---:|:---:|
| id | タスクのid |
### 認証
必要あり
### リクエストボディ
なし
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 200 | ok |
```
{
    "id":1,
    "title":"task1,
    "content":"This is a content.",
    "is_completed":false,
    "deadline":"2020-02-11"
}
```

## CREATE /task
### 概要
新規タスクを作成する
### 認証
必要あり
### リクエストボディ
```
{
    "title":"task1,
    "content":"This is a content.",
    "is_completed":false,
    "deadline":"2020-02-11"
}
```
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 204 | created |
```
{
    "id":1,
    "title":"task1,
    "content":"This is a content.",
    "is_completed":false,
    "deadline":"2020-02-11"
}
```

## PUT /tasks/:id
### 概要
タスク情報を更新する
### パスパラメータ
| key | 説明 |
|:---:|:---:|
| id | タスクのid |
### 認証
必要あり
### リクエストボディ
```
{
    "title":"task1,
    "content":"This is a content.",
    "is_completed":false,
    "deadline":"2020-02-11"
}
```
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 200 | ok |
```
{
    "id":1,
    "title":"task1,
    "content":"This is a content.",
    "is_completed":false,
    "deadline":"2020-02-11"
}
```

## DELETE /tasks/:id
### 概要
タスクを削除する
### パスパラメータ
| key | 説明 |
|:---:|:---:|
| id | タスクのid |
### 認証
必要あり
### リクエストボディ
なし
### レスポンスボディ
| code | 補足 |
|:---:|:---:|
| 200 | ok |
なし