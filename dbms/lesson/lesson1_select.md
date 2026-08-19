##  SELECT文の基本（WHERE / BETWEEN / LIKE / ORDER BY / DISTINCT）

### ゴール：
- SELECT文で表からデータを取り出せるようになる
- WHERE句で条件を指定して絞り込みができるようになる
- BETWEEN／LIKE／ORDER BY／DISTINCTが使えるようになる


### 1. 全ての列・全ての行を表示する
```sql
SELECT * FROM students;
```

### 2. 表示する列を指定する（＝射影:列を抽出する）
```sql
SELECT student_name, birth_date FROM students;
```

### 3. WHERE句で条件を絞り込む
```sql
SELECT * FROM students WHERE student_id = 261005;
```

### 4. 比較演算子（=, <>, >, <, >=, <=）
```sql
SELECT * FROM scores WHERE score >= 80;
```

### 5. BETWEEN ～ AND ～ ：範囲を指定する
-    「score >= 60 AND score <= 79」と同じ意味になる
```sql
SELECT * FROM scores WHERE score BETWEEN 60 AND 79;
```

### 6. LIKE：文字列の部分一致検索（％は0文字以上の任意の文字列）
```sql
SELECT * FROM students WHERE student_name LIKE '%花%';
```

### 7. ORDER BY：並び替え（ASC=昇順（省略時のデフォルト）／DESC=降順）
```sql
SELECT * FROM students ORDER BY birth_date DESC;
```

### 8. DISTINCT：重複を除いて表示する
```sql
SELECT DISTINCT subject_id FROM scores;
```



## 【演習問題】自分でSQLを書いてみましょう


- Q1. subjectsテーブルの全件・全列を表示しなさい。

- Q2. classesテーブルから department_name だけを表示しなさい。

- Q3. scoresテーブルから、subject_id が 1（プログラミング基礎）の行だけを表示しなさい。

- Q4. scoresテーブルから、score が 80点以上の行を表示しなさい。

- Q5. scoresテーブルから、score が 60点から79点まで（BETWEENを使う）の行を表示しなさい。

- Q6. studentsテーブルから、student_name が「杉」で始まる学生を検索しなさい。

- Q7. studentsテーブルの全件を、birth_date の昇順（古い→新しい）で並び替えて表示しなさい。

- Q8. subjectsテーブルの teacher_id の種類を、重複を除いて表示しなさい。

- Q9. birth_date が '2008-01-01' 以降の学生について、student_name と kana だけを表示しなさい。

- Q10.exam_date が '2026-07-13' で、かつ score が 70点以上の行を、 scoresテーブルから表示しなさい。（WHEREの中で AND を使う）


