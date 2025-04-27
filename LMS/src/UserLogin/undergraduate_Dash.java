package UserLogin;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class undergraduate_Dash extends JFrame {
    private JPanel ugDashBoard;
    private JButton exitButton;
    private JButton profileButton;
    private JLabel welcomeLable;
    private JButton coursesButton;
    private JButton timeTableButton;
    private JButton noticesButton;
    private JButton medicalButton;
    private JButton attendenceButton;
    private JButton resultsButton;
    private JLabel prifilePic;
    private JLabel nameLabel;
    private JLabel profilePicLabel;

    private String userId;
    private String password;

    public undergraduate_Dash(String userId, String password) {
        this.userId = userId;
        this.password = password;

        setTitle("Undergraduate Dashboard");
        setContentPane(ugDashBoard);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);

        loadUserDetails();

        profileButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new undergraduateProfile(userId, password).setVisible(true);
            }
        });

        exitButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new LoginForm(null).setVisible(true);
            }
        });

        coursesButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new courseDetails(userId, password).setVisible(true);
            }
        });

        timeTableButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new undergraduateTimetable(userId, password).setVisible(true);
            }
        });

        noticesButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new undergraduateNotices(userId, password).setVisible(true);
            }
        });

        attendenceButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new undergraduateAttendence(userId, password).setVisible(true);
            }
        });

        medicalButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new undergraduateMedical(userId, password);
            }
        });

        resultsButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new undergraduateResults(userId, password);
            }
        });

        setVisible(true);
    }

    private void loadUserDetails() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");

            String sql = "SELECT u.username, ug.profile_picture FROM user u " +
                    "LEFT JOIN Undergraduate ug ON u.user_id = ug.undergraduate_id " +
                    "WHERE u.user_id = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, userId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String username = rs.getString("username");
                Blob profilePictureBlob = rs.getBlob("profile_picture"); // from Undergraduate table

                // Set the Welcome Label text
                if (username != null && !username.isEmpty()) {
                    welcomeLable.setText("Welcome, " + username);
                } else {
                    welcomeLable.setText("Welcome, User");
                }

                // Display profile picture if it exists
                if (profilePictureBlob != null) {
                    byte[] imageBytes = profilePictureBlob.getBytes(1, (int) profilePictureBlob.length());
                    ImageIcon icon = new ImageIcon(imageBytes);
                    Image img = icon.getImage().getScaledInstance(120, 120, Image.SCALE_SMOOTH);
                    prifilePic.setIcon(new ImageIcon(img));
                } else {
                    prifilePic.setText("No Image");
                }

            } else {
                welcomeLable.setText("User not found");
            }

            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
            welcomeLable.setText("Error loading user details");
        }
    }


    public static void main(String[] args) {
        new undergraduate_Dash("UG001", "pass123");
    }
}
