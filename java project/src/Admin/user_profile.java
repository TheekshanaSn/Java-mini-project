
package Admin;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
// Remove the Dao import and use our local DatabaseConnection
// import Dao.DatabaseConnection;

public class User_Profile extends JFrame {
    // Other fields...
    private JTable table1;
    private JScrollPane tableScrollPane;
    private DatabaseConnect dbConnection;
    private AbstractButton singOutButton;
    private JPanel JPanelMain;
    private JPanel JPanel1;
    private JPanel JPanel2;
    // Constructor and other methods...

    public User_Profile() {
        // Other initialization code...

        try {
            // Create an instance of our DatabaseConnection class
            dbConnection = new DatabaseConnect();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Database connection error: " + e.getMessage(),
                    "Error", JOptionPane.ERROR_MESSAGE);
        }

        // Other code...
    }

    private void loadUserData(String userType) {
        try {
            // Get connection from our DatabaseConnection instance
            Connection conn = dbConnection.getConnection();
            String query = "SELECT user_id, name, email, phone_number, gender FROM users WHERE user_type = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userType);
            ResultSet rs = pstmt.executeQuery();

            // Clear existing table data
            DefaultTableModel model = (DefaultTableModel) table1.getModel();
            model.setRowCount(0);

            // Populate table with data from result set
            while (rs.next()) {
                Object[] row = new Object[] {
                        rs.getString("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("gender")
                };
                model.addRow(row);
            }

            pstmt.close();
            rs.close();
            // Don't close connection here, as we'll reuse it
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error loading user data: " + e.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    // Add this method to clean up resources when closing the application
    public void cleanup() {
        if (dbConnection != null) {
            dbConnection.closeConnection();
        }
    }

    // Add window listener to handle closing and cleanup
    private void setupWindowListener() {
        addWindowListener(new java.awt.event.WindowAdapter() {
            @Override
            public void windowClosing(java.awt.event.WindowEvent windowEvent) {
                cleanup();
            }
        });
    }

    private void initializeComponents() {
        // Initialize panels
        JPanelMain = new JPanel(new BorderLayout());
        JPanel1 = new JPanel(new GridLayout(6, 1, 10, 20));
        JPanel1.setBackground(new Color(96, 126, 170));
        JPanel2 = new JPanel(new BorderLayout());
        JPanel2.setBackground(new Color(204, 204, 255));

        // Initialize buttons for the sidebar
        userButton = createMenuButton("User");
        courseButton = createMenuButton("Course");
        noticeButton = createMenuButton("Notice");
        timetableButton = createMenuButton("Timetable");
        singOutButton = createMenuButton("Sign out");

        // Initialize user type buttons
        JPanel userTypePanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 20, 10));
        userTypePanel.setOpaque(false);
        undergraduateButton = createUserTypeButton("Undergraduate");
        lecturerButton = createUserTypeButton("Lecturer");
        technicalOfficerButton = createUserTypeButton("Technical Officer");

        // Add user type buttons to the panel
        userTypePanel.add(undergraduateButton);
        userTypePanel.add(lecturerButton);
        userTypePanel.add(technicalOfficerButton);

        // Add New button
        addNewButton = new JButton("Add New");
        addNewButton.setBackground(new Color(64, 64, 64));
        addNewButton.setForeground(Color.WHITE);
        addNewButton.setBorderPainted(false);
        addNewButton.setFocusPainted(false);

        // Create title label
        JLabel titleLabel = new JLabel("User Profile", JLabel.CENTER);
        titleLabel.setFont(new Font("Arial", Font.BOLD, 24));
        titleLabel.setForeground(Color.WHITE);

        // Initialize table
        table1 = new JTable();
        table1.setModel(new DefaultTableModel(
                new Object [][] {},
                new String [] {"ID", "Name", "Email", "Phone Number", "Gender"}
        ));
        tableScrollPane = new JScrollPane(table1);

        // Panel for the Add New button
        JPanel addButtonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        addButtonPanel.setOpaque(false);
        addButtonPanel.add(addNewButton);

        // Create a panel for the top section (title and user type buttons)
        JPanel topPanel = new JPanel(new BorderLayout());
        topPanel.setOpaque(false);
        topPanel.add(titleLabel, BorderLayout.NORTH);
        topPanel.add(userTypePanel, BorderLayout.CENTER);
        topPanel.add(addButtonPanel, BorderLayout.EAST);

        // Add components to JPanel2
        JPanel2.add(topPanel, BorderLayout.NORTH);
        JPanel2.add(tableScrollPane, BorderLayout.CENTER);
    }

    private void initializeLayout() {
        // Add buttons to JPanel1 (sidebar)
        JPanel1.add(new JLabel("ADMIN", JLabel.CENTER));
        JPanel1.add(userButton);
        JPanel1.add(courseButton);
        JPanel1.add(noticeButton);
        JPanel1.add(timetableButton);
        JPanel1.add(singOutButton);

        // Add panels to main panel
        JPanelMain.add(JPanel1, BorderLayout.WEST);
        JPanelMain.add(JPanel2, BorderLayout.CENTER);

        // Set content pane
        setContentPane(JPanelMain);
    }

    private void setupEventHandlers() {
        // Action listeners for user type buttons
        undergraduateButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                loadUserData("undergraduate");
            }
        });

        lecturerButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                loadUserData("lecturer");
            }
        });

        technicalOfficerButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                loadUserData("technical_officer");
            }
        });

        // Add New button action
        addNewButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                openAddUserDialog();
            }
        });

        // Menu button actions
        singOutButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                // Assuming you have a login form class
                // new LoginForm().setVisible(true);
            }
        });
    }

    private JButton createMenuButton(String text) {
        JButton button = new JButton(text);
        button.setBackground(new Color(64, 64, 64));
        button.setForeground(Color.WHITE);
        button.setFocusPainted(false);
        button.setBorderPainted(false);
        return button;
    }

    private JButton createUserTypeButton(String text) {
        JButton button = new JButton(text);
        button.setBackground(new Color(64, 64, 64));
        button.setForeground(Color.WHITE);
        button.setFocusPainted(false);
        button.setBorderPainted(false);
        return button;
    }

    private void loadUserData(String userType) {
        try {
            Connection conn = dbConnection.getConnection();
            String query = "SELECT user_id, name, email, phone_number, gender FROM users WHERE user_type = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userType);
            ResultSet rs = pstmt.executeQuery();

            // Clear existing table data
            DefaultTableModel model = (DefaultTableModel) table1.getModel();
            model.setRowCount(0);

            // Populate table with data from result set
            while (rs.next()) {
                Object[] row = new Object[] {
                        rs.getString("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("gender")
                };
                model.addRow(row);
            }

            pstmt.close();
            rs.close();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error loading user data: " + e.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void openAddUserDialog() {
        // Here you would open a dialog to add a new user
        // This could be implemented similar to your adminProfile class
        // For example:
        // new AddUserForm().setVisible(true);
        JOptionPane.showMessageDialog(this, "Add New User functionality not implemented yet.");
    }

    public static void main(String[] args) {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                new User_Profile();
            }
        });
    }
}