import javax.swing.*;

public class LectureDashBord extends JFrame {
    private JButton btnLogin;
    private JButton btnExit;
    private JButton btnProfile;
    private JButton btnCourseMaterial;
    private JButton btnUploadMark;
    private JButton btnViewUndergraduate;
    private JButton btnNotices;
    private JLabel labHi;

    private JPanel main;

    LectureDashBord(String username,String password) {



        setTitle("Lecturer Dashboard");
        setContentPane(main);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(800, 500);
        setResizable(false);
        setVisible(true);

       labHi.setText(" HI "+username);


    }


    public static void main(String[] args) {
       new LectureDashBord("harshad","pass123");
    }
}
