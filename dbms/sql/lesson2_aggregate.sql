-- ============================================================
--  第2回：集計関数と GROUP BY / HAVING
-- ------------------------------------------------------------
--  この授業のゴール：
--   ・COUNT / SUM / AVG / MAX / MIN の集計関数が使える
--   ・GROUP BY で「グループごとの集計」ができる
--   ・HAVING で「集計結果に対する絞り込み」ができる
--   ・WHERE と HAVING の違いを説明できる
-- ============================================================


-- ------------------------------------------------------------
-- 【講師デモ】1. COUNT：件数を数える
-- ------------------------------------------------------------
SELECT COUNT(*) FROM students;

-- 【講師デモ】2. SUM：合計を求める
SELECT SUM(score) FROM scores WHERE subject_id = 2;  -- 数学の合計点

-- 【講師デモ】3. AVG：平均を求める
SELECT AVG(score) FROM scores WHERE subject_id = 1;  -- 国語の平均点

-- 【講師デモ】4. MAX / MIN：最大値・最小値
SELECT MAX(score), MIN(score) FROM scores WHERE subject_id = 3;  -- 英語

-- 【講師デモ】5. GROUP BY：グループごとに集計する
--    「科目ごとの平均点」を一度に求める
SELECT subject_id, AVG(score) AS avg_score
FROM scores
GROUP BY subject_id;

-- 【講師デモ】6. GROUP BY を複数列の集計と組み合わせる
SELECT student_id, MAX(score) AS best, MIN(score) AS worst
FROM scores
GROUP BY student_id;

-- 【講師デモ】7. HAVING：集計した"あと"の結果を絞り込む
--    ※ WHERE は集計する"前"の行を絞り込む、HAVING は集計した"後"の結果を絞り込む、という違いに注意！
SELECT subject_id, AVG(score) AS avg_score
FROM scores
GROUP BY subject_id
HAVING AVG(score) >= 80;

-- 【講師デモ】8. WHERE と HAVING を同時に使う例
--    「7月10日以降の試験だけを対象に、学生ごとの平均点が70点未満の人」を探す
SELECT student_id, AVG(score) AS avg_score
FROM scores
WHERE exam_date >= '2026-07-10'
GROUP BY student_id
HAVING AVG(score) < 70;


-- ============================================================
-- 【演習問題】
-- ============================================================

-- Q1. scoresテーブルの件数を COUNT で数えなさい。


-- Q2. subject_id が 2（数学）の合計点を SUM で求めなさい。


-- Q3. 学生ごと（student_id ごと）の平均点を GROUP BY で求めなさい。


-- Q4. 科目ごと（subject_id ごと）の最高点と最低点を求めなさい。


-- Q5. 学生ごとの平均点を求め、そのうち平均点が70点未満の学生だけを
--     HAVING で抽出しなさい。


-- Q6. studentsテーブルを使って、class_id ごとの学生数を COUNT で求めなさい。
--     （ヒント：GROUP BY class_id）


-- Q7.【総合問題】科目ごとの平均点を求め、平均点が高い順（降順）に
--     並び替えて表示しなさい。（GROUP BY と ORDER BY の組み合わせ）


-- Q8.【考察問題（SQLは書かなくてOK）】
--     WHERE と HAVING はどちらも「絞り込み」をしますが、何が違うか
--     自分の言葉で説明してみましょう。

