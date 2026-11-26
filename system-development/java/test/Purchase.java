/**
 * テスト対象：商品の購入金額を計算するプログラム
 *
 * 【仕様】
 *   小計     ＝ 単価 × 数量
 *   割引     ＝ 会員 かつ 小計が5000円以上 なら 500円、それ以外は 0円
 *   支払金額 ＝ 小計 − 割引
 */
public class Purchase {

    // 小計を求める
    static int subtotal(int price, int quantity) {
        return price * quantity;
    }

    // 割引額を求める
    static int discount(int subtotal, boolean member) {
        int d = 0;
        if (subtotal >= 5000 && member) {
            d = 500;
        }
        return d;
    }

    // 支払金額を求める
    static int pay(int price, int quantity, boolean member) {
        int sub = subtotal(price, quantity);
        return sub - discount(sub, member);
    }
}
