package Admin;

import javax.swing.*;


public class User_profile extends JFrame{
    private JButton undergraduateButton;
    private JButton lecturerButton;
    private JButton technicalOfficerButton;
    private JTable table1;
    private JButton addNewButton;
    private JPanel JPanel1;
    private JPanel JPanel2;
    private JPanel JPanelMain;
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton singOutButton;


    public User_profile() {
        setTitle("User");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);
        setVisible(true); // Center the window
    }

    public static void main(String[] args) {
        User_profile user = new User_profile();
    }
}





