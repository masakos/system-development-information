/**
 * データ結合の例（良い例）
 * 各モジュールは「必要なデータだけ」を引数で受け取り、結果を戻り値で返す。
 */
public class DataCoupling {

    // 小計を求める：単価と数量だけを受け取る
    static int subtotal(int price, int quantity) {
        return price * quantity;
    }

    // 税込金額を求める：金額だけを受け取る
    static int withTax(int amount) {
        return amount * 110 / 100;
    }

    public static void main(String[] args) {
        int sub = subtotal(120, 3);   // 引数：単価・数量 → 戻り値：小計
        int total = withTax(sub);     // 引数：小計       → 戻り値：税込金額

        System.out.println("小計: " + sub + "円");
        System.out.println("税込: " + total + "円");
    }
}
