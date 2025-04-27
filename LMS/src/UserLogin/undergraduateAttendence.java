package UserLogin;

import net.proteanit.sql.DbUtils;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class undergraduateAttendence extends JFrame {
    private JComboBox<String> comboBox1;
    private JTable table1;
    private JButton backButton;
    private JPanel ugAttendence;
    private JPanel percentage;
    //private JLabel attendanceLabel;
    private JLabel attendanceLabel;

    private String userId;
    private String password;
    private PreparedStatement pst;

    public undergraduateAttendence(String userId, String password) {
        this.userId = userId;
        this.password = password;

        setTitle("Undergraduate Attendance");
        setContentPane(ugAttendence);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(900, 600);
        setLocationRelativeTo(null);

        loadCourseList();
        setupListeners();
        setVisible(true);
    }

    private void loadCourseList() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            String query = "SELECT DISTINCT at_course_code FROM Attendance WHERE at_undergraduate_id = ?";
            pst = conn.prepareStatement(query);
            pst.setString(1, userId);
            ResultSet rs = pst.executeQuery();

            comboBox1.removeAllItems();
            while (rs.next()) {
                comboBox1.addItem(rs.getString("at_course_code"));
            }

            rs.close();
            pst.close();
            conn.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error loading course list: " + e.getMessage());
        }
    }

    private void setupListeners() {
        comboBox1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String courseCode = (String) comboBox1.getSelectedItem();
                loadAttendanceData(courseCode);
                calculateAndShowPercentage(courseCode);
            }
        });

        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new undergraduate_Dash(userId, password);
            }
        });
    }

    private void loadAttendanceData(String courseCode) {
        if (courseCode == null) return;

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            String query = "SELECT * FROM Attendance WHERE at_undergraduate_id = ? AND at_course_code = ?";
            pst = conn.prepareStatement(query);
            pst.setString(1, userId);
            pst.setString(2, courseCode);
            ResultSet rs = pst.executeQuery();

            table1.setModel(DbUtils.resultSetToTableModel(rs));

            rs.close();
            pst.close();
            conn.close();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, "Error loading attendance data: " + ex.getMessage());
        }
    }

    private void calculateAndShowPercentage(String courseCode) {
        if (courseCode == null) return;

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            // Count total sessions for the course
            String totalQuery = "SELECT COUNT(*) as total FROM Attendance WHERE at_undergraduate_id = ? AND at_course_code = ?";
            pst = conn.prepareStatement(totalQuery);
            pst.setString(1, userId);
            pst.setString(2, courseCode);
            ResultSet rs = pst.executeQuery();
            int totalSessions = 0;
            if (rs.next()) {
                totalSessions = rs.getInt("total");
            }
            rs.close();
            pst.close();

            // Count present sessions
            String presentQuery = "SELECT COUNT(*) as present FROM Attendance WHERE at_undergraduate_id = ? AND at_course_code = ? AND attendance = 'present'";
            pst = conn.prepareStatement(presentQuery);
            pst.setString(1, userId);
            pst.setString(2, courseCode);
            rs = pst.executeQuery();
            int presentSessions = 0;
            if (rs.next()) {
                presentSessions = rs.getInt("present");
            }
            rs.close();
            pst.close();
            conn.close();

            // Calculate percentage
            double percentage = (totalSessions == 0) ? 0 : ((double) presentSessions / totalSessions) * 100;
            attendanceLabel.setText("Attendance for Course: " + courseCode + " = " + String.format("%.2f", percentage) + "%");

        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, "Error calculating percentage: " + ex.getMessage());
        }
    }

    public static void main(String[] args) {
        new undergraduateAttendence("UG005", "pass123");
    }
}
