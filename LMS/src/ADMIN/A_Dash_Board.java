package ADMIN;

import MyCon.MyConnection;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class A_Dash_Board extends JFrame {
    private JButton signOutButton;
    private JButton userProfileButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JPanel Heder;
    private JPanel Midele;
    private JPanel Main;
    private JButton profileButton;
    private JLabel Profile;
    private JLabel UserManage;
    private JLabel Coursemanage;
    private JLabel Noticemanage;
    private JLabel Timetablemanage;
    private JLabel Admin_profile_name;


    public A_Dash_Board() {
        setTitle("ADMIN Dashboard");
        setSize(1080, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        initComponents(); // Initialize GUI
        setContentPane(Main);


        Profile.setIcon(new javax.swing.ImageIcon(getClass().getClassLoader().getResource("profile.png")));
        UserManage.setIcon(new javax.swing.ImageIcon(getClass().getClassLoader().getResource("user.png")));
        Coursemanage.setIcon(new javax.swing.ImageIcon(getClass().getClassLoader().getResource("course.png")));
        Noticemanage.setIcon(new javax.swing.ImageIcon(getClass().getClassLoader().getResource("notice.png")));
        Timetablemanage.setIcon(new javax.swing.ImageIcon(getClass().getClassLoader().getResource("timetable.png")));

        loadAdminName();

//        loadAdminName(Admin_profile_name);

        addActionListeners();
        setVisible(true);
    }

    // manually initialize i created components
    private void initComponents() {

    }

    private void loadAdminName() {
        try {
            Connection con = MyConnection.getConnection();
            String sql = "SELECT name FROM user WHERE role = 'admin' LIMIT 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String adminName = rs.getString("name");
                Admin_profile_name.setText("Hi "+adminName);
            } else {
                Admin_profile_name.setText("No Admin Found");
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            Admin_profile_name.setText("Error Loading Admin");
        }
    }

    private void addActionListeners() {

        if (signOutButton != null) {
            signOutButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose(); // close current display window
                    SwingUtilities.invokeLater(() -> {
                        new LoginForm();
                    });
                }
            });

        } else {
            System.err.println("signOutButton is null - check your form field name");
        }

        if (userProfileButton != null) {
            userProfileButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose();
                    SwingUtilities.invokeLater(() -> {
                        new User_profile();
                    });
                }
            });
        }

        if (courseButton != null) {
            courseButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose();
                    SwingUtilities.invokeLater(() -> {
                        new Course_unit();
                    });
                }
            });
        }

        if (noticeButton != null) {
            noticeButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose();
                    SwingUtilities.invokeLater(() -> {
                        new Notice();
                    });
                }
            });
        }

        if (timetableButton != null) {
            timetableButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose();
                    SwingUtilities.invokeLater(() -> {
                        new Timetable();
                    });
                }
            });
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new A_Dash_Board();
        });
    }
}