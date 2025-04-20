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

    private String currentUserType = "Undergraduate";

    public User_profile() {
        setTitle("User Profile Management");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);
        setLocationRelativeTo(null);

        setupTable();
        loadUSERData();

        table1.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && table1.getSelectedRow() != -1) {
                int selectedRow = table1.getSelectedRow();
                textField1.setText(table1.getValueAt(selectedRow, 0).toString());
                if (!currentUserType.equals("TechnicalOfficer") && table1.getColumnCount() > 1) {
                    textField2.setText(table1.getValueAt(selectedRow, 1).toString());
                } else {
                    textField2.setText("");
                }
            }
        });

        undergraduateButton.addActionListener(e -> {
            currentUserType = "Undergraduate";
            loadUSERData();
            textField2.setEnabled(true);
        });

        lecturerButton.addActionListener(e -> {
            currentUserType = "Lecturer";
            loadUSERData();
            textField2.setEnabled(true);
        });

        technicalOfficerButton.addActionListener(e -> {
            currentUserType = "TechnicalOfficer";
            loadUSERData();
            textField2.setEnabled(false);
            textField2.setText("");
        });

        addNewButton.addActionListener(e -> insertData());
        updateButton.addActionListener(e -> updateData());
        deleteButton.addActionListener(e -> deleteData());

        setVisible(true);
    }

    private void setupTable() {
        table1.setModel(new DefaultTableModel());
        table1.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        table1.getTableHeader().setReorderingAllowed(false);
    }

    private void loadUSERData() {
        DefaultTableModel model = (DefaultTableModel) table1.getModel();
        model.setRowCount(0);

        try (Connection conn = DatabaseConnect.getConnection()) {
            String sql;
            String idColumn;

            if (currentUserType.equals("Undergraduate")) {
                idColumn = "undergraduate_id";
                sql = "SELECT * FROM undergraduate";
                model.setColumnIdentifiers(new Object[]{"ID", "Department"});
            } else if (currentUserType.equals("Lecturer")) {
                idColumn = "lecturer_id";
                sql = "SELECT * FROM lecturer";
                model.setColumnIdentifiers(new Object[]{"ID", "Department"});
            } else {
                idColumn = "to_id";
                sql = "SELECT * FROM technical_officer";
                model.setColumnIdentifiers(new Object[]{"ID"});
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    if (currentUserType.equals("TechnicalOfficer")) {
                        model.addRow(new Object[]{rs.getString(idColumn)});
                    } else {
                        model.addRow(new Object[]{
                                rs.getString(idColumn),
                                rs.getString("department")
                        });
                    }
                }
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading data: " + ex.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
        }

        textField1.setText("");
        textField2.setText("");
        table1.clearSelection();
    }

    private void insertData() {
        String id = textField1.getText().trim();

        if (id.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter ID", "Input Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        String idColumn;
        String sql;

        try (Connection conn = DatabaseConnect.getConnection()) {
            if (currentUserType.equals("Undergraduate")) {
                String department = textField2.getText().trim();
                if (department.isEmpty()) {
                    JOptionPane.showMessageDialog(this, "Please enter Department", "Input Error", JOptionPane.ERROR_MESSAGE);
                    return;
                }

                idColumn = "undergraduate_id";
                sql = "INSERT INTO undergraduate (" + idColumn + ", department) VALUES (?, ?)";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, id);
                    stmt.setString(2, department);
                    executeInsert(stmt);
                }

            } else if (currentUserType.equals("Lecturer")) {
                String department = textField2.getText().trim();
                if (department.isEmpty()) {
                    JOptionPane.showMessageDialog(this, "Please enter Department", "Input Error", JOptionPane.ERROR_MESSAGE);
                    return;
                }

                idColumn = "lecturer_id";
                sql = "INSERT INTO lecturer (" + idColumn + ", department) VALUES (?, ?)";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, id);
                    stmt.setString(2, department);
                    executeInsert(stmt);
                }

            } else {
                idColumn = "to_id";
                sql = "INSERT INTO technical_officer (" + idColumn + ") VALUES (?)";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, id);
                    executeInsert(stmt);
                }
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Database Error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void executeInsert(PreparedStatement stmt) throws SQLException {
        int rows = stmt.executeUpdate();
        if (rows > 0) {
            JOptionPane.showMessageDialog(this,
                    "New " + currentUserType.toLowerCase() + " added successfully!",
                    "Success", JOptionPane.INFORMATION_MESSAGE);
            textField1.setText("");
            textField2.setText("");
            loadUSERData();
        }
    }

    private void updateData() {
        int row = table1.getSelectedRow();
        if (row == -1) {
            JOptionPane.showMessageDialog(this, "Please select a row", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        String originalId = table1.getValueAt(row, 0).toString();
        String newId = textField1.getText().trim();
        if (newId.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter ID", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        String idColumn, sql;

        try (Connection conn = DatabaseConnect.getConnection()) {
            if (currentUserType.equals("Undergraduate")) {
                String department = textField2.getText().trim();
                if (department.isEmpty()) {
                    JOptionPane.showMessageDialog(this, "Please enter Department", "Error", JOptionPane.ERROR_MESSAGE);
                    return;
                }

                idColumn = "undergraduate_id";
                sql = "UPDATE undergraduate SET " + idColumn + " = ?, department = ? WHERE " + idColumn + " = ?";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, newId);
                    stmt.setString(2, department);
                    stmt.setString(3, originalId);
                    executeUpdate(stmt);
                }

            } else if (currentUserType.equals("Lecturer")) {
                String department = textField2.getText().trim();
                if (department.isEmpty()) {
                    JOptionPane.showMessageDialog(this, "Please enter Department", "Error", JOptionPane.ERROR_MESSAGE);
                    return;
                }

                idColumn = "lecturer_id";
                sql = "UPDATE lecturer SET " + idColumn + " = ?, department = ? WHERE " + idColumn + " = ?";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, newId);
                    stmt.setString(2, department);
                    stmt.setString(3, originalId);
                    executeUpdate(stmt);
                }

            } else {
                idColumn = "to_id";
                sql = "UPDATE technical_officer SET " + idColumn + " = ? WHERE " + idColumn + " = ?";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, newId);
                    stmt.setString(2, originalId);
                    executeUpdate(stmt);
                }
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Error updating record: " + ex.getMessage(), "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void executeUpdate(PreparedStatement stmt) throws SQLException {
        int rows = stmt.executeUpdate();
        if (rows > 0) {
            JOptionPane.showMessageDialog(this, "Record updated successfully!", "Success", JOptionPane.INFORMATION_MESSAGE);
            textField1.setText("");
            textField2.setText("");
            loadUSERData();
        }
    }

    private void deleteData() {
        int row = table1.getSelectedRow();
        if (row == -1) {
            JOptionPane.showMessageDialog(this, "Select a row to delete", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        String id = table1.getValueAt(row, 0).toString();
        int confirm = JOptionPane.showConfirmDialog(this,
                "Are you sure you want to delete " + currentUserType + " with ID: " + id + "?",
                "Confirm Delete", JOptionPane.YES_NO_OPTION);

        if (confirm == JOptionPane.YES_OPTION) {
            String idColumn;

            if (currentUserType.equals("Undergraduate")) {
                idColumn = "undergraduate_id";
            } else if (currentUserType.equals("Lecturer")) {
                idColumn = "lecturer_id";
            } else {
                idColumn = "to_id";
            }

            String tableName = currentUserType.equals("TechnicalOfficer") ? "technical_officer" : currentUserType.toLowerCase();
            String sql = "DELETE FROM " + tableName + " WHERE " + idColumn + " = ?";

            try (Connection conn = DatabaseConnect.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, id);

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    JOptionPane.showMessageDialog(this, "Deleted successfully!", "Success", JOptionPane.INFORMATION_MESSAGE);
                    textField1.setText("");
                    textField2.setText("");
                    loadUSERData();
                }

            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(this, "Error deleting: " + ex.getMessage(), "Database Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    public static void main(String[] args) {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignored) {}
        SwingUtilities.invokeLater(User_profile::new);
    }
}
