import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class CsvSample {
    public static void main(String[] args) throws Exception {

        List<String> lines =
            Files.readAllLines(Path.of("dbms/java/data_struct/students.csv"));

        for (int i = 1; i < lines.size(); i++) {
            String[] data = lines.get(i).split(",");

            int id = Integer.parseInt(data[0]);
            String name = data[1];
            int age = Integer.parseInt(data[2]);

            System.out.println(
                id + " : " + name + " : " + age
            );
        }
    }
}
