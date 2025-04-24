package ADMIN;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class A_Dash_Board extends JFrame {
    // These should match EXACTLY the names in your form file
    private JButton signOutButton; // Note: Check if it's signOutButton or singOutButton in your form
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
        // Check if button exists before adding listener
        if (signOutButton != null) {
            signOutButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose(); // Close the current dashboard
                    // Open the login screen
                    SwingUtilities.invokeLater(() -> {
                        new LoginForm(); // Navigate to the Login class
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
                    dispose(); // Close the current dashboard
                    SwingUtilities.invokeLater(() -> {
                        new User_profile(); // Navigate to your existing User_profile class
                    });
                }
            });
        }

        if (courseButton != null) {
            courseButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose(); // Close the current dashboard
                    SwingUtilities.invokeLater(() -> {
                        new Course_unit(); // Navigate to your existing Course class
                    });
                }
            });
        }

        if (noticeButton != null) {
            noticeButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose(); // Close the current dashboard
                    SwingUtilities.invokeLater(() -> {
                        new Notice(); // Navigate to your existing Notice class
                    });
                }
            });
        }

        if (timetableButton != null) {
            timetableButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    dispose(); // Close the current dashboard
                    SwingUtilities.invokeLater(() -> {
                        new Timetable(); // Navigate to your existing Timetable class
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