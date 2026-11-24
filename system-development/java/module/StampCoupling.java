/**
 * スタンプ結合の例
 * 単価と数量しか使わないのに、Order（データ構造）をまるごと渡している。
 */
public class StampCoupling {

    // 注文1件分のデータをまとめたクラス
    static class Order {
        String customer;  // 顧客名
        String address;   // 住所
        int price;        // 単価
        int quantity;     // 数量

        Order(String customer, String address, int price, int quantity) {
            this.customer = customer;
            this.address = address;
            this.price = price;
            this.quantity = quantity;
        }
    }

    // Order 全体を受け取るが、使うのは price と quantity だけ
    static int subtotal(Order order) {
        return order.price * order.quantity;
    }

    public static void main(String[] args) {
        Order order = new Order("田中", "東京都", 120, 3);
        System.out.println("小計: " + subtotal(order) + "円");
    }
}
