package ADMIN;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.table.DefaultTableModel;

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
//        setLocationRelativeTo(null); // Center the window
//        setVisible(true);

            // Update table model after form initialization
            DefaultTableModel model = new DefaultTableModel(new Object[]{"Course ID", "Course name","Course type","credit","C_lecture ID"}, 0);
            table1.setModel(model);

            // Add some sample data
            model.addRow(new Object[]{"round", "red"});
            model.addRow(new Object[]{"square", "green"});


        comboBox1.removeAllItems();
        String[] types = {"TP", "T", "P"};
        for (String type : types) {
            comboBox1.addItem(type);
        }

        // Update the existing comboBox2 with values
        comboBox2.removeAllItems();
        String[] credits = {"1", "2", "3"};
        for (String credit : credits) {
            comboBox2.addItem(credit);
        }

        setLocationRelativeTo(null);
        setVisible(true);

    }

    private void createUIComponents() {

        // Initialize panels
        JPanel1 = new JPanel();
        JPanel2 = new JPanel();
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new Course_unit();
        });
    }
}