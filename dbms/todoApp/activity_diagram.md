# TODOアプリのアクティビティ図

[クラス図](class_diagram.md)・[シーケンス図](sequence_diagram.md) と同じ [Javaプログラム](java/) をもとに、**処理の流れ（順番・分岐・くり返し）** をアクティビティ図で表します。


## 1. アプリ全体の流れ（Main）

`Main` を実行したときの処理の流れです。

```plantuml
@startuml
title アプリ全体の流れ（Main）

start
:ユーザーを登録する\nregisterUser();
:カテゴリを登録する\naddCategory();
repeat
  :TODOを登録する\naddTask();
repeat while (登録するTODOがまだある？) is (はい) not (いいえ)
:TODO一覧を表示する\nfindTasksByUser();
:TODOを完了にする\ncompleteTask();
:TODO一覧を表示する\nfindTasksByUser();
stop
@enduml
```

![アクティビティ図](../../images/todo_activity_uml.png)

---


## 3つの図の違い

| 図 | わかること |
| -- | ---------- |
| クラス図 | どんなクラスがあり、どんなデータとメソッドを持つか（**構造**） |
| シーケンス図 | どのオブジェクトが、どの順番でメソッドを呼ぶか（**オブジェクト間のやりとり**） |
| アクティビティ図 | どんな順番・条件・くり返しで処理が進むか（**処理の流れ**） |
