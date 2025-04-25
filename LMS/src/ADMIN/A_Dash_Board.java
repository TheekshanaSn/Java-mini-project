package ADMIN;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class A_Dash_Board extends JFrame {
    private JButton signOutButton;
    private JButton userProfileButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JPanel Botom;
    private JPanel Heder;
    private JPanel Midele;
    private JPanel Main;
    private JButton profileEditButton;

    public A_Dash_Board() {
        // Set up the main frame properties
        setTitle("ADMIN Dashboard");
        setSize(900, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        initComponents();
        setContentPane(Main);

        addActionListeners();
        setVisible(true);
    }

    // Add this method to manually initialize components if needed
    private void initComponents() {

    }

    private void addActionListeners() {

        if (signOutButton != null) {
            signOutButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose();
                    SwingUtilities.invokeLater(() -> {
                        new LoginForm();  //call the loginform interface
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
                    dispose(); // Close the current interface
                    SwingUtilities.invokeLater(() -> {
                        User_profile userProfile = new User_profile();
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
                    dispose(); // Close the current display interface
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