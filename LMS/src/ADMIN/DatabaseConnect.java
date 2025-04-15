package ADMIN;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnect {

    // Database credentials
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/techlmsk";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    // Method to get connection
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            throw new RuntimeException("Database connection failed: " + e.getMessage(), e);
        }
    }


    // Method to display lecturers
//    public static void displaylecturer() {
//        String sql = "SELECT * FROM lecturer"; // ✅ Make sure the table name is correct
//
//        try (Connection conn = getConnection();
//             Statement stmt = conn.createStatement();
//             ResultSet rs = stmt.executeQuery(sql)) {
//
//            System.out.println("ID\tDepartment");
//            System.out.println("------------------------------------------------------------");
//
//            while (rs.next()) {
//                String lecturer_id = rs.getString("lecturer_id");
//                String department = rs.getString("department");
//
//                System.out.printf("%s\t%s%n", lecturer_id, department);
//            }
//
//        } catch (SQLException e) {
//            System.out.println("Error fetching lecturers: " + e.getMessage());
//        }
//    }

    //     Main method to test
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
//           displaylecturer();
            System.out.println("succesfully connected to database");
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
        }
    }
}

