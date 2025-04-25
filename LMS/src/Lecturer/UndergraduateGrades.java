package Lecturer;

import net.proteanit.sql.DbUtils;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

public class UndergraduateGrades extends JFrame {
    private JTextField txtSearch;
    private JButton btnSearch;
    private JTable tblGradeMark;
    private JButton btnExit;
    private JButton btnBack;

    private JPanel Grade;
    private JTable table1;

    UndergraduateGrades() {
        setTitle("CA Mark Profile");

        setContentPane(Grade);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(1000, 800);
        setLocationRelativeTo(null);
        setVisible(true);
        table_load();

        // Add action listeners
        btnSearch.addActionListener(e -> searchStudent());
        btnExit.addActionListener(e -> System.exit(0));
        btnBack.addActionListener(e -> dispose());
    }

    private void searchStudent() {
        String searchText = txtSearch.getText().trim();
        if (searchText.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter a student ID to search");
            return;
        }

        try {
            Conn conn = new Conn();
            PreparedStatement pst = conn.c.prepareStatement(
                    "SELECT c.undergraduate_id, c.course_code, c.camarks, f.finalmarks " +
                            "FROM camarks c " +
                            "JOIN finalmarks f " +
                            "ON c.undergraduate_id = f.undergraduate_id " +
                            "AND c.course_code = f.course_code " +
                            "WHERE c.undergraduate_id LIKE ?"
            );
            pst.setString(1, "%" + searchText + "%");

            ResultSet rs = pst.executeQuery();
            table1.setModel(DbUtils.resultSetToTableModel(rs));

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(this, "Error searching: " + e.getMessage());
        }
    }

    // Modified table_load method to check CA status
    void table_load() {
        try {
            Conn conn = new Conn();

            // First, query all unique student IDs and course codes to build the table structure
            PreparedStatement pstStudents = conn.c.prepareStatement(
                    "SELECT DISTINCT undergraduate_id FROM camarks ORDER BY undergraduate_id"
            );
            ResultSet rsStudents = pstStudents.executeQuery();

            // Get all course codes
            PreparedStatement pstCourses = conn.c.prepareStatement(
                    "SELECT DISTINCT course_code FROM camarks ORDER BY course_code"
            );
            ResultSet rsCourses = pstCourses.executeQuery();

            List<String> students = new ArrayList<>();
            while (rsStudents.next()) {
                students.add(rsStudents.getString("undergraduate_id"));
            }

            List<String> courses = new ArrayList<>();
            while (rsCourses.next()) {
                courses.add(rsCourses.getString("course_code"));
            }

            // Create the table model with proper column structure
            DefaultTableModel model = new DefaultTableModel();
            model.addColumn("No");
            model.addColumn("Index Number");
            model.addColumn("Student Name");

            // Add each course as a column
            for (String course : courses) {
                model.addColumn(course);
            }

            // Add GPA columns
            model.addColumn("SGPA");
            model.addColumn("CGPA");

            // For each student, create a row with their grades
            int rowNum = 1;
            for (String studentId : students) {
                Vector<Object> row = new Vector<>();
                row.add(rowNum++);  // No. column
                row.add(studentId); // Index Number

                // In a real system, you would fetch the student name from a students table
                row.add("Student " + studentId.substring(2)); // Student Name

                // Fetch grades for each course
                Map<String, String> grades = new HashMap<>();
                double totalGradePoints = 0;
                int courseCount = 0;

                for (String course : courses) {
                    PreparedStatement pst = conn.c.prepareStatement(
                            "SELECT c.camarks, c.status, f.finalmarks " +
                                    "FROM camarks c " +
                                    "LEFT JOIN finalmarks f " +
                                    "ON c.undergraduate_id = f.undergraduate_id " +
                                    "AND c.course_code = f.course_code " +
                                    "WHERE c.undergraduate_id = ? AND c.course_code = ?"
                    );
                    pst.setString(1, studentId);
                    pst.setString(2, course);

                    ResultSet rs = pst.executeQuery();

                    if (rs.next()) {
                        double caMarks = rs.getDouble("camarks");
                        String caStatus = rs.getString("status");
                        double finalMarks = rs.getDouble("finalmarks");

                        // Check if CA status is "fail"
                        if (caStatus != null && caStatus.equalsIgnoreCase("fail")) {
                            row.add("F");
                            grades.put(course, "F");
                        } else {
                            double totalMarks = caMarks + finalMarks;

                            // Convert marks to letter grade
                            String letterGrade = getLetterGrade(totalMarks);
                            grades.put(course, letterGrade);

                            // Add to grade points for GPA calculation
                            double gradePoint = getGradePoint(letterGrade);
                            totalGradePoints += gradePoint;
                            courseCount++;

                            // Add the letter grade to the row
                            row.add(letterGrade);
                        }
                    } else {
                        row.add("-"); // No grade available
                    }
                }

                // Calculate GPA
                double gpa = (courseCount > 0) ? totalGradePoints / courseCount : 0.0;
                row.add(String.format("%.2f", gpa)); // SGPA
                row.add(String.format("%.2f", gpa)); // CGPA (using same as SGPA for simplicity)

                model.addRow(row);
            }

            table1.setModel(model);

            // Format the table for better readability
            table1.setRowHeight(25);
            table1.getTableHeader().setFont(new Font("SansSerif", Font.BOLD, 12));

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(this, "Error loading data: " + e.getMessage());
        }
    }

    // Helper method to convert total marks to letter grade
    private String getLetterGrade(double totalMarks) {
        if (totalMarks >= 80) return "A+";
        else if (totalMarks >= 75) return "A";
        else if (totalMarks >= 70) return "A-";
        else if (totalMarks >= 65) return "B+";
        else if (totalMarks >= 60) return "B";
        else if (totalMarks >= 55) return "B-";
        else if (totalMarks >= 50) return "C+";
        else if (totalMarks >= 45) return "C";
        else if (totalMarks >= 40) return "C-";
        else if (totalMarks >= 35) return "D+";
        else if (totalMarks >= 30) return "D";
        else return "E";
    }

    // Helper method to convert letter grade to grade point
    private double getGradePoint(String letterGrade) {
        switch (letterGrade) {
            case "A+": return 4.00;
            case "A": return 4.00;
            case "A-": return 3.70;
            case "B+": return 3.30;
            case "B": return 3.00;
            case "B-": return 2.70;
            case "C+": return 2.30;
            case "C": return 2.00;
            case "C-": return 1.70;
            case "D+": return 1.30;
            case "D": return 1.00;
            case "E": return 0.00;
            default: return 0.00;
        }
    }

    public static void main(String[] args) {
         new UndergraduateGrades().setVisible(true);
    }
}