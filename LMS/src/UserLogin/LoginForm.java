package UserLogin;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class LoginForm extends JDialog {
    private JTextField textField1;
    private JPasswordField passwordField1;
    private JComboBox comboBox1;
    private JButton loginButton;
    private JButton cancelButton;
    private JPanel loginPanel;

    public LoginForm(JFrame parent) {

        super(parent);
        setTitle("Login");
        setContentPane(loginPanel);
        setMinimumSize(new Dimension(450, 474));
        setModal(true);
        setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(parent);

        //combobox
        comboBox1.addItem("Admin");
        comboBox1.addItem("Lecture");
        comboBox1.addItem("Technical Officer");
        comboBox1.addItem("Undergraduate");

        loginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String username = textField1.getText();
                String password = String.valueOf(passwordField1.getPassword());
                String role = (String) comboBox1.getSelectedItem();

                if (username.isEmpty() || password.isEmpty()) {
                    JOptionPane.showMessageDialog(LoginForm.this, "Please enter all fields.", "Error", JOptionPane.ERROR_MESSAGE);
                    return;
                }

                // Validate login
                if (validateLogin(username, password, role)) {
                    JOptionPane.showMessageDialog(LoginForm.this, "Login successful!");

                    dispose();
                    openDashboard(role); // open dashboard window based on role
                } else {
                    JOptionPane.showMessageDialog(LoginForm.this, "Invalid credentials.", "Error", JOptionPane.ERROR_MESSAGE);
                }

            }
        });
        cancelButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
            }
        });
    }

    private boolean validateLogin(String username, String password, String role) {
        boolean isValid = false;

        String DB_URL = "jdbc:mysql://localhost:3306/techlms";
        String USERNAME = "root";
        String PASSWORD = "";

        try {
            Connection conn =  DriverManager.getConnection(DB_URL, USERNAME, PASSWORD);
            String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND role = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                isValid = true;
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (SQLException e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(LoginForm.this, "Database Error", "Error", JOptionPane.ERROR_MESSAGE);
        }

        return isValid;
    }

    private void openDashboard(String role) {
        JFrame dashboard;

        switch (role) {
            case "Admin":
                dashboard = new JFrame("Admin Dashboard");
                break;
            case "Lecture":
                dashboard = new JFrame("Lecture Dashboard");
                break;
            case "Technical Officer":
                dashboard = new JFrame("Technical Officer Dashboard");
                break;
            case "Undergraduate":
                dashboard = new JFrame("Undergraduate Dashboard");
                break;
           default:
             return;
        }

        dashboard.setSize(500, 400);
        dashboard.setLocationRelativeTo(null);
        dashboard.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        dashboard.setVisible(true);
    }


    public static void main(String[] args) {
        LoginForm loginForm = new LoginForm(null); // passing null as no parent frame
        loginForm.setVisible(true);
    }
}
