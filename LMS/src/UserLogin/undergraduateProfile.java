package UserLogin;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class undergraduateProfile extends JFrame {
    private JTextField uId;
    private JTextField uName;
    private JTextField fName;
    private JTextField email;
    private JTextField phone;
    private JPasswordField passwordField1;
    private JButton clearButton;
    private JButton saveButton;
    private JButton backButton;
    private JPanel ugProfile;
    private JLabel lbUgname;

    private String userId;
    private String password;
    PreparedStatement pst;

    undergraduateProfile(String userId, String password) {
        this.userId = userId;
        this.password = password;

        setTitle("Undergraduate Profile");
        setContentPane(ugProfile);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(600, 600);
        setLocationRelativeTo(null);
        setResizable(false);
        setVisible(true);

        loadUndergraduateProfile();

        clearButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new undergraduateProfile(userId, password).setVisible(true);
            }
        });

        saveButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                String enteredUserId = uId.getText();
                String Email = email.getText();
                String fullname = fName.getText();
                String Phone = phone.getText();
                String username = uName.getText();

                if (Email.isEmpty() || fullname.isEmpty() || Phone.isEmpty() || username.isEmpty()) {
                    JOptionPane.showMessageDialog(null, "Please fill in all fields.");
                    return;
                }

                try {
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
                    String query = "UPDATE user SET email = ?, Name = ?, phone = ?, username = ? WHERE user_id = ?";
                    pst = conn.prepareStatement(query);
                    pst.setString(1, Email);
                    pst.setString(2, fullname);
                    pst.setString(3, Phone);
                    pst.setString(4, username);
                    pst.setString(5, enteredUserId);

                    pst.executeUpdate();
                    JOptionPane.showMessageDialog(null, "Profile Updated Successfully!");

                } catch (SQLException ex) {
                    ex.printStackTrace();
                    JOptionPane.showMessageDialog(null, "Error: " + ex.getMessage());
                }
            }
        });

        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                setVisible(false);
                new undergraduate_Dash(userId, password);
            }
        });
    }

    private void loadUndergraduateProfile() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            pst = conn.prepareStatement("SELECT * FROM user WHERE user_id = ?");
            pst.setString(1, userId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String userid = rs.getString("user_id");
                String emailStr = rs.getString("email");
                String fullname = rs.getString("Name");
                String phoneStr = rs.getString("phone");
                String username = rs.getString("username");

                lbUgname.setText("Hi " + username);
                uId.setText(userid);
                uName.setText(username);
                fName.setText(fullname);
                email.setText(emailStr);
                phone.setText(phoneStr);
            }
        } catch (Exception e) {
            System.out.println("Error loading undergraduate profile: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        new undergraduateProfile("UG001", "pass123");
    }
}
