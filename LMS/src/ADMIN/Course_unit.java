package ADMIN;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;
import java.awt.event.*;



public class Course_unit extends JFrame {
    private JPanel rootPanel; // This will be automatically linked with the form's root panel
    private JTextField textField1; // course_code field
    private JTextField textField2; // name field
    private JTextField textField5; // c_lecturer_id field
    private JButton addNewCourseButton;
    private JButton updateButton;
    private JButton deleteButton;
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton signOutButton;
    private JTable table1;
    private JComboBox comboBox1; // type combobox
    private JComboBox comboBox2; // credit combobox
    private JPanel JPanel1;
    private JPanel JPanel2;
    private JScrollPane JScrollPane;

    // Constructor
    public Course_unit() {
        setTitle("Course Unit");
        setContentPane(rootPanel);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);

        setupComboBoxes();
        setupTable();

        loadCourseData();


        setLocationRelativeTo(null);
        setVisible(true);
    }


    private void setupComboBoxes() {
        // Set up course type combobox
        comboBox1.removeAllItems();
        String[] types = {"TP", "T", "P"};
        for (String type : types) {
            comboBox1.addItem(type);
        }

        // Set up credits combobox
        comboBox2.removeAllItems();
        String[] credits = {"1", "2", "3"};
        for (String credit : credits) {
            comboBox2.addItem(credit);
        }
    }

    private void setupTable() {
        DefaultTableModel model = new DefaultTableModel(
                new Object[]{"Course ID", "Course Name", "Course Type", "Credit", "Lecturer ID"}, 0);
        table1.setModel(model);
    }

    private Object loadCourseData() {
        DefaultTableModel model = (DefaultTableModel) table1.getModel();
        model.setRowCount(0); // Clear existing data


        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM course_unit");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                model.addRow(new Object[]{
                        rs.getString("course_code"),
                        rs.getString("name"),
                        rs.getString("type"),
                        rs.getString("credit"),
                        rs.getString("c_lecturer_id")
                });
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading course data: " + ex.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }

        return null;
    }


    private void createUIComponents() {
        // Initialize panels
        JPanel1 = new JPanel();
        JPanel2 = new JPanel();
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {new Course_unit();});

//        DatabaseConnect db = new DatabaseConnect();
    }

}