import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * TODOアプリ本体。ユーザー・カテゴリ・TODOをまとめて管理する。
 * IDは「登録件数 + 1」で割り当てる（主キーの自動採番の代わり）。
 */
public class TodoApp {
    private List<User> users = new ArrayList<>();
    private List<Category> categories = new ArrayList<>();
    private List<Task> tasks = new ArrayList<>();

    /** 機能1：ユーザー登録 */
    public User registerUser(String name) {
        User user = new User(users.size() + 1, name);
        users.add(user);
        return user;
    }

    /** 機能3：カテゴリの追加 */
    public Category addCategory(String name) {
        Category category = new Category(categories.size() + 1, name);
        categories.add(category);
        return category;
    }

    /** 機能2：TODO登録 */
    public Task addTask(String title, String description, LocalDate deadline,
                        User user, Category category) {
        Task task = new Task(tasks.size() + 1, title, description, deadline, user, category);
        tasks.add(task);
        return task;
    }

    /** 機能4：自分のTODO一覧（SELECT ... WHERE user_id = ? に対応） */
    public List<Task> findTasksByUser(User user) {
        List<Task> result = new ArrayList<>();
        for (Task task : tasks) {
            if (task.getUser() == user) {
                result.add(task);
            }
        }
        return result;
    }

    /** 機能5：完了状態の変更 */
    public void completeTask(int id) {
        for (Task task : tasks) {
            if (task.getId() == id) {
                task.complete();
            }
        }
    }
}
