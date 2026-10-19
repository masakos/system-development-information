## SQLite

https://sqlite.org/whentouse.html

- SQLite は、RDBMS（リレーショナルデータベース管理システム）の一つ
- データベース全体が **1つのファイル**（例：`school.db`）に保存される
- サーバーを立てずに使えるので、「アプリと同じ場所にデータベースを置いて、シンプルに使う」用途に向いている
- この授業では、SQLite を画面から操作できる **DB Browser for SQLite** を使う

## DB Browser for SQLite の準備

https://sqlitebrowser.org/

ダウンロードページから `DB Browser for SQLite - Standard installer for 64-bit Windows` をダウンロードする。

1. DB Browser for SQLite をインストールする
2. フォルダを作成して、`school.db` をそのフォルダに置く
   - 例：`C:\Users\ユーザー名\sql_lessons\school.db`
3. DB Browser を起動し、「ファイル」＞「データベースを開く」で `school.db` を開く
4. 「データベース構造」タブで、テーブルの一覧を確認する
5. 「SQL実行」タブに SQL を書いて、`Ctrl + Enter` で実行する
