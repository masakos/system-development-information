# TODOアプリのシーケンス図

[クラス図](class_diagram.md) と [Javaプログラム](java/) をもとに、`Main` を実行したときに **どのオブジェクトが、どの順番で、どのメソッドを呼び出すか** をシーケンス図で表します。

---

## 1. シーケンス図

```mermaid
sequenceDiagram
    autonumber
    participant M as Main
    participant A as app : TodoApp
    participant U as tanaka : User
    participant C as school : Category
    participant T as task : Task

    rect rgb(235, 245, 255)
    Note over M,C: ① ユーザー・カテゴリを登録する（機能1・3）
    M ->> A: registerUser("田中")
    A ->> U: new User(1, "田中")
    A ->> A: users.add(user)
    A -->> M: tanaka
    M ->> A: addCategory("学校")
    A ->> C: new Category(1, "学校")
    A ->> A: categories.add(category)
    A -->> M: school
    end

    rect rgb(235, 255, 235)
    Note over M,T: ② TODOを登録する（機能2）
    M ->> A: addTask("DBの課題", ..., tanaka, school)
    A ->> T: new Task(1, "DBの課題", ..., tanaka, school)
    A ->> A: tasks.add(task)
    A -->> M: task
    end

    rect rgb(255, 250, 230)
    Note over M,T: ③ TODO一覧を表示する（機能4）
    M ->> U: getName()
    U -->> M: "田中"
    M ->> A: findTasksByUser(tanaka)
    loop tasks の件数分
        A ->> T: getUser()
        T -->> A: user
        opt user == tanaka
            A ->> A: result.add(task)
        end
    end
    A -->> M: result（田中さんのTODO一覧）
    loop result の件数分
        M ->> T: toString()
        T ->> C: getName()
        C -->> T: "学校"
        T -->> M: "1 | DBの課題 | 学校 | 2026-10-30 | 未完了"
    end
    end

    rect rgb(255, 235, 235)
    Note over M,T: ④ TODOを完了にする（機能5）
    M ->> A: completeTask(1)
    loop tasks の件数分
        A ->> T: getId()
        T -->> A: id
        opt id == 1
            A ->> T: complete()
            Note right of T: completed = true
        end
    end
    end
```

> 図を見やすくするため、ユーザー・カテゴリ・TODOは1件ずつ（田中・学校・DBの課題）だけ登録しています。
> 実際の `Main` では、同じ流れを件数分くり返しています。

---

## 2. 記号の読み方

| 記号 | 意味 |
| ---- | ---- |
| `app : TodoApp` | 上の四角（ライフライン）。「オブジェクト名 : クラス名」 |
| 実線の矢印（`->>`） | メソッドの呼び出し（メッセージ） |
| 点線の矢印（`-->>`） | 呼び出し元への戻り値 |
| 自分自身への矢印 | 自分のフィールドを操作する（例：`users.add()`） |
| `loop` | くり返し（Javaの `for` 文） |
| `opt` | 条件を満たすときだけ実行（Javaの `if` 文） |
| 番号（1, 2, 3 …） | 処理が実行される順番 |

---

## 3. クラス図との違い

| 図 | わかること |
| -- | ---------- |
| クラス図 | どんなクラスがあり、どんなデータとメソッドを持つか（**構造**） |
| シーケンス図 | どのオブジェクトが、どの順番でメソッドを呼ぶか（**動き**） |

