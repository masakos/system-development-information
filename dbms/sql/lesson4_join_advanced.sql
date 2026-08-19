-- ============================================================
--  第4回：JOINの応用（3テーブル結合／LEFT JOIN／JOIN＋集計）
-- ------------------------------------------------------------
--  この授業のゴール：
--   ・3つ以上のテーブルをJOINでつなげられる
--   ・LEFT JOINで「対応するデータが無い行」も含めて表示できる
--   ・JOIN と GROUP BY／集計関数を組み合わせられる
-- ============================================================


-- ------------------------------------------------------------
-- 【講師デモ】1. 3テーブルJOIN：学生名・科目名・点数を同時に見る
-- ------------------------------------------------------------
SELECT s.student_name, sub.subject_name, sc.score
FROM students AS s
JOIN scores   AS sc  ON s.student_id = sc.student_id
JOIN subjects AS sub ON sc.subject_id = sub.subject_id
ORDER BY s.student_id, sub.subject_id;


-- 【講師デモ】2. INNER JOIN の弱点を確認する
--    松本優花さん（student_id = 10）は転校してきたばかりで、
--    「社会」の成績データがまだ登録されていない設定になっている。
--    INNER JOINだと、データが無い組み合わせはそもそも表示されない！
SELECT s.student_name, sub.subject_name, sc.score
FROM students AS s
JOIN scores   AS sc  ON s.student_id = sc.student_id
JOIN subjects AS sub ON sc.subject_id = sub.subject_id
WHERE s.student_id = 10;
-- ↑ 5科目のうち4件しか出てこない（社会が無い）


-- 【講師デモ】3. LEFT JOIN：左側のテーブルは全件残す
--    subjects を軸にして、松本さんが「まだ受けていない科目」を
--    NULLとして可視化する
SELECT sub.subject_name, sc.score
FROM subjects AS sub
LEFT JOIN scores AS sc
    ON sub.subject_id = sc.subject_id AND sc.student_id = 10;
-- ↑ 社会（社会科目の行）だけ score が NULL になる＝「未受験」だと一目でわかる


-- 【講師デモ】4. JOIN + GROUP BY + AVG：学生名つきで平均点を出す
SELECT s.student_name, AVG(sc.score) AS avg_score
FROM students AS s
JOIN scores AS sc ON s.student_id = sc.student_id
GROUP BY s.student_id
ORDER BY avg_score DESC;


-- ============================================================
-- 【演習問題】
-- ============================================================

-- Q1. students・scores・subjects を結合し、「学生名」「科目名」「点数」
--     を一覧表示しなさい。（【講師デモ1】と同じ形でOK、練習として自分で書く）


-- Q2. LEFT JOIN を使って、全学生が全科目（5科目）分の成績を持っているか
--     確認しなさい。（ヒント：students × subjects を軸にして scores を
--     LEFT JOINし、score が NULL の行を探す）


-- Q3. 松本優花さん（student_id = 10）の成績一覧をLEFT JOINで表示し、
--     どの科目が未受験か答えなさい。


-- Q4. JOINとGROUP BYを使って、学生ごとの平均点を「学生名つき」で求め、
--     平均点が高い順に並び替えて表示しなさい。


-- Q5. students・classes・scores を結合し、クラスごと（class_name ごと）
--     の平均点を求めなさい。（3テーブルJOIN + GROUP BY + AVG）


-- Q6. subjects と scores を結合し、科目ごとの受験者数（COUNT）を
--     求めなさい。（ヒント：社会は松本さんの分が無いので、他の科目より
--     1件少なくなるはず）

