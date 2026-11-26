/**
 * Purchase のテスト（テストドライバ）
 *
 *   javac -encoding UTF-8 Purchase.java PurchaseTest.java
 *   java -ea PurchaseTest        ← -ea を付けないと assert は実行されない！
 *
 * assert 条件 : "メッセージ";
 *   条件が true  → 何も起きない（合格）
 *   条件が false → AssertionError で止まり、メッセージが表示される（不合格）
 */
public class PurchaseTest {

    public static void main(String[] args) {

        // -ea を付け忘れていないか確認
        boolean enabled = false;
        assert enabled = true;
        if (!enabled) {
            System.out.println("assert が無効です。java -ea PurchaseTest で実行してください。");
            return;
        }

        // ---- 小計 ----
        assert Purchase.subtotal(100, 3) == 300 : "100円×3個";

        // ---- 割引：同値分割 ----
        assert Purchase.discount(8000, true)  == 500 : "会員・5000円以上";
        assert Purchase.discount(3000, true)  == 0   : "会員・5000円未満";
        assert Purchase.discount(8000, false) == 0   : "非会員";

        // ---- 割引：境界値分析 ----
        assert Purchase.discount(4999, true) == 0   : "会員・4999円";
        assert Purchase.discount(5000, true) == 500 : "会員・5000円";

        // ---- 割引：ホワイトボックス（条件網羅）----
        assert Purchase.discount(8000, false) == 0 : "条件網羅 金額○・会員×";
        assert Purchase.discount(3000, true)  == 0 : "条件網羅 金額×・会員○";

        // ---- 支払金額（小計と割引をつないだテスト）----
        assert Purchase.pay(1000, 5, true)  == 4500 : "1000円×5個・会員";
        assert Purchase.pay(1000, 5, false) == 5000 : "1000円×5個・非会員";

        System.out.println("すべてのテストに合格しました");
    }
}
