package ADMIN;

import javax.swing.*;
import java.awt.*;
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

    public A_Dash_Board() {
        // Set up the main frame properties
        setTitle("ADMIN Dashboard");
        setSize(600, 400);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Initialize components if they're not being auto-created by the form
        initComponents();

        // Set the main content pane
        setContentPane(Main);

        // Add action listeners to the buttons
        addActionListeners();

        // Display the frame
        setVisible(true);
    }

    // Add this method to manually initialize components if needed
    private void initComponents() {
        // Only uncomment these if your form is not properly initializing the components
        // Otherwise, leave this method empty or remove it

        /*
        if (Main == null) Main = new JPanel(new BorderLayout());

        if (signOutButton == null) {
            signOutButton = new JButton("Sign Out");
            signOutButton.setBackground(Color.RED);
            signOutButton.setForeground(Color.WHITE);
        }

        if (userProfileButton == null) {
            userProfileButton = new JButton("User Profile");
            userProfileButton.setBackground(new Color(128, 0, 128));
            userProfileButton.setForeground(Color.WHITE);
        }

        if (courseButton == null) {
            courseButton = new JButton("Course");
            courseButton.setBackground(new Color(128, 0, 128));
            courseButton.setForeground(Color.WHITE);
        }

        if (noticeButton == null) {
            noticeButton = new JButton("Notice");
            noticeButton.setBackground(new Color(128, 0, 128));
            noticeButton.setForeground(Color.WHITE);
        }

        if (timetableButton == null) {
            timetableButton = new JButton("Timetable");
            timetableButton.setBackground(new Color(128, 0, 128));
            timetableButton.setForeground(Color.WHITE);
        }
        */
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
                        new Login(); // Navigate to the Login class
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