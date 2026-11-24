/**
 * モジュール強度の例
 */
public class Cohesion {

    // ○ 機能的強度：1つの機能だけを行う
    static int withTax(int amount) {
        return amount * 110 / 100;
    }

    // × 論理的強度：似た処理をまとめ、引数で切り替える
    static void output(String message, int type) {
        if (type == 1) {
            System.out.println("[画面] " + message);
        } else if (type == 2) {
            System.out.println("[ログ] " + message);
        } else {
            System.out.println("[印刷] " + message);
        }
    }

    // × 暗合的強度：関係のない処理がたまたま1つにまとまっている
    static void misc() {
        System.out.println("税込: " + withTax(100) + "円");
        System.out.println("今日の天気: 晴れ");
        System.out.println("ユーザー数: 5人");
    }

    public static void main(String[] args) {
        System.out.println(withTax(360) + "円");
        output("保存しました", 1);
        misc();
    }
}
