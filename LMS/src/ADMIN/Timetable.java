package ADMIN;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.table.DefaultTableModel;

public class Timetable extends JFrame{
    private JComboBox comboBox1;
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


    public Timetable() {
        setTitle("Timetable");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);


        DefaultTableModel model = new DefaultTableModel(new Object[]{"Mon", "Tue","Wed","Thu","Fri"}, 0);
        table1.setModel(model);

        // Add some sample data
        model.addRow(new Object[]{"CS101", "CS102", "CS103", "CS104", "CS105"});
        model.addRow(new Object[]{"ET201", "ET202", "ET203", "ET204", "ET205"});


        comboBox1.removeAllItems();
        String[] Dep = {"ICT", "ET", "BST"};
        for (String type : Dep) {
            comboBox1.addItem(type);  // Fixed: Add the current item, not the whole array
        }

        setLocationRelativeTo(null);  // Center the window
        setVisible(true);
    }


    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new Timetable();
        });
    }
}