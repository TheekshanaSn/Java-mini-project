import java.sql.DriverManager;

public class MyConnection {


    public static void main(String[] args) {

         String url = "jdbc:mysql://localhost:3306/apollo";
         String username = "root";// my roots
         String password = "";

        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/apollo","root","");
            Statement stmt = ((java.sql.Connection) con).createStatement();

            ResultSet rs = stmt.executeQuery("select * from user");
            while(rs.next()){
                System.out.println(rs.getString(1)+" "+rs.getString(2)+" "+rs.getString(3)+" "+rs.getString(4)+" "+rs.getString(5)+" "+rs.getString(6));
            }

//            ((java.sql.Connection) con).close();

        }catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
}
