package Admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database connection utility class for managing database connections
 */
public class DatabaseConnect {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/teclmsk";
    private static final String DB_USER = "root"; // Replace with your DB username
    private static final String DB_PASSWORD = ""; // Replace with your DB password

    private Connection connection;

    /**
     * Constructor - establishes a database connection
     * @throws SQLException if connection fails
     */
    public DatabaseConnect() throws SQLException {
        try {
            // Load JDBC driver (optional for newer JDBC versions)
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Create the connection
            this.connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found: " + e.getMessage());
        }
    }

    /**
     * Get the database connection
     * @return an active database connection
     */
    public Connection getConnection() {
        return connection;
    }

    /**
     * Close the database connection
     */
    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.out.println("Error closing connection: " + e.getMessage());
            }
        }
    }
}
