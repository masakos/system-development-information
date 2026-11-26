/**
 * スタブとドライバの例
 * 割引の計算がまだ完成していない、という想定で 支払金額 をテストする。
 *
 *   javac -encoding UTF-8 StubTest.java
 *   java -ea StubTest
 */
public class StubTest {

    // スタブ：未完成の「割引計算」の代わり。いつも 500 を返すだけ
    static int discountStub(int subtotal, boolean member) {
        return 500;
    }

    // テスト対象：支払金額（割引はスタブを呼ぶ）
    static int pay(int price, int quantity, boolean member) {
        int sub = price * quantity;
        return sub - discountStub(sub, member);
    }

    // ドライバ：テスト対象を呼び出して結果を確かめる
    public static void main(String[] args) {
        assert pay(1000, 3, true) == 2500 : "1000円×3個";
        System.out.println("すべてのテストに合格しました");
    }
}
