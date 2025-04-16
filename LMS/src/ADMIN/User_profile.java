package ADMIN;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;


public class User_profile extends JFrame{
    private JButton undergraduateButton;
    private JButton lecturerButton;
    private JButton technicalOfficerButton;
    private JButton addNewButton;
    private JPanel JPanel1;
    private JPanel JPanel2;
    private JPanel JPanelMain;
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton singOutButton;
    private JTable table1;


    public User_profile() {
        setTitle("User");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);

        DefaultTableModel model = new DefaultTableModel(new Object[]{"ID", "Department"}, 0);
        table1.setModel(model);

        // Add some sample data
        model.addRow(new Object[]{"round", "red"});
        model.addRow(new Object[]{"square", "green"});

        setVisible(true); // Center the window
    }

    public static void main(String[] args) {

        User_profile user = new User_profile();
    }
}





