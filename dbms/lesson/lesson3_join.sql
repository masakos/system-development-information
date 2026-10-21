-- ============================================================
--  第3回：テーブルの結合（INNER JOIN / LEFT JOIN / RIGHT JOIN）
-- ------------------------------------------------------------
--  この回ゴール：
--   ・JOIN で2つ以上のテーブルをつなげて1つの表として表示できる
--   ・INNER JOIN と LEFT JOIN の結果の違いを説明できるの
--   ・LEFT JOIN と IS NULL で「相手がいないデータ」を探せる
--   ・RIGHT JOIN は LEFT JOIN の左右を入れ替えたものだと説明できる
--
--  ※ RIGHT JOIN は SQLite 3.39.0 以降で使えます。
--    古いバージョンでエラーになる場合は LEFT JOIN で書き換えてください。
-- ============================================================


-- ============================================================
--  第1部：INNER JOIN（内部結合）
--   両方のテーブルに「対応する相手がいる行」だけを表示する
-- ============================================================

-- ------------------------------------------------------------
-- 1. 一番かんたんな INNER JOIN
--    学生の名前と、所属クラスの学科名を表示する
--    students.class_id と classes.class_id が同じ行どうしをつなぐ
-- ------------------------------------------------------------
SELECT students.student_name, classes.department_name
FROM students
INNER JOIN classes ON students.class_id = classes.class_id;
-- → 20件（学生20人全員がクラス1に所属しているので全員表示される）


-- ------------------------------------------------------------
-- 2. テーブルに別名（エイリアス）をつける
--    students を s、classes を c と短く書ける。中身は 1. と同じ
-- ------------------------------------------------------------
SELECT s.student_name, c.department_name
FROM students AS s
INNER JOIN classes AS c ON s.class_id = c.class_id;


-- ------------------------------------------------------------
-- 3. 科目名と担当の先生の名前を表示する
--    subjects.teacher_id → teachers.teacher_id
-- ------------------------------------------------------------
SELECT sb.subject_name, t.teacher_name
FROM subjects AS sb
INNER JOIN teachers AS t ON sb.teacher_id = t.teacher_id;
-- → 5件（科目は5つ。担当していない先生は表示されない）


-- ------------------------------------------------------------
-- 4. INNER JOIN と WHERE を組み合わせる
--    青木翔さん（261001）の成績を、科目名つきで表示する
--    scores だけだと subject_id（数字）しかわからないが、
--    subjects と結合すると科目名がわかる
-- ------------------------------------------------------------
SELECT sc.student_id, sb.subject_name, sc.score
FROM scores AS sc
INNER JOIN subjects AS sb ON sc.subject_id = sb.subject_id
WHERE sc.student_id = 261001;


-- ------------------------------------------------------------
-- 5. 3つのテーブルを結合する
--    「学生名・科目名・点数」をまとめて表示する
--    students ─ scores ─ subjects と、JOIN を2回つなげる
-- ------------------------------------------------------------
SELECT s.student_name, sb.subject_name, sc.score
FROM scores AS sc
INNER JOIN students AS s  ON sc.student_id = s.student_id
INNER JOIN subjects AS sb ON sc.subject_id = sb.subject_id
ORDER BY s.student_id, sb.subject_id;
-- → 99件（成績データの件数と同じ）


-- ------------------------------------------------------------
-- 6. JOIN と GROUP BY を組み合わせる
--    科目名ごとの平均点を表示する
-- ------------------------------------------------------------
SELECT sb.subject_name, ROUND(AVG(sc.score), 1) AS avg_score
FROM scores AS sc
INNER JOIN subjects AS sb ON sc.subject_id = sb.subject_id
GROUP BY sb.subject_id, sb.subject_name
ORDER BY avg_score DESC;


-- ============================================================
--  第2部：LEFT JOIN（左外部結合）
--   左側（FROM に書いた）テーブルの行は「全部」表示する
--   右側に相手がいないときは、右側の列が NULL になる
-- ============================================================

