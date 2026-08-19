
INSERT INTO テーブル名 (カラム1, カラム2, カラム3)
VALUES (値1, 値2, 値3);


---

##  主キー・外部キーを理解する（このデータベースの土台）
- 主キー（PRIMARY KEY）とは
    - 1つの表の中で「1行を一意に区別するための列」。
    -  同じ値を持つ行が2つ存在することは絶対にない（重複NG）。
- 外部キー（FOREIGN KEY）とは
    - 別の表の主キーを指し示す列」。この列があることで、2つの表が"どう関係しているか"を表現できる。
    
### このデータベース全体の主キー・外部キーの一覧：
```
classes  … 主キー: class_id
students … 主キー: student_id ／ 外部キー: class_id  （→ classes.class_id）
subjects … 主キー: subject_id
scores   … 主キー: score_id   ／ 外部キー: student_id（→ students.student_id）
                                外部キー: subject_id （→ subjects.subject_id）
```


- STEP0-1. classesテーブルを見る（主キー class_id を確認する）
```sql
SELECT * FROM classes;
```

- STEP0-2. studentsテーブルを見る（class_id という列に注目する）
```sql
SELECT student_id, student_name, class_id FROM students;
```
↑ studentsの class_id の値（1, 2, 3）が、上で見た classes.class_id と
同じ値になっていることを確認する。これが「外部キーで繋がっている」状態。

- 例：class_id = 1 の学生 → classesの1行目（1年A組・佐藤先生）に所属、とわかる

- STEP0-3. 主キーは重複しない、ということを数字で確認する
```
SELECT COUNT(*) AS 全行数, COUNT(DISTINCT student_id) AS 重複を除いた数
FROM students;
```

↑ 2つの数値が同じ ＝ student_id に重複が無い ＝ 主キーとして機能している証拠

```colum
※ STEP0-4／STEP0-5 のエラーを再現するには、あらかじめ
  PRAGMA foreign_keys = ON; を実行しておく必要があります
  （DB Browser for SQLiteの場合、「Execute SQL」タブで一度実行してください）。
```


- STEP0-4. 主キーが「守ってくれるもの」を体感する
次のSQLは実行するとエラーになる。student_id = 1 は既に
「田中一郎」さんが使っているため、重複した登録はできません。
 実際に手元で試して、エラーメッセージを確認してみましょう。

```sql
INSERT INTO students (student_id, student_name, kana, birth_date, class_id)
 VALUES (1, 'ダブり太郎', 'だぶりたろう', '2010-01-01', 1);
```
 → 「UNIQUE constraint failed: students.student_id」というエラーになるはず
```

- STEP0-5. 外部キーが「守ってくれるもの」を体感する
次のSQLも実行するとエラーになります。存在しないclass_id（999）を 指定して学生を登録しようとしているためです。

```sql
INSERT INTO students (student_id, student_name, kana, birth_date, class_id)
VALUES (99, 'テスト太郎', 'てすとたろう', '2010-01-01', 999);
```
→ 「FOREIGN KEY constraint failed」というエラーになるはず
   （class_id = 999 は classesテーブルに存在しないため、"守られている"）
