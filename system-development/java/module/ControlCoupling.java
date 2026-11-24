/**
 * 制御結合の例
 * 呼び出し側がフラグを渡して、呼び出し先の処理内容を切り替えている。
 */
public class ControlCoupling {

    // mode によって処理が変わる（呼び出し側が中身を知っている必要がある）
    static int calc(int amount, int mode) {
        if (mode == 1) {
            return amount * 110 / 100;  // 税込
        } else {
            return amount * 108 / 100;  // 軽減税率
        }
    }

    public static void main(String[] args) {
        System.out.println(calc(360, 1) + "円");
        System.out.println(calc(360, 2) + "円");
    }
}
