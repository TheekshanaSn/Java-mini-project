package ADMIN;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.sql.*;

public class User_profile extends JFrame {
    private JButton undergraduateButton;
    private JButton lecturerButton;
    private JButton technicalOfficerButton;
    private JButton addNewButton;
    private JPanel JPanel1;
    private JPanel JPanel2;
    private JPanel JPanelMain;
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton singOutButton;
    private JTable table1;
    private JTextField textField1;
    private JTextField textField2;
    private JButton deleteButton;
    private JButton updateButton;

    // Keep track of currently selected user type
    private String currentUserType = "Undergraduate";

    public User_profile() {
        setTitle("User Profile Management");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);
        setLocationRelativeTo(null); // Center the window on screen

        setupTable();
        loadCourseData();

        // Add selection listener to populate text fields when a row is selected
        table1.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && table1.getSelectedRow() != -1) {
                int selectedRow = table1.getSelectedRow();
                textField1.setText(table1.getValueAt(selectedRow, 0).toString()); // ID

                // Only set department field if not technical officer
                if (!currentUserType.equals("TechnicalOfficer") && table1.getColumnCount() > 1) {
                    textField2.setText(table1.getValueAt(selectedRow, 1).toString()); // Department
                } else {
                    textField2.setText("");
                }
            }
        });

        // User type selection buttons
        undergraduateButton.addActionListener(e -> {
            currentUserType = "Undergraduate";
            loadCourseData();
            // Enable department field for types that have it
            textField2.setEnabled(true);
        });

        lecturerButton.addActionListener(e -> {
            currentUserType = "Lecturer";
            loadCourseData();
            // Enable department field for types that have it
            textField2.setEnabled(true);
        });

        technicalOfficerButton.addActionListener(e -> {
            currentUserType = "TechnicalOfficer";
            loadCourseData();
            // Disable department field for technical officer
            textField2.setEnabled(false);
            textField2.setText("");
        });

        // CRUD operation buttons
        addNewButton.addActionListener(e -> insertData());
        updateButton.addActionListener(e -> updateData());
        deleteButton.addActionListener(e -> deleteData());

        // Navigation buttons
        userButton.addActionListener(e -> {
            // Already on User screen
        });

        courseButton.addActionListener(e -> {
            // Navigate to Course screen
            dispose();
            // Uncomment and modify as needed:
            // Course course = new Course();
        });

        noticeButton.addActionListener(e -> {
            // Navigate to Notice screen
            dispose();
            // Uncomment and modify as needed:
            // Notice notice = new Notice();
        });

        timetableButton.addActionListener(e -> {
            // Navigate to Timetable screen
            dispose();
            // Uncomment and modify as needed:
            // Timetable timetable = new Timetable();
        });

        singOutButton.addActionListener(e -> {
            // Sign out and go to login screen
            dispose();
            // Uncomment and modify as needed:
            // Login login = new Login();
        });

        setVisible(true);
    }

    private void setupTable() {
        DefaultTableModel model = new DefaultTableModel(
                new Object[]{"ID", "Department"}, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false; // Make table read-only
            }
        };

        table1.setModel(model);
        table1.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        table1.getTableHeader().setReorderingAllowed(false);
    }

    private void loadCourseData() {
        DefaultTableModel model = (DefaultTableModel) table1.getModel();
        model.setRowCount(0);

        try (Connection conn = DatabaseConnect.getConnection()) {
            String sql;
            String idColumn;

            if (currentUserType.equals("Undergraduate")) {
                idColumn = "undergraduate_id";
                sql = "SELECT * FROM " + currentUserType;

                // Set two columns for types with department
                model.setColumnIdentifiers(new Object[]{"ID", "Department"});

                try (PreparedStatement stmt = conn.prepareStatement(sql);
                     ResultSet rs = stmt.executeQuery()) {

                    while (rs.next()) {
                        model.addRow(new Object[]{
                                rs.getString(idColumn),
                                rs.getString("department")
                        });
                    }
                }
            } else if (currentUserType.equals("Lecturer")) {
                idColumn = "lecturer_id";
                sql = "SELECT * FROM " + currentUserType;

                // Set two columns for types with department
                model.setColumnIdentifiers(new Object[]{"ID", "Department"});

                try (PreparedStatement stmt = conn.prepareStatement(sql);
                     ResultSet rs = stmt.executeQuery()) {

                    while (rs.next()) {
                        model.addRow(new Object[]{
                                rs.getString(idColumn),
                                rs.getString("department")
                        });
                    }
                }
            } else {
                // Technical officer - only ID column
                idColumn = "to_id";

                sql = "SELECT * FROM " + currentUserType;

                // Set only one column for technical officer
                model.setColumnIdentifiers(new Object[]{"ID"});

                try (PreparedStatement stmt = conn.prepareStatement(sql);
                     ResultSet rs = stmt.executeQuery()) {

                    while (rs.next()) {
                        model.addRow(new Object[]{
                                rs.getString(idColumn)
                        });
                    }
                }
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading data: " + ex.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }

        // Clear the input fields after loading data
        textField1.setText("");
        textField2.setText("");
    }

    private void insertData() {
        String id = textField1.getText().trim();

        if (id.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "Please enter ID",
                    "Input Error",
                    JOptionPane.ERROR_MESSAGE);
            return;
        }

        String idColumn;
        String sql;

        try (Connection conn = DatabaseConnect.getConnection()) {
            if (currentUserType.equals("Undergraduate")) {
                String department = textField2.getText().trim();
                if (department.isEmpty()) {
                    JOptionPane.showMessageDialog(this,
                            "Please enter Department",
                            "Input Error",
                            JOptionPane.ERROR_MESSAGE);
                    return;
                }

                idColumn = "undergraduate_id";
                sql = "INSERT INTO " + currentUserType + " (" + idColumn + ", department) VALUES (?, ?)";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, id);
                    stmt.setString(2, department);

                    executeInsert(stmt);
                }
            } else if (currentUserType.equals("Lecturer")) {
                String department = textField2.getText().trim();
                if (department.isEmpty()) {
                    JOptionPane.showMessageDialog(this,
                            "Please enter Department",
                            "Input Error",
                            JOptionPane.ERROR_MESSAGE);
                    return;
                }

                idColumn = "lecturer_id";
                sql = "INSERT INTO " + currentUserType + " (" + idColumn + ", department) VALUES (?, ?)";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, id);
                    stmt.setString(2, department);

                    executeInsert(stmt);
                }
            } else {
                // Technical officer - only ID column
                idColumn = "to_id";
                String tableName = "technical_officer";
                sql = "INSERT INTO " + currentUserType + " (" + idColumn + ") VALUES (?)";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, id);

                    executeInsert(stmt);
                }
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error connecting to database: " + ex.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void executeInsert(PreparedStatement stmt) throws SQLException {
        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            JOptionPane.showMessageDialog(this,
                    "New " + currentUserType.toLowerCase() + " added successfully!",
                    "Success",
                    JOptionPane.INFORMATION_MESSAGE);

            // Clear fields and reload data
            textField1.setText("");
            textField2.setText("");
            loadCourseData();
        }
    }

    private void updateData() {
        int selectedRow = table1.getSelectedRow();
        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(this,
                    "Please select a row to update",
                    "Selection Error",
                    JOptionPane.ERROR_MESSAGE);
            return;
        }

        String originalId = table1.getValueAt(selectedRow, 0).toString();
        String newId = textField1.getText().trim();

        if (newId.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "Please enter ID",
                    "Input Error",
                    JOptionPane.ERROR_MESSAGE);
            return;
        }

        String idColumn;
        String sql;

        try (Connection conn = DatabaseConnect.getConnection()) {
            if (currentUserType.equals("Undergraduate")) {
                String newDepartment = textField2.getText().trim();
                if (newDepartment.isEmpty()) {
                    JOptionPane.showMessageDialog(this,
                            "Please enter Department",
                            "Input Error",
                            JOptionPane.ERROR_MESSAGE);
                    return;
                }

                idColumn = "undergraduate_id";
                sql = "UPDATE " + currentUserType + " SET " + idColumn + " = ?, department = ? WHERE " + idColumn + " = ?";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, newId);
                    stmt.setString(2, newDepartment);
                    stmt.setString(3, originalId);

                    executeUpdate(stmt);
                }
            } else if (currentUserType.equals("Lecturer")) {
                String newDepartment = textField2.getText().trim();
                if (newDepartment.isEmpty()) {
                    JOptionPane.showMessageDialog(this,
                            "Please enter Department",
                            "Input Error",
                            JOptionPane.ERROR_MESSAGE);
                    return;
                }

                idColumn = "lecturer_id";
                sql = "UPDATE " + currentUserType + " SET " + idColumn + " = ?, department = ? WHERE " + idColumn + " = ?";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, newId);
                    stmt.setString(2, newDepartment);
                    stmt.setString(3, originalId);

                    executeUpdate(stmt);
                }
            } else {
                // Technical officer - only ID column
                idColumn = "technical_officer_id";
                sql = "UPDATE " + currentUserType + " SET " + idColumn + " = ? WHERE " + idColumn + " = ?";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, newId);
                    stmt.setString(2, originalId);

                    executeUpdate(stmt);
                }
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error connecting to database: " + ex.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void executeUpdate(PreparedStatement stmt) throws SQLException {
        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            JOptionPane.showMessageDialog(this,
                    currentUserType + " updated successfully!",
                    "Success",
                    JOptionPane.INFORMATION_MESSAGE);

            // Clear fields and reload data
            textField1.setText("");
            textField2.setText("");
            loadCourseData();
        } else {
            JOptionPane.showMessageDialog(this,
                    "No records were updated",
                    "Update Failed",
                    JOptionPane.WARNING_MESSAGE);
        }
    }

    private void deleteData() {
        int selectedRow = table1.getSelectedRow();
        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(this,
                    "Please select a row to delete",
                    "Selection Error",
                    JOptionPane.ERROR_MESSAGE);
            return;
        }

        String id = table1.getValueAt(selectedRow, 0).toString();

        int confirm = JOptionPane.showConfirmDialog(this,
                "Are you sure you want to delete this " + currentUserType.toLowerCase() + " with ID: " + id + "?",
                "Confirm Deletion",
                JOptionPane.YES_NO_OPTION);

        if (confirm == JOptionPane.YES_OPTION) {
            String idColumn;

            if (currentUserType.equals("Undergraduate")) {
                idColumn = "undergraduate_id";
            } else if (currentUserType.equals("Lecturer")) {
                idColumn = "lecturer_id";
            } else {
                idColumn = "technical_officer_id";
            }

            String sql = "DELETE FROM " + currentUserType + " WHERE " + idColumn + " = ?";

            try (Connection conn = DatabaseConnect.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, id);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    JOptionPane.showMessageDialog(this,
                            currentUserType + " deleted successfully!",
                            "Success",
                            JOptionPane.INFORMATION_MESSAGE);

                    // Clear fields and reload data
                    textField1.setText("");
                    textField2.setText("");
                    loadCourseData();
                } else {
                    JOptionPane.showMessageDialog(this,
                            "No records were deleted",
                            "Deletion Failed",
                            JOptionPane.WARNING_MESSAGE);
                }

            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(this,
                        "Error deleting record: " + ex.getMessage(),
                        "Database Error",
                        JOptionPane.ERROR_MESSAGE);
                ex.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        try {
            // Set system look and feel
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        SwingUtilities.invokeLater(() -> new User_profile());
    }
}