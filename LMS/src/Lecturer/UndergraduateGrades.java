package Lecturer;

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
    private JButton REFRESHButton;
    private String user_id;
    private String password;


    private Map<String, Integer> courseCredits;

    UndergraduateGrades(String user_id, String password) {
        initializeCourseCredits();

        CAMARKN camarkn= new CAMARKN(user_id,password);
        camarkn.setVisible(false);
        camarkn.ENG2122codeca();
        camarkn.ICT2113codeca();
        camarkn.ICT2122codeca();
        camarkn.ICT2133codeca();
        camarkn.ICT2142codeca();
        camarkn.ICT2152codeca();

        FinalMark finalMark=new FinalMark(user_id,password);
        finalMark.setVisible(false);
        finalMark.ENG2122codefinal();
        finalMark.ICT2113codefinal();
        finalMark.ICT2133codefinal();
        finalMark.ICT2142codefinal();
        finalMark.ICT2152codefinal();
        finalMark.ICT2122codecafinal();

        this.user_id = user_id;
        this.password = password;
        setTitle("Undergraduate Grades");

        setContentPane(Grade);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(1000, 800);
        setLocationRelativeTo(null);
        setVisible(true);

        table_load();

        btnSearch.addActionListener(e -> searchStudent());
        btnExit.addActionListener(e -> System.exit(0));
        btnBack.addActionListener(e -> {
            setVisible(false);
            new ViewUndergraduate(user_id, password).setVisible(true);
        });
        REFRESHButton.addActionListener(e -> {
            setVisible(false);
            new UndergraduateGrades(user_id, password).setVisible(true);
        });
    }


    private void initializeCourseCredits() {
        courseCredits = new HashMap<>();
        courseCredits.put("ICT2113", 3);
        courseCredits.put("ICT2122", 2);
        courseCredits.put("ICT2133", 3);
        courseCredits.put("ICT2142", 2);
        courseCredits.put("ICT2152", 2);
        courseCredits.put("ENG2122", 2);
    }


    private int getCourseCredit(String courseCode) {
        return courseCredits.getOrDefault(courseCode, 0);
    }

    private void searchStudent() {
        String searchText = txtSearch.getText().trim();
        if (searchText.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter a student ID to search");
            return;
        }

        try {
            Conn conn = new Conn();

            PreparedStatement pstCourses = conn.c.prepareStatement(
                    "SELECT DISTINCT course_code FROM camarks ORDER BY course_code"
            );
            ResultSet rsCourses = pstCourses.executeQuery();

            List<String> courses = new ArrayList<>();
            while (rsCourses.next()) {
                courses.add(rsCourses.getString("course_code"));
            }

            DefaultTableModel model = new DefaultTableModel();
            model.addColumn("No");
            model.addColumn("Index Number");
            model.addColumn("Student Name");
            for (String course : courses) {
                model.addColumn(course);
            }
            model.addColumn("SGPA");
            model.addColumn("CGPA");

            PreparedStatement pstStudent = conn.c.prepareStatement(
                    "SELECT DISTINCT undergraduate_id FROM camarks WHERE undergraduate_id LIKE ? ORDER BY undergraduate_id"
            );
            pstStudent.setString(1, "%" + searchText + "%");
            ResultSet rsStudents = pstStudent.executeQuery();

            if (!rsStudents.isBeforeFirst()) {
                JOptionPane.showMessageDialog(this, "No student found with the given ID!");
                return;
            }

            int rowNum = 1;
            while (rsStudents.next()) {
                String studentId = rsStudents.getString("undergraduate_id");

                String studentName = getStudentName(conn, studentId);

                Vector<Object> row = new Vector<>();
                row.add(rowNum++);
                row.add(studentId);
                row.add(studentName);

                double totalWeightedPoints = 0;
                int totalCredits = 0;
                double cgpaWeightedPoints = 0;
                int cgpaTotalCredits = 0;

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
                        int credit = getCourseCredit(course);

                        if (caStatus != null && caStatus.equalsIgnoreCase("fail")) {
                            row.add("F");
                            totalCredits += credit;
                            if (!course.equalsIgnoreCase("ENG2122")) {
                                cgpaTotalCredits += credit;
                            }
                        } else {
                            double totalMarks = caMarks + finalMarks;
                            String letterGrade = getLetterGrade(totalMarks);

                            row.add(letterGrade);

                            double gradePoint = getGradePoint(letterGrade);
                            totalWeightedPoints += (gradePoint * credit);
                            totalCredits += credit;

                            if (!course.equalsIgnoreCase("ENG2122")) {
                                cgpaWeightedPoints += (gradePoint * credit);
                                cgpaTotalCredits += credit;
                            }
                        }
                    } else {
                        row.add("-");
                    }
                }

                double sgpa = (totalCredits > 0) ? totalWeightedPoints / totalCredits : 0.0;
                double cgpa = (cgpaTotalCredits > 0) ? cgpaWeightedPoints / cgpaTotalCredits : 0.0;

                row.add(String.format("%.2f", sgpa));
                row.add(String.format("%.2f", cgpa));

                model.addRow(row);
            }

            table1.setModel(model);
            table1.setRowHeight(25);
            table1.getTableHeader().setFont(new Font("SansSerif", Font.BOLD, 12));

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(this, "Error searching: " + e.getMessage());
        }
    }

    void table_load() {
        try {
            Conn conn = new Conn();

            PreparedStatement pstStudents = conn.c.prepareStatement(
                    "SELECT DISTINCT undergraduate_id FROM camarks ORDER BY undergraduate_id"
            );
            ResultSet rsStudents = pstStudents.executeQuery();

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

            DefaultTableModel model = new DefaultTableModel();
            model.addColumn("No");
            model.addColumn("Index Number");
            model.addColumn("Student Name");

            for (String course : courses) {
                model.addColumn(course);
            }

            model.addColumn("SGPA");
            model.addColumn("CGPA");

            int rowNum = 1;
            for (String studentId : students) {
                String studentName = getStudentName(conn, studentId);

                Vector<Object> row = new Vector<>();
                row.add(rowNum++);
                row.add(studentId);
                row.add(studentName);

                double totalWeightedPoints = 0;
                int totalCredits = 0;
                double cgpaWeightedPoints = 0;
                int cgpaTotalCredits = 0;

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
                        int credit = getCourseCredit(course);

                        if (caStatus != null && caStatus.equalsIgnoreCase("fail")) {
                            row.add("F");
                            totalCredits += credit;
                            if (!course.equalsIgnoreCase("ENG2122")) {
                                cgpaTotalCredits += credit;
                            }
                        } else {
                            double totalMarks = caMarks + finalMarks;
                            String letterGrade = getLetterGrade(totalMarks);

                            row.add(letterGrade);

                            double gradePoint = getGradePoint(letterGrade);
                            totalWeightedPoints += (gradePoint * credit);
                            totalCredits += credit;

                            if (!course.equalsIgnoreCase("ENG2122")) {
                                cgpaWeightedPoints += (gradePoint * credit);
                                cgpaTotalCredits += credit;
                            }
                        }
                    } else {
                        row.add("-");
                    }
                }

                double sgpa = (totalCredits > 0) ? totalWeightedPoints / totalCredits : 0.0;
                double cgpa = (cgpaTotalCredits > 0) ? cgpaWeightedPoints / cgpaTotalCredits : 0.0;

                row.add(String.format("%.2f", sgpa));
                row.add(String.format("%.2f", cgpa));

                model.addRow(row);
            }

            table1.setModel(model);
            table1.setRowHeight(25);
            table1.getTableHeader().setFont(new Font("SansSerif", Font.BOLD, 12));

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(this, "Error loading data: " + e.getMessage());
        }
    }

    private String getStudentName(Conn conn, String studentId) {
        try {
            PreparedStatement pst = conn.c.prepareStatement(
                    "SELECT Name FROM User WHERE user_id = ?"
            );
            pst.setString(1, studentId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return rs.getString("Name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Unknown";
    }

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
        else return "F";
    }

    private double getGradePoint(String letterGrade) {
        switch (letterGrade) {
            case "A+":
            case "A":
                return 4.00;
            case "A-":
                return 3.70;
            case "B+":
                return 3.30;
            case "B":
                return 3.00;
            case "B-":
                return 2.70;
            case "C+":
                return 2.30;
            case "C":
                return 2.00;
            case "C-":
                return 1.70;
            case "D+":
                return 1.30;
            case "D":
                return 1.00;
            default:
                return 0.00;
        }
    }

    public static void main(String[] args) {
        new UndergraduateGrades("", "").setVisible(true);
    }
}