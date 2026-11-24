/**
 * 共通結合の例（悪い例）
 * 複数のモジュールが、static 変数を共有して読み書きしている。
 * static変数：変数が「インスタンス（実体）」ではなく「クラスそのもの」に属する
 * static をつけた変数はクラスに1つしか存在しないため、どこから書き換えても全員で同じ値を共有する
 */
public class CommonCoupling {

    // どこからでも読み書きできる共通データ
    static int amount;
    static int total;

    static void subtotal() {
        amount = 120 * 3;
    }

    static void withTax() {
        total = amount * 110 / 100;   // amount を誰がいつ変えたか分からない
    }

    public static void main(String[] args) {
        subtotal();
        withTax();
        System.out.println("税込: " + total + "円");
    }
}
