package ADMIN;

import MyCon.MyConnection;
import UserLogin.LoginForm;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
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
    private JTextField textField3;
    private JTextField textField4;
    private JTextField textField5;
    private JTextField textField6;
    private JTextField textField7;
    private JTextField textField8;

    private String currentRole = "undergraduate";

    public User_profile() {
        setTitle("User Profile");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(1080, 600);

        setupTable();

        undergraduateButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                currentRole = "undergraduate";
                clearFields();
                loadUsersByRole(currentRole);
            }
        });

        lecturerButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                currentRole = "lecturer";
                clearFields();
                loadUsersByRole(currentRole);
            }
        });

        technicalOfficerButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                currentRole = "technicalOfficer";
                clearFields();
                loadUsersByRole(currentRole);
            }
        });

        addNewButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                addNewUser();
            }
        });

        updateButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                updateUser();
            }
        });

        deleteButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                deleteUser();
            }
        });

        // Load  records after given id
        textField1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String userId = textField1.getText().trim();
                if (!userId.isEmpty()) {
                    loadUserById(userId);
                }
            }
        });

        userButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    User_profile userProfile = new User_profile();
                });
            }
        });

        courseButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    new Course_unit();
                });

            }
        });

        noticeButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    Notice notice = new Notice();
                });
            }
        });

        timetableButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    Timetable timetable = new Timetable();
                });
            }
        });

        singOutButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    new LoginForm();
                });
            }
        });



        table1.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                int selectedRow = table1.getSelectedRow();
                if (selectedRow >= 0) {
                    textField1.setText(table1.getValueAt(selectedRow, 0).toString());
                    textField2.setText(table1.getValueAt(selectedRow, 1).toString());
                    textField3.setText(table1.getValueAt(selectedRow, 2).toString());
                    textField4.setText(table1.getValueAt(selectedRow, 3).toString());
                    textField5.setText(table1.getValueAt(selectedRow, 4).toString());
                    textField6.setText(table1.getValueAt(selectedRow, 5).toString());
                    textField7.setText(table1.getValueAt(selectedRow, 6).toString());

                    // Load department information based on role
                    String userId = table1.getValueAt(selectedRow, 0).toString();
                    String role = table1.getValueAt(selectedRow, 6).toString();
                    loadDepartmentInfo(userId, role);
                }
            }
        });


        loadUsersByRole("undergraduate");

        setLocationRelativeTo(null);
        setVisible(true);
    }



    private void setupTable() {
        DefaultTableModel model = new DefaultTableModel(
                new Object[]{"User ID", "Email", "Name", "Phone", "Username", "Password", "Role", "Department"}, 0);
        table1.setModel(model);
    }

    private void loadUsersByRole(String role) {
        DefaultTableModel model = (DefaultTableModel) table1.getModel();
        model.setRowCount(0); // Clear existing rows

        try (Connection conn = MyConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT u.*, COALESCE(ug.department, l.department, null) as department " +
                             "FROM User u " +
                             "LEFT JOIN undergraduate ug ON u.user_id = ug.undergraduate_id AND u.role = 'undergraduate' " +
                             "LEFT JOIN lecturer l ON u.user_id = l.lecturer_id AND u.role = 'lecturer' " +
                             "WHERE u.role = ?")) {

            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                model.addRow(new Object[]{
                        rs.getString("user_id"),
                        rs.getString("email"),
                        rs.getString("Name"),
                        rs.getString("phone"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("department")
                });
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading user data: " + ex.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void loadUserById(String userId) {
        try (Connection conn = MyConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT u.*, COALESCE(ug.department, l.department, null) as department " +
                             "FROM User u " +
                             "LEFT JOIN undergraduate ug ON u.user_id = ug.undergraduate_id AND u.role = 'undergraduate' " +
                             "LEFT JOIN lecturer l ON u.user_id = l.lecturer_id AND u.role = 'lecturer' " +
                             "WHERE u.user_id = ?")) {

            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                textField1.setText(rs.getString("user_id"));
                textField2.setText(rs.getString("email"));
                textField3.setText(rs.getString("Name"));
                textField4.setText(rs.getString("phone"));
                textField5.setText(rs.getString("username"));
                textField6.setText(rs.getString("password"));
                textField7.setText(rs.getString("role"));
                textField8.setText(rs.getString("department"));


                currentRole = rs.getString("role");
            } else {
                clearFields();
                textField1.setText(userId);
                JOptionPane.showMessageDialog(this,
                        "No user found with ID: " + userId,
                        "User Not Found", JOptionPane.INFORMATION_MESSAGE);
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading user data: " + ex.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void loadDepartmentInfo(String userId, String role) {
        try (Connection conn = MyConnection.getConnection()) {
            PreparedStatement stmt = null;

            if ("undergraduate".equals(role)) {
                stmt = conn.prepareStatement("SELECT department FROM undergraduate WHERE undergraduate_id = ?");
            } else if ("lecturer".equals(role)) {
                stmt = conn.prepareStatement("SELECT department FROM lecturer WHERE lecturer_id = ?");
            } else if ("technicalOfficer".equals(role)) {
                stmt = conn.prepareStatement("SELECT department FROM technical_officer WHERE to_id = ?");
            }

            if (stmt != null) {
                stmt.setString(1, userId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    textField8.setText(rs.getString("department"));
                } else {
                    textField8.setText("");
                }

                stmt.close();
            } else {
                textField8.setText("");
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading department info: " + ex.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private boolean validateUserData() {
        String userId = textField1.getText().trim();
        String email = textField2.getText().trim();
        String name = textField3.getText().trim();
        String phone = textField4.getText().trim();
        String username = textField5.getText().trim();
        String password = textField6.getText().trim();
        String role = textField7.getText().trim().toLowerCase();
        String department = textField8.getText().trim();


        if (userId.isEmpty() || email.isEmpty() || name.isEmpty() || phone.isEmpty()
                || username.isEmpty() || password.isEmpty() || role.isEmpty()) {
            JOptionPane.showMessageDialog(this, "All fields are required.");
            return false;
        }


        boolean validId = false;// set value false

        if (role.equals("undergraduate") && userId.matches("^UG\\d{3}$")) {
            validId = true;
        } else if (role.equals("lecturer") && userId.matches("^LEC\\d{3}$")) {
            validId = true;
        } else if (role.equals("technicalofficer") && userId.matches("^TCO\\d{3}$")) {
            validId = true;
        }

        if (!validId) {
            JOptionPane.showMessageDialog(this,
                    "Invalid ID format. Use UG### for undergraduate, LEC### for lecturer, or TCO### for technical officer.",
                    "Validation Error", JOptionPane.ERROR_MESSAGE);
            textField1.requestFocus();
            return false;
        }



        if (!phone.matches("^[0-9]{10}$")) {
            JOptionPane.showMessageDialog(this,
                    "Phone number must be exactly 10 digits.",
                    "Validation Error", JOptionPane.ERROR_MESSAGE);
            textField4.requestFocus();
            return false;
        }


        if (!role.equals("undergraduate") && !role.equals("lecturer") && !role.equals("technicalofficer")) {
            JOptionPane.showMessageDialog(this,
                    "Role must be 'undergraduate', 'lecturer', or 'technicalofficer'.",
                    "Validation Error", JOptionPane.ERROR_MESSAGE);
            textField7.requestFocus();
            return false;
        }


        if ((role.equals("undergraduate") || role.equals("lecturer")) && department.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Department is required.",
                    "Validation Error", JOptionPane.ERROR_MESSAGE);
            textField8.requestFocus();
            return false;
        }

            else if (!department.equals("ICT") && !department.equals("ET") && !department.equals("BST")) {
            JOptionPane.showMessageDialog(this,
                    "Department must be 'ICT', 'ET', or 'BST'.",
                    "Validation Error", JOptionPane.ERROR_MESSAGE);
            textField8.requestFocus();
            return false;
        }

        return true;
    }


    private void addNewUser() {

        if (!validateUserData()) {
            return;
        }

        String userId = textField1.getText().trim();
        String email = textField2.getText().trim();
        String name = textField3.getText().trim();
        String phone = textField4.getText().trim();
        String username = textField5.getText().trim();
        String password = textField6.getText().trim();
        String role = textField7.getText().trim().toLowerCase(); // Normalize case
        String department = textField8.getText().trim();


        try (Connection conn = MyConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                // Check for duplicate User ID
                PreparedStatement checkStmt = conn.prepareStatement("SELECT user_id FROM User WHERE user_id = ?");
                checkStmt.setString(1, userId);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    JOptionPane.showMessageDialog(this, "User ID already exists.");
                    rs.close();
                    checkStmt.close();
                    return;
                }
                rs.close();
                checkStmt.close();


                PreparedStatement pstmt = conn.prepareStatement(
                        "INSERT INTO User (user_id, email, Name, phone, username, password, role) VALUES (?, ?, ?, ?, ?, ?, ?)");
                pstmt.setString(1, userId);
                pstmt.setString(2, email);
                pstmt.setString(3, name);
                pstmt.setString(4, phone);
                pstmt.setString(5, username);
                pstmt.setString(6, password);
                pstmt.setString(7, role);
                pstmt.executeUpdate();
                pstmt.close();


                switch (role) {
                    case "undergraduate":
                        PreparedStatement ugStmt = conn.prepareStatement(
                                "INSERT INTO undergraduate (undergraduate_id, department) VALUES (?, ?)");
                        ugStmt.setString(1, userId);
                        ugStmt.setString(2, department);
                        ugStmt.executeUpdate();
                        ugStmt.close();
                        break;

                    case "lecturer":
                        PreparedStatement lecStmt = conn.prepareStatement(
                                "INSERT INTO lecturer (lecturer_id, department) VALUES (?, ?)");
                        lecStmt.setString(1, userId);
                        lecStmt.setString(2, department);
                        lecStmt.executeUpdate();
                        lecStmt.close();
                        break;

                    case "technicalofficer":
                        PreparedStatement toStmt = conn.prepareStatement(
                                "INSERT INTO technical_officer (to_id) VALUES (?)");
                        toStmt.setString(1, userId);
                        toStmt.executeUpdate();
                        toStmt.close();
                        break;

                    default:
                        JOptionPane.showMessageDialog(this, "Invalid role provided.");
                        conn.rollback();
                        return;
                }

                conn.commit();
                JOptionPane.showMessageDialog(this, "User added successfully.");
                loadUsersByRole(role);
                clearFields();

            } catch (SQLException ex) {
                conn.rollback();
                JOptionPane.showMessageDialog(this,
                        "Error adding user: " + ex.getMessage(),
                        "Database Error", JOptionPane.ERROR_MESSAGE);
                ex.printStackTrace();
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Database connection error: " + ex.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }


    private void updateUser() {

        if (!validateUserData()) {
            return;
        }

        String userId = textField1.getText().trim();
        String email = textField2.getText().trim();
        String name = textField3.getText().trim();
        String phone = textField4.getText().trim();
        String username = textField5.getText().trim();
        String password = textField6.getText().trim();
        String role = textField7.getText().trim();
        String department = textField8.getText().trim();

        if (userId.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please select a user to update.");
            return;
        }

        try (Connection conn = MyConnection.getConnection()) {
            conn.setAutoCommit(false);


            try (PreparedStatement pstmt = conn.prepareStatement(
                    "UPDATE User SET email = ?, Name = ?, phone = ?, username = ?, password = ?, role = ? WHERE user_id = ?")) {

                pstmt.setString(1, email);
                pstmt.setString(2, name);
                pstmt.setString(3, phone);
                pstmt.setString(4, username);
                pstmt.setString(5, password);
                pstmt.setString(6, role);
                pstmt.setString(7, userId);

                pstmt.executeUpdate();
            }


            if (!department.isEmpty()) {
                String oldRole = currentRole;
                String newRole = role;

                // If role changed it recods delete role related table and new rol enter and it records insert new roal match table
                if (!oldRole.equals(newRole)) {
                    if ("undergraduate".equals(oldRole)) {
                        PreparedStatement deleteStmt = conn.prepareStatement(
                                "DELETE FROM undergraduate WHERE undergraduate_id = ?");
                        deleteStmt.setString(1, userId);
                        deleteStmt.executeUpdate();
                        deleteStmt.close();
                    } else if ("lecturer".equals(oldRole)) {
                        PreparedStatement deleteStmt = conn.prepareStatement(
                                "DELETE FROM lecturer WHERE lecturer_id = ?");
                        deleteStmt.setString(1, userId);
                        deleteStmt.executeUpdate();
                        deleteStmt.close();
                    } else if ("technicalOfficer".equals(oldRole)) {
                        PreparedStatement deleteStmt = conn.prepareStatement(
                                "DELETE FROM technical_officer WHERE to_id = ?");
                        deleteStmt.setString(1, userId);
                        deleteStmt.executeUpdate();
                        deleteStmt.close();
                    }


                    PreparedStatement insertStmt = null;
                    if ("undergraduate".equals(newRole)) {
                        insertStmt = conn.prepareStatement(
                                "INSERT INTO undergraduate (undergraduate_id, department) VALUES (?, ?)");
                    } else if ("lecturer".equals(newRole)) {
                        insertStmt = conn.prepareStatement(
                                "INSERT INTO lecturer (lecturer_id, department) VALUES (?, ?)");
                    } else if ("technicalOfficer".equals(newRole)) {
                        insertStmt = conn.prepareStatement(
                                "INSERT INTO technical_officer (to_id, department) VALUES (?, ?)");
                    }

                    if (insertStmt != null) {
                        insertStmt.setString(1, userId);
                        insertStmt.setString(2, department);
                        insertStmt.executeUpdate();
                        insertStmt.close();
                    }
                } else {

                    PreparedStatement updateStmt = null;
                    if ("undergraduate".equals(role)) {
                        updateStmt = conn.prepareStatement(
                                "UPDATE undergraduate SET department = ? WHERE undergraduate_id = ?");
                    } else if ("lecturer".equals(role)) {
                        updateStmt = conn.prepareStatement(
                                "UPDATE lecturer SET department = ? WHERE lecturer_id = ?");
                    } else if ("technicalOfficer".equals(role)) {
                        updateStmt = conn.prepareStatement(
                                "UPDATE technical_officer SET department = ? WHERE to_id = ?");
                    }

                    if (updateStmt != null) {
                        updateStmt.setString(1, department);
                        updateStmt.setString(2, userId);
                        updateStmt.executeUpdate();
                        updateStmt.close();
                    }
                }
            }

            conn.commit();
            JOptionPane.showMessageDialog(this, "User updated successfully.");
            currentRole = role; // Update current role
            loadUsersByRole(role);
            clearFields();

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error updating user: " + ex.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void deleteUser() {
        String userId = textField1.getText().trim();

        if (userId.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please select a user to delete.");
            return;
        }

        int confirm = JOptionPane.showConfirmDialog(this,
                "Are you sure you want to delete this user?",
                "Confirm Delete", JOptionPane.YES_NO_OPTION);

        if (confirm != JOptionPane.YES_OPTION) {
            return;
        }

        try (Connection conn = MyConnection.getConnection()) {
            conn.setAutoCommit(false);

            String role = currentRole;


            if ("undergraduate".equals(role)) {
                PreparedStatement deleteStmt = conn.prepareStatement(
                        "DELETE FROM undergraduate WHERE undergraduate_id = ?");
                deleteStmt.setString(1, userId);
                deleteStmt.executeUpdate();
                deleteStmt.close();
            } else if ("lecturer".equals(role)) {
                PreparedStatement deleteStmt = conn.prepareStatement(
                        "DELETE FROM lecturer WHERE lecturer_id = ?");
                deleteStmt.setString(1, userId);
                deleteStmt.executeUpdate();
                deleteStmt.close();
            } else if ("technicalOfficer".equals(role)) {
                PreparedStatement deleteStmt = conn.prepareStatement(
                        "DELETE FROM technical_officer WHERE to_id = ?");
                deleteStmt.setString(1, userId);
                deleteStmt.executeUpdate();
                deleteStmt.close();
            }


            PreparedStatement deleteUserStmt = conn.prepareStatement(
                    "DELETE FROM User WHERE user_id = ?");
            deleteUserStmt.setString(1, userId);
            deleteUserStmt.executeUpdate();

            conn.commit();
            JOptionPane.showMessageDialog(this, "User deleted successfully.");
            loadUsersByRole(role);
            clearFields();

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error deleting user: " + ex.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void clearFields() {
        textField1.setText("");
        textField2.setText("");
        textField3.setText("");
        textField4.setText("");
        textField5.setText("");
        textField6.setText("");
        textField7.setText("");
        textField8.setText("");
    }

    public static void main(String[] args) {

        SwingUtilities.invokeLater(() ->
                new User_profile());
    }
}