## ER図のリレーション

### 0.リレーションを描く
1. 外部キーに FK と書こう
2. テーブル同士を線で結ぼう
   - 外部キーを持つテーブルと、参照先のテーブルを線で結ぼう。
3. 線の両端に多重度（`1`、`0..*` など）を書こう

### 1. CREATE文を確認する

- ER図の多重度は、テーブルのCREATE文から判断できる場合があります。
- 外部キーや主キー、UNIQUE制約、NOT NULL制約などを確認します。
- ただし、テーブル定義だけではわからない業務上のルールもあるため、仕様書なども確認する必要があります。

`sql/00_create_and_seed.sql` の CREATE文をみてみよう。

| CREATE文 | ER図でわかること |
| --- | --- |
| `PRIMARY KEY` | PK |
| `FOREIGN KEY ... REFERENCES` | テーブル間の関連を定義しているところ。外部キーを持つ側が「多」 |
| `NOT NULL`（外部キーに設定されている） | 「1」側が `1` になる。（必ず1つ。`0..1` ではない） |


#### (参考) SQLiteのデータ型

| ストレージクラス  | 説明            | 例                 |
| --------- | ------------- | ----------------- |
| `NULL`    | 値が存在しない       | `NULL`            |
| `INTEGER` | 整数            | `10`, `-5`, `0`   |
| `REAL`    | 浮動小数点数（小数）    | `3.14`, `98.5`    |
| `TEXT`    | 文字列           | `'田中'`, `'Hello'` |
| `BLOB`    | バイナリデータ（バイト列） | 画像、音声など           |

例：`classes` テーブル

```sql
CREATE TABLE classes (
    class_id        INTEGER PRIMARY KEY,    -- PK
    enrollment_year INTEGER NOT NULL ...,
    department_name TEXT NOT NULL,
    teacher_id      INTEGER NOT NULL,       -- NOT NULL → 担任は必ず1人
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),  -- テーブル同士を関連付けるための外部キー制約を定義 
    UNIQUE (enrollment_year, department_name),
    UNIQUE (enrollment_year, teacher_id)
);
```

**見分け方のコツ：外部キーを持っている側が「多」、参照される側が「1」**

- 外部キーは **1本ごとに、1本の線（リレーション）** を表す
  - `scores` のように1行に外部キーが2つ（`student_id`・`subject_id`）あれば、線も2本になる
- 外部キーに `NOT NULL` が付いている → 親側の端は「ちょうど1（`1`）」
  - NULLを許す外部キーなら、親側の端は「0か1（`0..1`）」になる


### 2. 各リレーションを実データで確認する

#### (1) teachers ─ classes（担任）


| 見る方向 | 説明 | 多重度 | 根拠 |
| --- | --- | --- | --- |
| クラスから見る | **クラスには、担任の先生が必ず1人いる** | `1`（teachers 側の端） | `classes.teacher_id` は `NOT NULL` の外部キーで、1つの値しか入らない |
| 先生から見る | **先生は、クラスの担任を0個以上受け持つ**（受け持たない先生もいる） | `0..*`（classes 側の端） | 森先生・岡田先生は0個。年度が違えば複数受け持てる |

```
teachers 1 ──────── 0..* classes
```

```sql
SELECT 
  t.teacher_id, 
  t.teacher_name, 
  c.department_name 
FROM teachers as t 
left join classes as c 
on t.teacher_id = c.teacher_id
```

| teacher_id | teacher_name | 担任するクラス |
| --- | --- | --- |
| 1 | 佐藤美穂 | ITエンジニア学科 |
| 2 | 鈴木健一 | ITキャリア養成科 |
| … | … | … |
| 7 | 山本加奈 | 介護福祉学科 |
| 8 | 森隆 | **なし** |
| 9 | 岡田恵 | **なし** |

- 同じ入学年度の中だけで見れば、`UNIQUE (enrollment_year, teacher_id)` があるので担任は1人1クラスまで
- ただし年度をまたぐと複数のクラスを担任できるので、ER図では `0..*` になる

#### (2) teachers ─ subjects（科目担当）

| 見る方向 | 説明 | 多重度 | 根拠 |
| --- | --- | --- | --- |
| 科目から見る | **科目には、担当の先生が必ず1人いる** | `1`（teachers 側の端） | `subjects.teacher_id` は `NOT NULL` の外部キーで、1つの値しか入らない |
| 先生から見る | **先生は、科目を0個以上担当する**（担当しない先生もいる） | `0..*`（subjects 側の端） | 森先生は2科目（データベース・ネットワーク基礎）。高橋先生〜山本先生は0科目 |

```
teachers 1 ──────── 0..* subjects
```

```sql
-- 先生ごとの担当科目数（1対多の「多」を数える）
SELECT t.teacher_name, COUNT(s.subject_id) AS 担当科目数
FROM teachers AS t
LEFT JOIN subjects AS s ON s.teacher_id = t.teacher_id
GROUP BY t.teacher_id
ORDER BY 担当科目数 DESC;
```


