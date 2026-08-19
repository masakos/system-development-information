-- ============================================================
--  第5回：正規化（第1正規形・第2正規形・第3正規形）と関数従属性
-- ------------------------------------------------------------
--  この授業のゴール：
--   ・「関数従属性（X → Y）」の意味を説明できる
--   ・非正規形／第1正規形／第2正規形／第3正規形の違いを説明できる
--   ・「なぜ classes / students / subjects / scores の4つに
--      テーブルを分けたのか」を自分の言葉で説明できる
--
--  進め方：
--   1. わざと「良くない設計」のテーブルを作って問題点を体感する
--   2. 関数従属性という考え方を学ぶ
--   3. 段階的に正規化し、最終的に今まで使ってきた4テーブル設計に
--      たどり着くことを確認する
-- ============================================================


-- ============================================================
-- STEP 0：非正規形（繰り返し項目がある「悪い設計」）の例
-- ============================================================
-- よくある失敗パターン：1人の学生の情報を「横に」並べてしまう設計。
-- 科目が増えるたびに列を追加しないといけない、という時点で设计ミスのサイン。

DROP TABLE IF EXISTS non_normalized_demo;
CREATE TABLE non_normalized_demo (
    student_id     INTEGER,
    student_name   TEXT,
    class_name     TEXT,
    teacher_name   TEXT,
    subject1_name  TEXT, subject1_score INTEGER,
    subject2_name  TEXT, subject2_score INTEGER,
    subject3_name  TEXT, subject3_score INTEGER
);

INSERT INTO non_normalized_demo VALUES
(1, '田中一郎',   '1年A組', '佐藤先生', '国語', 72, '数学', 68, '英語', 75),
(2, '佐々木花子', '1年A組', '佐藤先生', '国語', 92, '数学', 88, '英語', 95),
(6, '加藤陽菜',   '1年B組', '鈴木先生', '国語', 75, '数学', 80, '英語', 70);

SELECT * FROM non_normalized_demo;

-- 【講師デモ／話し合い】この表の何が問題か？
--  ① 科目が4つ目になったら列を追加しないといけない（拡張に弱い）
--  ② 「数学が70点以上の学生」を探すSQLが、subject1〜3すべてを
--     チェックしないといけなくて非常に書きにくい
--  ③ subject1_name に同じ値（'国語'など）が何度も重複して入る
--  → このように「1つのセルに繰り返し項目が入っている／情報を横に
--     広げてしまっている」状態は「第1正規形（1NF）」を満たしていない、という


-- ============================================================
-- STEP 1：第1正規形（1NF）にする
-- ============================================================
-- ルール：「繰り返し項目をなくし、1セルに1つの値だけを入れる」
-- → 「1人の学生 × 1科目」で1行、という形に直す
--
-- 実は、これは今まで使ってきた students / scores / subjects / classes を
-- JOINして作れる。CREATE TABLE ... AS SELECT で実際に作ってみる。

DROP TABLE IF EXISTS flat_school_records;
CREATE TABLE flat_school_records AS
SELECT
    s.student_id,
    s.student_name,
    c.class_id,
    c.class_name,
    c.teacher_name,
    sub.subject_id,
    sub.subject_name,
    sc.score
FROM students AS s
JOIN classes  AS c   ON s.class_id = c.class_id
JOIN scores   AS sc  ON s.student_id = sc.student_id
JOIN subjects AS sub ON sc.subject_id = sub.subject_id;

SELECT * FROM flat_school_records ORDER BY student_id, subject_id;

-- これで1セル1値・繰り返し項目なし＝第1正規形（1NF）は達成できた。
-- この表の主キー（1行を特定するために必要な列の組み合わせ）は
--   (student_id, subject_id) という「複合主キー」になる
--   ※ student_idだけでは1行に絞れない（1人が5科目分の行を持つため）


-- ============================================================
-- STEP 2：関数従属性（かんすうじゅうぞくせい）を確認する
-- ============================================================
-- 「関数従属」とは：ある列（X）の値が決まれば、別の列（Y）の値も
-- 自動的に1つに決まる、という関係のこと。 X → Y と書く。
--
-- flat_school_records の中には、次のような関数従属が見つかる：
--
--   student_id → student_name, class_id, class_name, teacher_name
--     （学生が決まれば、名前・所属クラス・担任も決まる）
--
--   class_id → class_name, teacher_name
--     （クラスが決まれば、クラス名・担任も決まる）
--
--   subject_id → subject_name
--     （科目が決まれば、科目名も決まる）
--
--   (student_id, subject_id) → score
--     （「誰の」「どの科目の」点数か、両方決まって初めてscoreが決まる）
--
-- 主キーは (student_id, subject_id) の複合キーだったことを思い出すと…
--  ・student_name などは「student_idだけ」で決まってしまう
--    → 主キーの"一部だけ"で決まる＝「部分関数従属」
--  ・class_name は「student_id → class_id → class_name」という
--    ２段階の関係で決まる（class_idを経由している）
--    → これを「推移的関数従属」という


