-- ============================================================
--  第3回：主キー・外部キーの復習と JOIN（テーブル結合）の基本
-- ------------------------------------------------------------
--  この授業のゴール：
--   ・主キー（PRIMARY KEY）・外部キー（FOREIGN KEY）の役割を説明できる
--   ・INNER JOIN で2つのテーブルを結合できる
--   ・テーブル別名（AS）を使って読みやすいSQLが書ける
-- ============================================================


-- ------------------------------------------------------------
-- 【講師デモ】0. 主キー・外部キーのおさらい
-- ------------------------------------------------------------
-- classesテーブルの主キーは class_id
-- studentsテーブルの主キーは student_id
-- studentsテーブルの class_id 列は「外部キー」＝ classesテーブルの class_id を指し示す
-- 　→ どの学生が、どのクラスに所属しているかを表現している
SELECT * FROM classes;
SELECT student_id, student_name, class_id FROM students;
-- ↑ students.class_id の値（1,2,3…）が classes.class_id と対応していることを確認する


-- 【講師デモ】1. JOINを使わない場合（できないこと）
--    「学生名」と「クラス名」を同時に見たいが、studentsテーブルには
--    class_id（番号）しか無く、class_nameという文字列は無い！
SELECT student_name, class_id FROM students;  -- class_idの数字だけではクラス名が分からない


-- 【講師デモ】2. INNER JOIN：2つのテーブルを「関連する列」でつなげる
SELECT students.student_name, classes.class_name
FROM students
JOIN classes ON students.class_id = classes.class_id;

-- 【講師デモ】3. テーブルに別名（AS）をつけて短く書く
SELECT s.student_name, c.class_name, c.teacher_name
FROM students AS s
JOIN classes AS c ON s.class_id = c.class_id;

-- 【講師デモ】4. JOIN + WHERE の組み合わせ
--    「1年A組の学生の氏名と担任名」を表示する
SELECT s.student_name, c.teacher_name
FROM students AS s
JOIN classes AS c ON s.class_id = c.class_id
WHERE c.class_name = '1年A組';

-- 【講師デモ】5. students と scores を結合する例
--    「国語（subject_id = 1）の得点を、学生名つきで見る」
SELECT s.student_name, sc.score
FROM students AS s
JOIN scores AS sc ON s.student_id = sc.student_id
WHERE sc.subject_id = 1
ORDER BY sc.score DESC;


-- ============================================================
-- 【演習問題】
-- ============================================================

-- Q1. students と classes を結合し、「学生名」と「クラス名」を
--     一覧表示しなさい。


-- Q2. students と classes を結合し、「学生名」と「担任の先生名」を
--     一覧表示しなさい。


-- Q3. students と scores を結合し、subject_id = 2（数学）の
--     「学生名」と「score」を、scoreの高い順に表示しなさい。


-- Q4. class_id = 3（2年A組）に所属する学生の氏名と担任名を
--     表示しなさい。（JOIN + WHERE）


-- Q5. students と scores を結合し、「田中一郎」さんの全科目の
--     成績（学生名・score・exam_date）を表示しなさい。（WHEREで名前指定）


-- Q6.【考察問題（SQLは書かなくてOK）】
--     もし students テーブルに class_id という外部キーが無く、
--     代わりに class_name（'1年A組' など）を直接書き込む設計だったら、
--     どんな不便なことが起きそうか、考えてみましょう。
--     （ヒント：クラス名が変わったら？担任の先生が変わったら？）

