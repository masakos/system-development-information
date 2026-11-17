import java.time.LocalDate;

/**
 * TodoApp の動作確認
 */
public class Main {
    public static void main(String[] args) {
        TodoApp app = new TodoApp();

        // ユーザー・カテゴリを登録
        User tanaka = app.registerUser("田中");
        User suzuki = app.registerUser("鈴木");
        Category school = app.addCategory("学校");
        Category work = app.addCategory("仕事");
        Category privateLife = app.addCategory("プライベート");

        // TODOを登録
        app.addTask("DBの課題", "演習問題を解く", LocalDate.of(2026, 10, 30), tanaka, school);
        app.addTask("Javaの復習", "ArrayListを復習する", LocalDate.of(2026, 10, 31), tanaka, school);
        app.addTask("会議資料の作成", "資料を準備する", LocalDate.of(2026, 10, 29), suzuki, work);
        app.addTask("買い物", "食料品を購入する", LocalDate.of(2026, 10, 30), suzuki, privateLife);

        System.out.println("=== 登録直後 ===");
        printTasks(app, tanaka);
        printTasks(app, suzuki);

        // 完了にする
        app.completeTask(1);

        System.out.println("=== 完了にした後 ===");
        printTasks(app, tanaka);
        printTasks(app, suzuki);
    }

    /** ユーザーごとのTODO一覧を表示する */
    private static void printTasks(TodoApp app, User user) {
        System.out.println("[" + user.getName() + "さんのTODO]");
        for (Task task : app.findTasksByUser(user)) {
            System.out.println("  " + task);
        }
    }
}
