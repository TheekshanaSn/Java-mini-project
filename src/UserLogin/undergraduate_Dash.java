package UserLogin;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.nio.file.Files;
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


        JFrame frame = new JFrame("Undergraduate Dashboard");
        frame.setContentPane(ugDashBoard);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(800, 600);
        frame.setLocationRelativeTo(null);

        loadUserDetails();

        profileButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new undergraduateProfile(userId, password);
            }
        });

        exitButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                new LoginForm(null).setVisible(true);
            }
        });

        coursesButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new courseDetails(userId, password);
            }
        });


        //coursesButton.addActionListener(e -> JOptionPane.showMessageDialog(null, "Courses feature coming soon..."));
        timeTableButton.addActionListener(e -> JOptionPane.showMessageDialog(null, "Timetable feature coming soon..."));
        noticesButton.addActionListener(e -> JOptionPane.showMessageDialog(null, "Notices feature coming soon..."));
        medicalButton.addActionListener(e -> JOptionPane.showMessageDialog(null, "Medical records feature coming soon..."));
        attendenceButton.addActionListener(e -> JOptionPane.showMessageDialog(null, "Attendance feature coming soon..."));
        resultsButton.addActionListener(e -> JOptionPane.showMessageDialog(null, "Results feature coming soon..."));

        frame.setVisible(true);
    }

    private void loadUserDetails() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            String sql = "SELECT Name, profile_picture FROM user WHERE user_id = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, Session.userId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // Correctly retrieve the name from the database
                String name = rs.getString("Name"); // Assuming "Name" is the correct column name
                Session.name = name; // Store in session for use in other forms

                // Set the welcome label with the correct name
                welcomeLable.setText("Welcome, " + Session.name + " (" + Session.userId + ")");

                String imagePath = rs.getString("profile_picture");
                if (imagePath != null && !imagePath.isEmpty()) {
                    ImageIcon icon = new ImageIcon(imagePath);
                    Image img = icon.getImage().getScaledInstance(120, 120, Image.SCALE_SMOOTH);
                    profilePicLabel.setIcon(new ImageIcon(img));
                } else {
                    profilePicLabel.setText("No Image");
                }
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            welcomeLable.setText("Error loading user");
        }
    }

    public static void main(String[] args) {
       // Session.userId = "UG001";
        new undergraduate_Dash("UG001", "pass123");
    }
}

