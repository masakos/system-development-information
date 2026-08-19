# 補講：INSERT文・UPDATE文の基本

対象：これまでの授業で使ってきた `school.db`（学生管理システム）の続き
形式：40〜60分、目安の位置づけは**第4回（JOINの応用）のあと**
　　　（例4で、第4回のLEFT JOINの続きを扱うため）


## この回のゴール

- INSERT文で新しいデータを1件追加できるようになる
- UPDATE文で既存のデータを書き換えられるようになる
- UPDATEでWHEREを忘れると何が起きるかを理解し、必ずWHEREを確認する習慣をつける
- INSERT・UPDATEも、主キー・外部キーの制約を守らないとエラーになることを確認する

## 1. INSERT文の基本構文

新しい行（レコード）を1件追加するときに使います。

```sql
INSERT INTO テーブル名 (列1, 列2, 列3, ...)
VALUES (値1, 値2, 値3, ...);
```

- 列名の順番と、VALUESの値の順番は必ず対応させる
- 文字列は `'シングルクォート'` で囲む、数値はそのまま書く
- 主キーの列に、すでに存在する値を指定するとエラーになる（第1回STEP0で確認済み）
- 外部キーの列に、参照先のテーブルに存在しない値を指定するとエラーになる（同じく第1回STEP0で確認済み）

### 【例】1. 新しい科目を追加する

```sql
INSERT INTO subjects (subject_id, subject_name, credit)
VALUES (6, '音楽', 2);
```

```sql
SELECT * FROM subjects;
```

### 【例】2. 新しいクラスを追加する

```sql
INSERT INTO classes (class_id, class_name, teacher_name)
VALUES (4, '2年B組', '中島先生');
```

### 【例】3. 新しい学生を追加する（外部キーに注意）

```sql
INSERT INTO students (student_id, student_name, kana, birth_date, class_id)
VALUES (16, '新田陸', 'にったりく', '2009-06-08', 4);
```

`class_id = 4` は、直前に追加した「2年B組」の `class_id` を指している。

-  `class_id = 99` のような存在しないクラスを指定すると、外部キー制約違反でエラーになる



---

## 2. UPDATE文の基本構文

既存の行の値を書き換えるときに使います。

```sql
UPDATE テーブル名
SET 列1 = 新しい値1, 列2 = 新しい値2
WHERE 条件;
```

**⚠️ 最重要注意点**：`WHERE` を書き忘れると、そのテーブルの**全行**が書き換わってしまいます。UPDATEを実行する前には、必ず同じ条件でSELECT文を実行し、どの行が対象になるかを確認する習慣をつけましょう。

### 【例】5. 実行前に対象行をSELECTで確認する

```sql
-- まずSELECTで「本当にこの1件だけが対象か」を確認する
SELECT * FROM students WHERE student_id = 4;
```

### 【例】6. 1件だけ更新する

渡辺美咲さん（student_id = 4）の誕生日データに誤りが見つかったので修正する。

```sql
UPDATE students
SET birth_date = '2010-09-13'
WHERE student_id = 4;
```

```sql
SELECT * FROM students WHERE student_id = 4;
```

### 【例】7. 複数列を同時に更新する

```sql
UPDATE classes
SET teacher_name = '中村先生'
WHERE class_id = 2;
```

### 【例】8.（危険な例・実行しないこと！）WHEREを忘れるとどうなるか

```sql
-- 絶対に実行しないでください（練習用のコピーDBでも非推奨）
-- UPDATE scores SET score = 0;
-- ↑ WHEREが無いため、scoresテーブルの全75件のscoreが0点になってしまう
```

もし誤って実行してしまった場合は、`00_create_and_seed.sql` を再実行してデータを作り直しましょう。

### 【例】9. WHEREにAND条件を使う

数学（subject_id = 2）で70点未満だった生徒に、再テストの結果として一律5点を加点する。

```sql
UPDATE scores
SET score = score + 5
WHERE subject_id = 2 AND score < 70;
```

```sql
SELECT * FROM scores WHERE subject_id = 2;
```

---

## 3. 演習問題


### INSERT編

**Q1.** `subjects` テーブルに、新しい科目「美術」（subject_id = 7、credit = 1）を追加しなさい。

**Q2.** `classes` テーブルに、新しいクラス「2年C組」（class_id = 5、担任「岡田先生」）を追加しなさい。

**Q3.** Q2で追加した「2年C組」に所属する新しい学生を1人、自由に名前を決めて追加しなさい（student_id = 17）。

**Q4.** Q3で追加した学生の「国語」（subject_id = 1）の成績を、好きな点数で1件追加しなさい。

**Q5.【エラーを確認する問題】** 存在しない `class_id`（例：999）を指定して学生を追加しようとするSQLを書き、実際にエラーになることを確認しなさい。

### UPDATE編

**Q6.** 「加藤陽菜」さん（student_id = 6）の `kana` が間違っていたことが分かった。正しい値 `'かとうひな'` に更新しなさい。

**Q7.** 1年B組（class_id = 2）の担任が「鈴木先生」から「森先生」に交代した。`classes` テーブルを更新しなさい。

**Q8.** 「小林大輔」さん（student_id = 5）の英語（subject_id = 3）の点数に採点ミスが見つかったため、85点に修正しなさい。

**Q9.【条件付き更新】** 理科（subject_id = 4）で60点未満だった学生全員に、追試験の結果を反映して一律10点を加算しなさい。

**Q10.【考察問題（SQLは書かなくてOK）】** UPDATE文を実行する前にSELECT文で対象行を確認しておくと、どんな失敗を防げるか、自分の言葉で説明しなさい。
