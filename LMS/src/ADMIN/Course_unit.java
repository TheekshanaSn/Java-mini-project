package ADMIN;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;


public class Course_unit extends JFrame {
    private JPanel rootPanel; // This will be automatically linked with the form's root panel
    private JTextField textField1;
    private JTextField textField2;
    private JTextField textField5;
    private JButton addNewCourseButton;
    private JButton updateButton;
    private JButton deleteButton;
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton signOutButton;
    private JTable table1;
    private JComboBox comboBox1;
    private JComboBox comboBox2;
    private JPanel JPanel1;
    private JPanel JPanel2;

    // Constructor
    public Course_unit() {
        setTitle("Course Unit");
        setContentPane(rootPanel); // rootPanel should already be initialized by IntelliJ's GUI designer
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);
        setVisible(true); // Center the window
    }


    private void createUIComponents() {
        // Example: Initialize a custom table model for table1
        table1 = new JTable(new DefaultTableModel(new Object[]{"Course_id", "Course_name", "Type","credit"}, 0));

        // Example: Initialize a custom ComboBox (if comboBox1 is a custom JComboBox in the form)
        comboBox1 = new JComboBox(new String[]{"TP", "T", "P"});
        comboBox2 = new JComboBox(new String[]{"1", "2", "3"});

        // Example: If you have custom panels like JPanel1 and JPanel2
        JPanel1 = new JPanel();
        JPanel2 = new JPanel();
    }

    public static void main(String[] args) {
        Course_unit courseUnit = new Course_unit();

    }
}
