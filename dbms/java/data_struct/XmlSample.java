import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.*;

public class XmlSample {
    public static void main(String[] args) throws Exception {

        var factory = DocumentBuilderFactory.newInstance();
        var builder = factory.newDocumentBuilder();

        Document document = builder.parse("dbms/java/data_struct/students.xml");

        NodeList students =
            document.getElementsByTagName("student");

        for (int i = 0; i < students.getLength(); i++) {

            Element student = (Element) students.item(i);

            String id = student.getElementsByTagName("id")
                               .item(0).getTextContent();

            String name = student.getElementsByTagName("name")
                                 .item(0).getTextContent();

            String age = student.getElementsByTagName("age")
                                .item(0).getTextContent();

            System.out.println(id + " : " + name + " : " + age);
        }
    }
}