-- ------------------------------------------------------------
-- 7. INNER JOIN と LEFT JOIN を比べる
--    教員と、その先生が担任をしているクラスを表示する
-- ------------------------------------------------------------

-- 7-1. INNER JOIN の場合
SELECT t.teacher_name, c.department_name
FROM teachers AS t
INNER JOIN classes AS c ON t.teacher_id = c.teacher_id;
-- → 7件。担任を持っていない 森さん・岡田さん は表示されない

-- 7-2. LEFT JOIN の場合
SELECT t.teacher_name, c.department_name
FROM teachers AS t
LEFT JOIN classes AS c ON t.teacher_id = c.teacher_id;
-- → 9件。森さん・岡田さん も表示され、department_name が NULL になる


-- ------------------------------------------------------------
-- 8. LEFT JOIN + IS NULL で「相手がいないデータ」を探す
--    担任を持っていない先生を探す
--    ※ 「= NULL」ではなく「IS NULL」と書くことに注意
-- ------------------------------------------------------------
SELECT t.teacher_id, t.teacher_name
FROM teachers AS t
LEFT JOIN classes AS c ON t.teacher_id = c.teacher_id
WHERE c.class_id IS NULL;
-- → 森隆、岡田恵 の2件


-- ------------------------------------------------------------
-- 9. LEFT JOIN と COUNT で「0件」も数える
--    クラスごとの学生数を表示する
--    INNER JOIN だと学生のいないクラスが消えてしまうが、
--    LEFT JOIN なら学生数 0 のクラスも表示できる
--    ※ COUNT(*) ではなく COUNT(s.student_id) にすること
--      （COUNT(列名) は NULL を数えないので 0 になる）
-- ------------------------------------------------------------
SELECT c.department_name, COUNT(s.student_id) AS student_count
FROM classes AS c
LEFT JOIN students AS s ON c.class_id = s.class_id
GROUP BY c.class_id, c.department_name
ORDER BY c.class_id;
-- → ITエンジニア学科 20、その他の学科は 0


-- ------------------------------------------------------------
-- 10. 【発展】未受験の科目を見つける
--     全学生の「ビジネスマナー（subject_id = 5）」の点数を表示する
-- ------------------------------------------------------------
SELECT s.student_id, s.student_name, sc.score
FROM students AS s
LEFT JOIN scores AS sc
       ON s.student_id = sc.student_id
      AND sc.subject_id = 5
ORDER BY s.student_id;
-- → 20件。坂本優花さん（261010）だけ score が NULL（未受験）
-- 条件に合う成績だけを結合する。成績が見つからない学生も残る。


-- ============================================================
--  第3部：RIGHT JOIN（右外部結合）
--   右側（JOIN の後に書いた）テーブルの行は「全部」表示する
--   LEFT JOIN の左右を入れ替えただけで、結果は同じになる
-- ============================================================

-- ------------------------------------------------------------
-- 11. RIGHT JOIN で 7-2 と同じ結果を出す
--     右側の teachers が全件表示される
-- ------------------------------------------------------------
SELECT t.teacher_name, c.department_name
FROM classes AS c
RIGHT JOIN teachers AS t ON c.teacher_id = t.teacher_id;
-- → 9件（7-2 の LEFT JOIN と同じ結果）

-- 同じ意味の LEFT JOIN（テーブルの順番を入れ替えただけ）
SELECT t.teacher_name, c.department_name
FROM teachers AS t
LEFT JOIN classes AS c ON c.teacher_id = t.teacher_id;




-- 【演習問題】自分でSQLを書いてみましょう

-- Q1.（INNER JOIN）
  classes と teachers を結合して、**学科名** と **担任の先生の名前** を表示しなさい。

-- Q2.（LEFT JOIN ＋ IS NULL）
  学生が1人も所属していないクラスの **学科名** を表示しなさい。
