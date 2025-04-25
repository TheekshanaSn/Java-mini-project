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
    private JPanel Heder;
    private JPanel Midele;
    private JPanel Main;
    private JButton profileButton;
    private JLabel Profile;

    // main constructor create and display dashboardpanel set values
    public A_Dash_Board() {
        setTitle("ADMIN Dashboard");
        setSize(1080, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        initComponents(); // Initialize GUI
        setContentPane(Main);

        addActionListeners(); //add event listeners to buttons
        setVisible(true);
    }

    // manually initialize i created components
    private void initComponents() {

    }

    // Set up all button actions here
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
            new A_Dash_Board(); // call the  main constructor
        });
    }
}