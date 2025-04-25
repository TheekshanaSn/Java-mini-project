package ADMIN;

import Connection.MyConnection;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;

public class Timetable extends JFrame {
    private JButton addNewButton;
    private JButton updateButton;
    private JButton deleteButton;
    private JTable table1;
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton singOutButton;
    private JPanel JPanelMain;
    private JPanel JPanel1;
    private JPanel JPanel2;
    private JScrollPane JScrollPane;
    private JTextField textField1;
    private JTextField textField2;
    private JTextField textField3;
    private JTextField textField4;
    private JTextField textField5;
    private JTextField textField6;


    public Timetable() {
        setTitle("Timetable");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);

        setupTable();
        loadTimetableData();

        addNewButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                addNewButtonActionPerformed(e);
            }
        });

        updateButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                updateButtonActionPerformed(e);
            }
        });

        deleteButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                deleteButtonActionPerformed(e);
            }
        });

        // Load timetable record when ID is entered
        textField1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String timetableId = textField1.getText().trim();
                if (!timetableId.isEmpty()) {
                    loadTimetableById(timetableId);
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
                new Course_unit();
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
                SwingUtilities.invokeLater(() -> {
                    loadTimetableData();
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


        // Mouse click to populate fields
        table1.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                int selectedRow = table1.getSelectedRow();
                if (selectedRow >= 0) {
                    textField1.setText(table1.getValueAt(selectedRow, 0).toString());
                    textField2.setText(table1.getValueAt(selectedRow, 1).toString());
                    textField3.setText(table1.getValueAt(selectedRow, 2).toString());
                    textField4.setText(table1.getValueAt(selectedRow, 3).toString());
                    textField5.setText(table1.getValueAt(selectedRow, 4).toString());
                    textField6.setText(table1.getValueAt(selectedRow, 5).toString());
                }
            }
        });

        setLocationRelativeTo(null);
        setVisible(true);
    }

    private void setupTable() {
        DefaultTableModel model = new DefaultTableModel(
                new Object[]{"ID", "Day", "Time_range", "Course Code", "Type", "Lecturer ID"}, 0);
        table1.setModel(model);
    }

    private void loadTimetableData() {
        DefaultTableModel model = (DefaultTableModel) table1.getModel();
        model.setRowCount(0); // Clear existing rows

        try (Connection conn = MyConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Timetable");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                model.addRow(new Object[]{
                        rs.getString("Timetable_id"),
                        rs.getString("day"),
                        rs.getString("time_range"),
                        rs.getString("course_code"),
                        rs.getString("course_type"),
                        rs.getString("lecturer_id")
                });
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading timetable data: " + ex.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void loadTimetableById(String timetableId) {
        try (Connection conn = MyConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Timetable WHERE Timetable_id = ?")) {

            stmt.setString(1, timetableId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Populate fields with data
                textField2.setText(rs.getString("day"));
                textField3.setText(rs.getString("time_range"));
                textField4.setText(rs.getString("course_code"));
                textField5.setText(rs.getString("course_type"));
                textField6.setText(rs.getString("lecturer_id"));
            } else {
                // No record found with this ID
                clearFields();
                textField1.setText(timetableId); // Keep the ID for adding new entry
                JOptionPane.showMessageDialog(this,
                        "No timetable record found with ID: " + timetableId,
                        "Record Not Found", JOptionPane.INFORMATION_MESSAGE);
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading timetable data: " + ex.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void addNewButtonActionPerformed(ActionEvent evt) {
        String timetableId = textField1.getText().trim();
        String day = textField2.getText().trim();
        String time_range = textField3.getText().trim();
        String courseCode = textField4.getText().trim();
        String courseType = textField5.getText().trim();
        String lecturerId = textField6.getText().trim();

        if (timetableId.isEmpty() || day.isEmpty() || time_range.isEmpty() ||
                courseCode.isEmpty() || courseType.isEmpty() || lecturerId.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please fill in all required fields.");
            return;
        }
        if (!timetableId.matches("^Tt\\d{3}$")) {
            JOptionPane.showMessageDialog(this, "Invalid Timetable ID format.");
            return;
        }
        String[] validDays = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};

        boolean validDay = false;
        for (String validDayName : validDays) {
            if (day.equalsIgnoreCase(validDayName)) {
                validDay = true;
                break;
            }
        }
        if (!validDay) {
            JOptionPane.showMessageDialog(this, "Invalid day. Must be a weekday (Monday to Friday).");
            return;
        }

        try {
            SimpleDateFormat parser = new SimpleDateFormat("h:mm a");
            Date enteredTime = parser.parse(time_range);

            Date eightAM = parser.parse("8:00 AM");
            Date fivePM = parser.parse("5:00 PM");

            if (enteredTime.before(eightAM) || enteredTime.after(fivePM)) {
                JOptionPane.showMessageDialog(this, "Invalid time. Must  lec on between 8:00 AM and 5:00 PM.");
                return;
            }

        } catch (ParseException e) {
            JOptionPane.showMessageDialog(this, "Invalid time format.format like 08:00 AM -17:00 PM.");
            return;
        }

        if (!courseCode.matches("^ICT\\d{4}$")) {
            JOptionPane.showMessageDialog(this, "Invalid course code format.");
            return;
        }
        if (!courseType.equals("T") && !courseType.equals("P") && !courseType.equals("TP")) {
            JOptionPane.showMessageDialog(this, "Invalid course type format.");
            return;
        }
        if (!lecturerId.matches("^LEC\\d{3}$")) {
            JOptionPane.showMessageDialog(this, "Invalid Lec id format.");
            return;
        }


        String sql = "INSERT INTO Timetable (Timetable_id, day, time_range, course_code, course_type, lecturer_id) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = MyConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, timetableId);
            pstmt.setString(2, day);
            pstmt.setString(3, time_range);
            pstmt.setString(4, courseCode);
            pstmt.setString(5, courseType);
            pstmt.setString(6, lecturerId);

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                JOptionPane.showMessageDialog(this, "New timetable entry added successfully.");
                loadTimetableData();
                clearFields();
            } else {
                JOptionPane.showMessageDialog(this, "Failed to add timetable entry.");
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void updateButtonActionPerformed(ActionEvent evt) {
        String timetableId = textField1.getText().trim();
        String day = textField2.getText().trim();
        String time_range = textField3.getText().trim();
        String courseCode = textField4.getText().trim();
        String courseType = textField5.getText().trim();
        String lecturerId = textField6.getText().trim();

        if (timetableId.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Select a timetable entry to update.");
            return;
        }

        String sql = "UPDATE Timetable SET day = ?, time_range = ?, course_code = ?, course_type = ?, lecturer_id = ? WHERE Timetable_id = ?";

        try (Connection conn = MyConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, day);
            pstmt.setString(2, time_range);
            pstmt.setString(3, courseCode);
            pstmt.setString(4, courseType);
            pstmt.setString(5, lecturerId);
            pstmt.setString(6, timetableId);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                JOptionPane.showMessageDialog(this, "Timetable entry updated successfully.");
                loadTimetableData();
                clearFields();
            } else {
                JOptionPane.showMessageDialog(this, "Update failed. Record may not exist.");
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void deleteButtonActionPerformed(ActionEvent evt) {
        String timetableId = textField1.getText().trim();

        if (timetableId.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Select a timetable entry to delete.");
            return;
        }

        int confirm = JOptionPane.showConfirmDialog(this, "Are you sure you want to delete this entry?",
                "Confirm Delete", JOptionPane.YES_NO_OPTION);
        if (confirm != JOptionPane.YES_OPTION) return;

        String sql = "DELETE FROM Timetable WHERE Timetable_id = ?";

        try (Connection conn = MyConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, timetableId);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                JOptionPane.showMessageDialog(this, "Timetable entry deleted successfully.");
                loadTimetableData();
                clearFields();
            } else {
                JOptionPane.showMessageDialog(this, "Delete failed. Record may not exist.");
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void clearFields() {
        textField1.setText("");
        textField2.setText("");
        textField3.setText("");
        textField4.setText("");
        textField5.setText("");
        textField6.setText("");
    }

    public static void main(String[] args) {

        SwingUtilities.invokeLater(Timetable::new);
    }
}