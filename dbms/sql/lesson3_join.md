##  テーブルの結合（INNER JOIN / LEFT JOIN / RIGHT JOIN）

### ゴール：
- JOIN で2つ以上のテーブルをつなげて、1つの表として表示できるようになる
- INNER JOIN と LEFT JOIN の結果の違いを説明できるようになる
- LEFT JOIN と IS NULL を使って「相手がいないデータ」を探せるようになる
- RIGHT JOIN は LEFT JOIN の左右を入れ替えたものだと説明できるようになる

```
※ 事前に 00_create_and_seed.sql を実行して、データベースを作っておくこと。
※ 実行できるSQLは 03_join.sql にまとめてあります。
```

---

## 0. なぜ JOIN が必要なのか

scoresテーブルを見てみましょう。

```sql
SELECT * FROM scores WHERE student_id = 261001;
```

| student_id | subject_id | score |
|---|---|---|
| 261001 | 1 | 66 |
| 261001 | 2 | 73 |
| … | … | … |

数字ばかりで「誰の」「何の科目の」点数なのかが、ぱっと見てわかりません。
学生の名前は students に、科目名は subjects に入っているからです。

データベースでは、同じ情報を何度も書かないように **表を分けて保存** します（正規化）。
そのため、見るときには **外部キーを手がかりに表をつなげる** 必要があります。これが **JOIN（結合）** です。


## 1. JOIN の基本の形

```sql
SELECT 表示したい列
FROM 左のテーブル
INNER JOIN 右のテーブル ON 左のテーブル.列 = 右のテーブル.列;
```

- `FROM` に書いたテーブルが **左**、`JOIN` の後に書いたテーブルが **右**
- `ON` の後ろに「どの列とどの列が同じなら、つなげるか」を書く
- 2つのテーブルに同じ名前の列（例：class_id）があるので、`テーブル名.列名` と書いて区別する

---

## 2. INNER JOIN（内部結合）

**両方のテーブルに相手がいる行だけ** を表示します。

```
  左のテーブル    右のテーブル
   ┌───────┐   ┌───────┐
   │       │███│       │      ███ の部分（両方にある）だけ表示
   │       │███│       │
   └───────┘   └───────┘
```

### 2-1. 一番かんたんな INNER JOIN：学生名と学科名
```sql
SELECT students.student_name, classes.department_name
FROM students
INNER JOIN classes ON students.class_id = classes.class_id;
```
→ 20件。students の class_id と classes の class_id が同じ行どうしがつながります。

### 2-2. 別名（エイリアス）を使う
毎回テーブル名を書くのは長いので、`AS` で短い名前をつけます。結果は 2-1 と同じです。
```sql
SELECT s.student_name, c.department_name
FROM students AS s
INNER JOIN classes AS c ON s.class_id = c.class_id;
```

### 2-3. 科目名と担当の先生
```sql
SELECT sb.subject_name, t.teacher_name
FROM subjects AS sb
INNER JOIN teachers AS t ON sb.teacher_id = t.teacher_id;
```
→ 5件。科目を担当していない先生（高橋さんなど）は表示されません。

### 2-4. WHERE と組み合わせる
青木翔さん（261001）の成績を、科目名つきで表示します。
```sql
SELECT sc.student_id, sb.subject_name, sc.score
FROM scores AS sc
INNER JOIN subjects AS sb ON sc.subject_id = sb.subject_id
WHERE sc.student_id = 261001;
```
SQLの書く順番は `SELECT → FROM → JOIN → WHERE → GROUP BY → HAVING → ORDER BY` です。

### 2-5. 3つのテーブルをつなげる
`JOIN` は何回でも続けて書けます。
```sql
SELECT s.student_name, sb.subject_name, sc.score
FROM scores AS sc
INNER JOIN students AS s  ON sc.student_id = s.student_id
INNER JOIN subjects AS sb ON sc.subject_id = sb.subject_id
ORDER BY s.student_id, sb.subject_id;
```
→ 99件。最初の「数字ばかりの表」が、読める表に変わりました。

### 2-6. JOIN と GROUP BY（第2回の復習）
科目名ごとの平均点を表示します。
```sql
SELECT sb.subject_name, ROUND(AVG(sc.score), 1) AS avg_score
FROM scores AS sc
INNER JOIN subjects AS sb ON sc.subject_id = sb.subject_id
GROUP BY sb.subject_id, sb.subject_name
ORDER BY avg_score DESC;
```

---

## 3. LEFT JOIN（左外部結合）