| teacher_name | 担当科目数 |
| --- | --- |
森隆	| 2
佐藤美穂	| 1
鈴木健一	| 1
岡田恵	| 1
高橋直子	| 0
;

- 森先生は2科目を担当 → **1対多** の「多」の例
- 高橋先生（3）〜山本先生（7）は科目を担当していない → 0件の例

> `teachers` と `classes`、`teachers` と `subjects` は、**同じ `teachers` に2本の線** がつながっています。
> 「担任」と「科目担当」は別の意味のつながりなので、線も別々になります。

#### (3) classes ─ students（所属）

| 見る方向 | 説明 | 多重度 | 根拠 |
| --- | --- | --- | --- |
| 学生から見る | **学生は、必ず1つのクラスに所属する** | `1`（classes 側の端） | `students.class_id` は `NOT NULL` の外部キーで、1つの値しか入らない |
| クラスから見る | **クラスには、学生が0人以上いる**（学生がいないクラスもある） | `0..*`（students 側の端） | ITエンジニア学科は20人。ほかの6クラスは0人 |

```
classes 1 ──────── 0..* students
```

```sql
SELECT c.class_id, c.enrollment_year, c.department_name, s.student_name
FROM classes as c 
LEFT JOIN students as s ON c.class_id = s.class_id
```


| class_id | enrollment_year   | department_name   | student_name    |
| -- | ---- | ---------- | ----- |
| 1  | 2026 | ITエンジニア学科  | 上田陸   |
| 1  | 2026 | ITエンジニア学科  | 中野悠斗  |
| 1  | 2026 | ;  |   |
| 2  | 2026 | ITキャリア養成科  |       |
| 7  | 2026 | 介護福祉学科     |       |
| 4  | 2026 | 建築学科       |       |
| 3  | 2026 | 映像クリエイター学科 |       |
| 6  | 2026 | 臨床工学科      |       |
| 5  | 2026 | 電気電子学科     |       |


##### (4). students ─ scores

| 見る方向 | 説明 | 多重度 | 根拠 |
| --- | --- | --- | --- |
| 成績から見る | **成績1件は、必ず1人の学生のもの** | `1`（students 側の端） | `scores.student_id` は `NOT NULL` の外部キーで、1つの値しか入らない |
| 学生から見る | **学生は、成績を0件以上持つ** | `0..*`（scores 側の端） | ほとんどの学生は5件。坂本さんは4件（ビジネスマナー未受験）。入学したばかりなら0件 |

```
students 1 ──────── 0..* scores
```

```sql
SELECT s.student_id, s.student_name, COUNT(sc.score_id) AS score_count
FROM students AS s
LEFT JOIN scores AS sc ON s.student_id = sc.student_id
GROUP BY s.student_id, s.student_name
ORDER BY s.student_id;
```

- 成績の件数は科目数と同じとは限らない。`UNIQUE (student_id, subject_id, exam_date)` なので、試験日が違えば同じ科目の成績（再試験）も登録できる

### 5. subjects ─ scores

| 見る方向 | 説明 | 多重度 | 根拠 |
| --- | --- | --- | --- |
| 成績から見る | **成績1件は、必ず1つの科目のもの** | `1`（subjects 側の端） | `scores.subject_id` は `NOT NULL` の外部キーで、1つの値しか入らない |
| 科目から見る | **科目には、成績が0件以上ある** | `0..*`（scores 側の端） | ほとんどの科目は20件。ビジネスマナーは19件。新しく開講した科目は0件 |

```
subjects 1 ──────── 0..* scores
```

```sql
SELECT sb.subject_id, sb.subject_name, COUNT(sc.score_id) AS score_count
FROM subjects AS sb
LEFT JOIN scores AS sc ON sb.subject_id = sc.subject_id
GROUP BY sb.subject_id, sb.subject_name
ORDER BY sb.subject_id;
```

### 6. students ─ subjects（多対多）
- 学生から見ても複数、科目から見ても複数。これが多対多の関係になる。
- リレーショナルデータベースでは多対多を直接つなげないため、 間に **中間テーブル `scores`** を置いて、「1対多」2本に分解しています。
- 成績表の1行は、学生と科目の **ペア1組**。ペアをたくさん作ることで、多対多を表している


```
NG例
students :
| student_id | student_name | subject_id1 | subject_id2 | subject_id3 | … ← いくつ必要？
```

| 見る方向 | 説明 | 多重度 |
| --- | --- | --- |
| 学生から見る | **学生は、複数の科目を受ける** | 多 |
| 科目から見る | **科目は、複数の学生が受ける** | 多 |

```
students 1 ── 0..* scores 0..* ── 1 subjects
```


- 中間テーブルは「つなぐだけ」ではなく、**その組み合わせにだけ存在する情報**（点数・試験日）を置く場所にもなります。
- 点数は「学生」だけでも「科目」だけでも決まらず、「誰が × どの科目を」で初めて決まります。




