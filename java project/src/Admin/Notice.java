package Admin;

import javax.swing.*;

public class Notice extends JFrame {
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton singOutButton;
    private JButton updateButton;
    private JButton deleteButton;
    private JButton updateButton1;
    private JButton deleteButton1;
    private JButton updateButton2;
    private JButton deleteButton2;
    private JButton addNewButton;
    private JPanel JPanelMain;
    private JPanel JPanel1;
    private JPanel JPanel2;


    public Notice() {
        setTitle("Notice");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);
        setVisible(true); // Center the window
    }

    public static void main(String[] args) {
       Notice n= new Notice();
    }
}
