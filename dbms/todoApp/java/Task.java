import java.time.LocalDate;

/**
 * TODO（tasks テーブルに対応）
 *
 * テーブルでは user_id・category_id という「番号」を持つが、
 * クラスでは User・Category の「オブジェクト」そのものを持つ。
 */
public class Task {
    private int id;
    private String title;
    private String description;
    private LocalDate deadline;
    private boolean completed;   // false：未完了、true：完了（is_completed の 0 / 1 に対応）
    private User user;
    private Category category;

    public Task(int id, String title, String description, LocalDate deadline,
                User user, Category category) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.deadline = deadline;
        this.completed = false;  // 登録時は未完了（DEFAULT 0 に対応）
        this.user = user;
        this.category = category;
    }

    public int getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    /** TODOを完了にする */
    public void complete() {
        this.completed = true;
    }

    /** 一覧表示用の文字列 */
    @Override
    public String toString() {
        return id + " | " + title + " | " + category.getName()
                + " | " + deadline + " | " + (completed ? "完了" : "未完了");
    }
}
