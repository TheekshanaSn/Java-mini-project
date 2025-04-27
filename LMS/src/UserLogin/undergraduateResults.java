package UserLogin;

import net.proteanit.sql.DbUtils;
import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class undergraduateResults extends JFrame {
    private JTable table1;
    private JButton backButton;
    private JPanel ugResults;

    private String userId;
    private String password;
    private PreparedStatement pst;

    public undergraduateResults(String userId, String password) {
        this.userId = userId;
        this.password = password;

        setTitle("Undergraduate Results");
        setContentPane(ugResults);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(900, 600);
        setLocationRelativeTo(null);

        loadResults();

        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new undergraduate_Dash(userId, password);
            }
        });

        setVisible(true);
    }

    private void loadResults() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");

            String query = "SELECT c.course_code, c.camarks, f.finalmarks, c.status " +
                    "FROM camarks c " +
                    "LEFT JOIN finalmarks f ON c.undergraduate_id = f.undergraduate_id AND c.course_code = f.course_code " +
                    "WHERE c.undergraduate_id = ? " +
                    "ORDER BY c.course_code ASC";
            pst = conn.prepareStatement(query);
            pst.setString(1, userId);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel();
            model.addColumn("Course Code");
            model.addColumn("CA Marks");
            model.addColumn("Final Marks");
            model.addColumn("Total Marks");
            model.addColumn("Grade");

            double totalGradePoints = 0;
            int courseCount = 0;
            double cgpaGradePoints = 0;
            int cgpaCourseCount = 0;
            boolean hasResults = false;

            while (rs.next()) {
                hasResults = true;

                String courseCode = rs.getString("course_code");
                double caMarks = rs.getDouble("camarks");
                double finalMarks = rs.getDouble("finalmarks");
                String status = rs.getString("status");

                double totalMarks = caMarks + finalMarks;
                String letterGrade;

                if (status != null && status.equalsIgnoreCase("fail")) {
                    letterGrade = "F";
                } else {
                    letterGrade = getLetterGrade(totalMarks);
                }

                model.addRow(new Object[]{
                        courseCode,
                        caMarks,
                        finalMarks,
                        totalMarks,
                        letterGrade
                });

                if (!letterGrade.equals("F")) {
                    double gradePoint = getGradePoint(letterGrade);
                    totalGradePoints += gradePoint;
                    courseCount++;

                    // CGPA calculation (skip ENG2122 from CGPA)
                    if (!courseCode.equalsIgnoreCase("ENG2122")) {
                        cgpaGradePoints += gradePoint;
                        cgpaCourseCount++;
                    }
                }
            }

            if (!hasResults) {
                JOptionPane.showMessageDialog(this, "No results available yet for you!", "No Data", JOptionPane.INFORMATION_MESSAGE);
                return;
            }

            double sgpa = (courseCount > 0) ? totalGradePoints / courseCount : 0.0;
            double cgpa = (cgpaCourseCount > 0) ? cgpaGradePoints / cgpaCourseCount : 0.0;

            // Add SGPA Row
            model.addRow(new Object[]{
                    "SGPA", "", "", "", String.format("%.2f", sgpa)
            });

            // Add CGPA Row
            model.addRow(new Object[]{
                    "CGPA", "", "", "", String.format("%.2f", cgpa)
            });

            table1.setModel(model);
            table1.setRowHeight(25);
            table1.getTableHeader().setFont(new Font("SansSerif", Font.BOLD, 14));

            // Bold SGPA and CGPA rows
            DefaultTableCellRenderer cellRenderer = new DefaultTableCellRenderer() {
                @Override
                public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected,
                                                               boolean hasFocus, int row, int column) {
                    Component c = super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
                    int lastRow = table.getRowCount() - 1;
                    int secondLastRow = table.getRowCount() - 2;

                    if (row == lastRow || row == secondLastRow) { // SGPA and CGPA rows
                        c.setFont(c.getFont().deriveFont(Font.BOLD));
                        c.setBackground(new Color(220, 240, 220)); // Light green
                    } else {
                        c.setFont(c.getFont().deriveFont(Font.PLAIN));
                        c.setBackground(Color.WHITE);
                    }
                    return c;
                }
            };

            for (int i = 0; i < table1.getColumnCount(); i++) {
                table1.getColumnModel().getColumn(i).setCellRenderer(cellRenderer);
            }

            rs.close();
            pst.close();
            conn.close();

        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Database Connection Error! Please check server.\nError: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
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
            case "A+": case "A": return 4.00;
            case "A-": return 3.70;
            case "B+": return 3.30;
            case "B": return 3.00;
            case "B-": return 2.70;
            case "C+": return 2.30;
            case "C": return 2.00;
            case "C-": return 1.70;
            case "D+": return 1.30;
            case "D": return 1.00;
            default: return 0.00;
        }
    }

    public static void main(String[] args) {
        new undergraduateResults("UG001", "pass123");
    }
}
