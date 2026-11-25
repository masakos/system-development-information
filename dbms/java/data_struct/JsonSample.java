import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JsonSample {
    public static void main(String[] args) throws Exception {

        ObjectMapper mapper = new ObjectMapper();

        JsonNode root = mapper.readTree(
            new java.io.File("dbms/java/data_struct/students.json")
        );

        JsonNode students = root.get("students");

        for (JsonNode student : students) {

            int id = student.get("id").asInt();
            String name = student.get("name").asText();
            int age = student.get("age").asInt();

            System.out.println(
                id + " : " + name + " : " + age
            );
        }
    }
}