**左のテーブルの行は全部** 表示します。右に相手がいない場合は、右の列が **NULL**（値なし）になります。

```
  左のテーブル    右のテーブル
   ┌───────┐   ┌───────┐
   │███████│███│       │      左は全部表示
   │███████│███│       │      右に相手がいなければ NULL
   └───────┘   └───────┘
```

### 3-1. INNER JOIN と LEFT JOIN を比べる（一番大事！）
先生と、担任をしているクラスを表示します。

**INNER JOIN の場合**
```sql
SELECT t.teacher_name, c.department_name
FROM teachers AS t
INNER JOIN classes AS c ON t.teacher_id = c.teacher_id;
```
→ **7件**

**LEFT JOIN の場合**
```sql
SELECT t.teacher_name, c.department_name
FROM teachers AS t
LEFT JOIN classes AS c ON t.teacher_id = c.teacher_id;
```
→ **9件**

| teacher_name | department_name |
|---|---|
| 佐藤美穂 | ITエンジニア学科 |
| 鈴木健一 | ITキャリア養成科 |
| … | … |
| 山本加奈 | 介護福祉学科 |
| **森隆** | **NULL** |
| **岡田恵** | **NULL** |

森さん・岡田さんは担任を持っていません。
INNER JOIN では **消えてしまい**、LEFT JOIN では **NULL つきで残ります**。

### 3-2. LEFT JOIN + IS NULL で「相手がいないデータ」を探す
3-1 の結果から NULL の行だけを取り出せば、「担任を持っていない先生」がわかります。
```sql
SELECT t.teacher_id, t.teacher_name
FROM teachers AS t
LEFT JOIN classes AS c ON t.teacher_id = c.teacher_id
WHERE c.class_id IS NULL;
```
→ 森隆、岡田恵 の2件

```column
注意：NULL は「= NULL」では比べられません。必ず「IS NULL」「IS NOT NULL」と書きます。
```

### 3-3. LEFT JOIN と COUNT で「0件」も数える
クラスごとの学生数を表示します。
```sql
SELECT c.department_name, COUNT(s.student_id) AS student_count
FROM classes AS c
LEFT JOIN students AS s ON c.class_id = s.class_id
GROUP BY c.class_id, c.department_name
ORDER BY c.class_id;
```
→ ITエンジニア学科は 20、その他の学科は 0

- INNER JOIN にすると、学生がいないクラスは結果から消えてしまいます
- `COUNT(*)` だと NULL の行も1件と数えてしまい、0 ではなく 1 になります。
  `COUNT(s.student_id)` は NULL を数えないので、正しく 0 になります

### 3-4. 【発展】未受験の科目を見つける
全学生の「ビジネスマナー（subject_id = 5）」の点数を表示します。
```sql
SELECT s.student_id, s.student_name, sc.score
FROM students AS s
LEFT JOIN scores AS sc
       ON s.student_id = sc.student_id
      AND sc.subject_id = 5
ORDER BY s.student_id;
```
→ 20件。坂本優花さん（261010）だけ score が NULL（未受験）です。

```column
ポイント：条件「sc.subject_id = 5」を WHERE に書くと、NULL の行（坂本さん）が
条件に合わずに消えてしまい、INNER JOIN と同じ結果になります。
「右のテーブルの絞り込み条件」は ON に書く、と覚えましょう。
```

---

## 4. RIGHT JOIN（右外部結合）

**右のテーブルの行は全部** 表示します。LEFT JOIN の左右を逆にしたものです。

```
  左のテーブル    右のテーブル
   ┌───────┐   ┌───────┐
   │       │███│███████│      右は全部表示
   │       │███│███████│      左に相手がいなければ NULL
   └───────┘   └───────┘
```

### 4-1. RIGHT JOIN で 3-1 と同じ結果を出す
```sql
SELECT t.teacher_name, c.department_name
FROM classes AS c
RIGHT JOIN teachers AS t ON c.teacher_id = t.teacher_id;
```
→ 9件（3-1 の LEFT JOIN と同じ結果）

つまり、次の2つは同じ意味です。
```
A LEFT JOIN  B   ＝   B RIGHT JOIN A
```
実際の現場では、読みやすさのため **LEFT JOIN にそろえて書く** ことが多いです。

### 4-2. 科目を担当していない先生も含めて表示する
```sql
SELECT t.teacher_name, sb.subject_name
FROM subjects AS sb
RIGHT JOIN teachers AS t ON sb.teacher_id = t.teacher_id
ORDER BY t.teacher_id;
```
→ 10件。科目を担当していない5人の先生は subject_name が NULL。
森さんは2科目を担当しているので **2行** になります（1対多の関係）。

