package MyCon;

import java.sql.*;

public class MyConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/techlmsk";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() throws SQLException {
//        System.out.println("succesfully connected to database");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

