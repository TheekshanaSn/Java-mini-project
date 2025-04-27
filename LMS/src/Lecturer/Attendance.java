package Lecturer;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.Set;

public class Attendance extends JFrame {

    private JTable table1;
    private JButton btnBack;
    private JButton btnExit;
    private JLabel lblCourse;
    private JPanel mainA;
    private String user_id;
    private String password;
    private String course_code;


    Attendance(String username, String password) {
        this.user_id = username;
        this.password = password;

        setTitle("Attendance ");
        setContentPane(mainA);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);
        setResizable(false);

        getLecturerCourseCodeAndName(user_id);
        LoadAttendance();
        btnBack.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new ViewUndergraduate(user_id, password);
            }
        });
        btnExit.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });
    }

    private void getLecturerCourseCodeAndName(String user_id) {
        PreparedStatement pst;
        try {
            Conn conn = new Conn();
            pst = conn.c.prepareStatement("SELECT course_code, name FROM course_unit WHERE c_lecturer_id=?");
            pst.setString(1, user_id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                course_code = rs.getString(1);
                lblCourse.setText(course_code);
                System.out.println("Course code: " + course_code);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }


    public void LoadAttendance() {

        String sql = "SELECT u.Name, a.at_undergraduate_id, a.at_course_code, a.attendance " +
                "FROM Attendance a " +
                "JOIN User u ON a.at_undergraduate_id = u.user_id " +
                "WHERE a.at_course_code = ?";

        Conn conn = new Conn();
        try {
            PreparedStatement pst = conn.c.prepareStatement(sql);
            pst.setString(1, course_code);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"Undergraduate Name", "Undergraduate ID", "Course Code", "Attendance Percentage"}, 0
            );

            Set<String> addedStudents = new HashSet<>();

            while (rs.next()) {
                String name = rs.getString("Name");
                String id = rs.getString("at_undergraduate_id");
                String code = rs.getString("at_course_code");
                String attendance = rs.getString("attendance");


                if (addedStudents.contains(id)) {
                    continue;
                }


                double attendancePercentage = getAttendancePercentage(id, code);


                addedStudents.add(id);


                model.addRow(new Object[]{name, id, code, String.format("%.2f", attendancePercentage) + "%"});
            }

            table1.setModel(model);
            System.out.println("Loading table for course_code: " + course_code);

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error loading attendance.");
        }
    }

    private double getAttendancePercentage(String undergraduateId, String courseCode) {
        int totalSessions = getTotalSessions(courseCode, undergraduateId);
        int attendedSessions = countAttendance(courseCode, undergraduateId);

        double attendancePercentage = 0;
        if (totalSessions > 0) {
            attendancePercentage = ((double) attendedSessions / totalSessions) * 100;
        }
        return attendancePercentage;
    }

    private int getTotalSessions(String courseCode, String undergraduateId) {
        int totalSessions = 0;
        try {
            Conn conn = new Conn();
            String sql = "SELECT COUNT(DISTINCT session_no) FROM Attendance WHERE at_course_code = ? AND at_undergraduate_id = ?";
            PreparedStatement pst = conn.c.prepareStatement(sql);
            pst.setString(1, courseCode);
            pst.setString(2, undergraduateId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                totalSessions = rs.getInt(1);
            }
            System.out.println("Total sessions for " + courseCode + " and student " + undergraduateId + ": " + totalSessions);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalSessions;
    }

    private int countAttendance(String courseCode, String undergraduateId) {
        int attendedSessions = 0;
        try {
            Conn conn = new Conn();
            String sql = "SELECT COUNT(*) FROM Attendance WHERE at_course_code = ? AND at_undergraduate_id = ? AND attendance = 'present'";
            PreparedStatement pst = conn.c.prepareStatement(sql);
            pst.setString(1, courseCode);
            pst.setString(2, undergraduateId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                attendedSessions = rs.getInt(1); // Get the count of "present" records
            }
            System.out.println("Attended sessions for " + courseCode + " and student " + undergraduateId + ": " + attendedSessions);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return attendedSessions;
    }

    public static void main(String[] args) {
        new Attendance("LEC002", "pass123").setVisible(true);
    }
}