```column
※ RIGHT JOIN は SQLite 3.39.0 以降で使えます。古い DB Browser for SQLite などで
  エラーになる場合は、テーブルの左右を入れ替えて LEFT JOIN で書いてください。
```

---

## 5. まとめ

| 種類 | 表示される行 | 相手がいないとき |
|---|---|---|
| INNER JOIN | 両方に相手がいる行だけ | 表示されない |
| LEFT JOIN | 左のテーブルの全行 | 右の列が NULL |
| RIGHT JOIN | 右のテーブルの全行 | 左の列が NULL |

- 迷ったら「**どちらのテーブルを全部残したいか**」を考える
- 「〜していない人」「〜がないもの」を探すときは **LEFT JOIN + IS NULL**
- `INNER` は省略でき、`JOIN` だけでも INNER JOIN になる

---

## 【演習問題】自分でSQLを書いてみましょう

- Q1.（INNER JOIN）
  classes と teachers を結合して、**学科名** と **担任の先生の名前** を表示しなさい。

- Q2.（INNER JOIN ＋ WHERE ＋ ORDER BY）
  「データベース」の成績を、**学生名** と **点数** で表示しなさい。点数の高い順に並べること。
  ヒント：scores・students・subjects の3つを結合し、科目名で絞り込む。

- Q3.（3つのテーブルの結合）
  40点未満の成績を、**学生名・科目名・点数** で表示しなさい。

- Q4.（LEFT JOIN ＋ IS NULL）
  学生が1人も所属していないクラスの **学科名** を表示しなさい。

- Q5.（RIGHT JOIN）
  Q4 と同じ結果を、**RIGHT JOIN** を使って書きなさい。

- ★チャレンジ（LEFT JOIN ＋ GROUP BY）
  全ての先生について、**先生の名前** と **担当している科目の数** を表示しなさい。
  科目を担当していない先生は 0 と表示すること。

---

## 【解答例】

### Q1
```sql
SELECT c.department_name, t.teacher_name
FROM classes AS c
INNER JOIN teachers AS t ON c.teacher_id = t.teacher_id;
```
→ 7件（ITエンジニア学科／佐藤美穂、ITキャリア養成科／鈴木健一、…、介護福祉学科／山本加奈）

### Q2
```sql
SELECT s.student_name, sc.score
FROM scores AS sc
INNER JOIN students AS s  ON sc.student_id = s.student_id
INNER JOIN subjects AS sb ON sc.subject_id = sb.subject_id
WHERE sb.subject_name = 'データベース'
ORDER BY sc.score DESC;
```
→ 20件。上位は 石川葵 99、中野悠斗 97、工藤さくら 95、大塚悠真 94、杉山愛 92 …
（`WHERE sc.subject_id = 2` でも同じ結果になるが、科目名で絞り込めるのが JOIN の良いところ）

### Q3
```sql
SELECT s.student_name, sb.subject_name, sc.score
FROM scores AS sc
INNER JOIN students AS s  ON sc.student_id = s.student_id
INNER JOIN subjects AS sb ON sc.subject_id = sb.subject_id
WHERE sc.score < 40;
```
→ 2件（藤田隼人／ネットワーク基礎／36、藤田隼人／情報セキュリティ／37）

### Q4
```sql
SELECT c.department_name
FROM classes AS c
LEFT JOIN students AS s ON c.class_id = s.class_id
WHERE s.student_id IS NULL;
```
→ 6件（ITキャリア養成科、映像クリエイター学科、建築学科、電気電子学科、臨床工学科、介護福祉学科）

### Q5
```sql
SELECT c.department_name
FROM students AS s
RIGHT JOIN classes AS c ON s.class_id = c.class_id
WHERE s.student_id IS NULL;
```
→ Q4 と同じ6件。classes を右に置いたので、classes が全件残る。

### ★チャレンジ
```sql
SELECT t.teacher_name, COUNT(sb.subject_id) AS subject_count
FROM teachers AS t
LEFT JOIN subjects AS sb ON t.teacher_id = sb.teacher_id
GROUP BY t.teacher_id, t.teacher_name
ORDER BY t.teacher_id;
```
→ 9件（佐藤美穂 1、鈴木健一 1、高橋直子 0、田中誠 0、伊藤由美 0、渡辺浩二 0、山本加奈 0、森隆 2、岡田恵 1）
`COUNT(*)` にすると、担当なしの先生が 0 ではなく 1 になってしまう点に注意。