-- ============================================================
-- STEP 3：第2正規形（2NF）にする
-- ============================================================
-- ルール：「複合主キーの"一部"にしか関数従属していない列（部分関数従属）
--          を、別テーブルに切り出す」
--
-- student_name, class_id, class_name, teacher_name は student_id だけで
-- 決まる → 学生に関する情報だけを別テーブルに切り出す
--
-- subject_name は subject_id だけで決まる → 科目に関する情報だけを
-- 別テーブルに切り出す
--
-- 残るのは (student_id, subject_id) → score の関係だけ
--
-- 実際にやってみる：

DROP TABLE IF EXISTS step2_students;
CREATE TABLE step2_students AS
SELECT DISTINCT student_id, student_name, class_id, class_name, teacher_name
FROM flat_school_records;

DROP TABLE IF EXISTS step2_subjects;
CREATE TABLE step2_subjects AS
SELECT DISTINCT subject_id, subject_name
FROM flat_school_records;

DROP TABLE IF EXISTS step2_scores;
CREATE TABLE step2_scores AS
SELECT student_id, subject_id, score
FROM flat_school_records;

SELECT * FROM step2_students;
SELECT * FROM step2_subjects;
SELECT * FROM step2_scores LIMIT 10;

-- これで部分関数従属は無くなった＝第2正規形（2NF）は達成！
-- でも…まだ step2_students の中に問題が残っている。


-- ============================================================
-- STEP 4：第3正規形（3NF）にする
-- ============================================================
-- STEP3で作った step2_students をよく見ると：
--   student_id → class_id → class_name, teacher_name
-- という「推移的関数従属」がまだ残っている
--  （class_name や teacher_name は、本当は class_id さえ分かれば決まる
--    情報で、student_idを経由する必要は無いはず）
--
-- ルール：「主キーに直接関数従属していない列（推移的関数従属）を、
--          さらに別テーブルに切り出す」
--
-- → クラスに関する情報（class_name, teacher_name）を classes テーブルへ
-- → 学生テーブルには class_id という「外部キー」だけを残す

DROP TABLE IF EXISTS step3_classes;
CREATE TABLE step3_classes AS
SELECT DISTINCT class_id, class_name, teacher_name
FROM step2_students;

DROP TABLE IF EXISTS step3_students;
CREATE TABLE step3_students AS
SELECT DISTINCT student_id, student_name, class_id
FROM step2_students;

SELECT * FROM step3_classes;
SELECT * FROM step3_students;

-- ここまでやると…
--   step3_classes  ＝ classes  テーブルとほぼ同じ
--   step3_students ＝ students テーブルとほぼ同じ（列は絞った状態）
--   step2_subjects ＝ subjects テーブルとほぼ同じ
--   step2_scores   ＝ scores   テーブルとほぼ同じ
--
-- つまり！！ 第1回から配布して使ってきた classes / students / subjects /
-- scores の4テーブル設計は、最初から「正規化済みの設計」だった、
-- ということが確認できる。


-- ============================================================
-- 【演習問題】
-- ============================================================

-- Q1. non_normalized_demo テーブルの問題点を3つ挙げなさい。


-- Q2. flat_school_records テーブルの中にある関数従属を、
--     自分で3つ以上書き出しなさい（X → Y の形で）。


-- Q3. flat_school_records の主キーは何か答え、そこにある
--     「部分関数従属」を1つ指摘しなさい。


-- Q4. flat_school_records の中にある「推移的関数従属」を1つ指摘しなさい。


-- Q5. 実際に配布されている classes / students / subjects / scores の
--     4テーブル設計が、なぜこの形になっているのかを、正規化の言葉
--     （1NF・2NF・3NF）を使って自分の言葉で説明しなさい。


-- Q6.【SQL演習】flat_school_records から学生ごとの平均点を求めるSQLと、
--     正規化済みの scores テーブルから学生ごとの平均点を求めるSQL
--     （第2回・第4回で書いたもの）を見比べ、結果が同じになることを
--     確認しなさい。

