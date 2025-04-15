package ADMIN;

import javax.swing.*;

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


    public Timetable() {
        setTitle("Timetable");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);
        setVisible(true); // Center the window
    }

    public static void main(String[] args) {
        Timetable t= new Timetable();
    }
}
