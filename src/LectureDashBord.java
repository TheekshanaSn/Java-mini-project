import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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

    private String username;
    private String password;
    private String user_id;
    PreparedStatement pst;

    LectureDashBord(String user_id, String password) {
        this.user_id = user_id;
        this.password = password;

        setTitle("Lecturer Dashboard");
        setContentPane(main);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(800, 500);
        setResizable(false);

        getUsername(user_id);
        labHi.setText(" HI " + username);

        btnProfile.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new LectureProfile( user_id,password).setVisible(true);
            }
        });

        setVisible(true);
    }

    public void getUsername(String user_id) {
        try {
            Conn conn = new Conn();
            pst = conn.c.prepareStatement("SELECT username FROM User WHERE user_id = ?");
            pst.setString(1, user_id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                username = rs.getString("username");
                System.out.println("Username fetched: " + username);
            }
        } catch (Exception e) {
            System.out.println("Error fetching username: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        new LectureDashBord("LEC001", "pass123");
    }
}
