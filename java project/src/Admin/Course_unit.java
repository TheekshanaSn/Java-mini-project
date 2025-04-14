package Admin;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;

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
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(900, 600);
        setLocationRelativeTo(null); // Center the window
    }

    // The method IntelliJ expects for creating custom components
    private void createUIComponents() {
        // Initialize any custom components you have in the form

        // Example: Initialize a custom table model for table1
        table1 = new JTable(new DefaultTableModel(new Object[]{"Course_id", "Course_name", "Type","credit"}, 0));

        // Example: Initialize a custom ComboBox (if comboBox1 is a custom JComboBox in the form)
        comboBox1 = new JComboBox(new String[]{"TP", "T", "P"});
        comboBox2 = new JComboBox(new String[]{"1", "2", "3"});

        // Example: If you have custom panels like JPanel1 and JPanel2
        JPanel1 = new JPanel();
        JPanel2 = new JPanel();

        // Initialize any other custom components like buttons or text fields
        addNewCourseButton = new JButton("Add New Course");
        updateButton = new JButton("Update");
        deleteButton = new JButton("Delete");
        userButton = new JButton("User");
        courseButton = new JButton("Course");
        noticeButton = new JButton("Notice");
        timetableButton = new JButton("Timetable");
        signOutButton = new JButton("Sign Out");
    }

    // Auto-generated method to wire up UI components
//    private void $$$setupUI$$$() {
//        // This is an auto-generated method by IntelliJ IDEA's GUI Designer.
//        // It will be called to initialize all the components from the form.
//    }

    public static void main(String[] args) {
        // Run the UI setup in the event dispatch thread
        SwingUtilities.invokeLater(() -> {
            Course_unit courseUnit = new Course_unit();
            courseUnit.setVisible(true); // Show the GUI
        });
    }
}
