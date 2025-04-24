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
//            System.out.println("succesfully connected to database");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            throw new RuntimeException("Database connection failed: " + e.getMessage(), e);
        }
    }
}

    //     Main method to test
//    public static void main(String[] args) {
//        try (Connection conn = getConnection()) {
//          displaylecturer();
//            System.out.println("succesfully connected to database");
//        } catch (SQLException e) {
//            System.out.println("Database connection error: " + e.getMessage());
//        }
//    }
//}

