package UserLogin;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.io.File;
import java.io.FileInputStream;
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
    private JLabel propic;
    private JButton changePictureButton;

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

        clearButton.addActionListener(e -> {
            setVisible(false);
            new undergraduateProfile(userId, password).setVisible(true);
        });

        saveButton.addActionListener(e -> saveProfile());

        backButton.addActionListener(e -> {
            dispose();
            new undergraduate_Dash(userId, password);
        });

        changePictureButton.addActionListener(e -> uploadProfilePicture());
    }

    private void loadUndergraduateProfile() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            pst = conn.prepareStatement("SELECT u.*, ug.profile_picture FROM user u INNER JOIN undergraduate ug ON u.user_id = ug.undergraduate_id WHERE u.user_id = ?");
            pst.setString(1, userId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String userid = rs.getString("user_id");
                String emailStr = rs.getString("email");
                String fullname = rs.getString("Name");
                String phoneStr = rs.getString("phone");
                String username = rs.getString("username");
                String passwordStr = rs.getString("password");

                lbUgname.setText("Hi " + username);
                uId.setText(userid);
                uName.setText(username);
                fName.setText(fullname);
                email.setText(emailStr);
                phone.setText(phoneStr);
                passwordField1.setText(passwordStr);

                // Set profile picture
                byte[] imgBytes = rs.getBytes("profile_picture");
                if (imgBytes != null) {
                    ImageIcon imageIcon = new ImageIcon(imgBytes);
                    Image img = imageIcon.getImage().getScaledInstance(120, 120, Image.SCALE_SMOOTH);
                    propic.setIcon(new ImageIcon(img));
                } else {
                    propic.setText("No Image");
                }
            }
            rs.close();
            pst.close();
            conn.close();
        } catch (Exception e) {
            System.out.println("Error loading undergraduate profile: " + e.getMessage());
        }
    }

    private void saveProfile() {
        String enteredUserId = uId.getText();
        String Email = email.getText();
        String fullname = fName.getText();
        String Phone = phone.getText();
        String username = uName.getText();
        String newPassword = new String(passwordField1.getPassword());

        if (Email.isEmpty() || fullname.isEmpty() || Phone.isEmpty() || username.isEmpty() || newPassword.isEmpty()) {
            JOptionPane.showMessageDialog(null, "Please fill in all fields.");
            return;
        }

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            String query = "UPDATE user SET email = ?, Name = ?, phone = ?, username = ?, password = ? WHERE user_id = ?";
            pst = conn.prepareStatement(query);
            pst.setString(1, Email);
            pst.setString(2, fullname);
            pst.setString(3, Phone);
            pst.setString(4, username);
            pst.setString(5, newPassword); // ✅ update password
            pst.setString(6, enteredUserId);

            pst.executeUpdate();
            JOptionPane.showMessageDialog(null, "Profile Updated Successfully!");
            conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error: " + ex.getMessage());
        }
    }

    private void uploadProfilePicture() {
        try {
            JFileChooser fileChooser = new JFileChooser();
            int result = fileChooser.showOpenDialog(null);

            if (result == JFileChooser.APPROVE_OPTION) {
                File selectedFile = fileChooser.getSelectedFile();

                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
                String sql = "UPDATE undergraduate SET profile_picture = ? WHERE undergraduate_id = ?";
                pst = conn.prepareStatement(sql);

                FileInputStream fis = new FileInputStream(selectedFile);
                pst.setBinaryStream(1, fis, (int) selectedFile.length());
                pst.setString(2, userId);

                pst.executeUpdate();
                conn.close();

                // Set the selected image into the propic label
                ImageIcon imageIcon = new ImageIcon(selectedFile.getAbsolutePath());
                Image img = imageIcon.getImage().getScaledInstance(120, 120, Image.SCALE_SMOOTH);
                propic.setIcon(new ImageIcon(img));

                JOptionPane.showMessageDialog(null, "Profile picture updated successfully!");
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error updating profile picture: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        new undergraduateProfile("UG001", "pass123");
    }
}
