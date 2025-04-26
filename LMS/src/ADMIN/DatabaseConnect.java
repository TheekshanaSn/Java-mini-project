//package ADMIN;
//
//import java.sql.*;
//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.SQLException;
//
//
//public class DatabaseConnect {
//    private static final String URL = "jdbc:mysql://localhost:3306/techlmsk";
//   private static final String URL = "jdbc:mysql://127.0.0.1:3306/techlmsk";
//    private static final String USER = "root";
//    private static final String PASSWORD = "";
//
//    public static Connection getConnection() throws SQLException {
//        return DriverManager.getConnection(URL, USER, PASSWORD);
//    }
//}

//        try {
//            System.out.println("succesfully connected to database");
//            return DriverManager.getConnection(URL, USER, PASSWORD);
//        } catch (SQLException e) {
//            throw new RuntimeException("Database connection failed: " + e.getMessage(), e);
//        }
//    }
//}


