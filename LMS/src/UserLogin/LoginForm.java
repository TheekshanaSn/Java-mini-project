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
                String userId = textField1.getText();
                String password = String.valueOf(passwordField1.getPassword());
                String role = (String) comboBox1.getSelectedItem();

                if (userId.isEmpty() || password.isEmpty()) {
                    JOptionPane.showMessageDialog(LoginForm.this, "Please enter all fields.", "Error", JOptionPane.ERROR_MESSAGE);
                    return;
                }

                // Validate login
                if (validateLogin(userId, password, role)) {
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

    private boolean validateLogin(String userId, String password, String role) {
        boolean isValid = false;

        String DB_URL = "jdbc:mysql://localhost:3306/techlms";
        String USERNAME = "root";
        String PASSWORD = "";

        try {
            Connection conn =  DriverManager.getConnection(DB_URL, USERNAME, PASSWORD);
            String sql = "SELECT * FROM user WHERE user_id = ? AND password = ? AND role = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, userId);
            ps.setString(2, password);
            ps.setString(3, role);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                isValid = true;

                Session.userId = rs.getString("user_id");
                Session.role = rs.getString("role");
                Session.name = rs.getString("Name");
                Session.username = rs.getString("Name");
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
                new undergraduate_Dash();
                break;
           default:
             return;
        }

//        dashboard.setSize(500, 400);
//        dashboard.setLocationRelativeTo(null);
//        dashboard.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
//        dashboard.setVisible(true);
    }


    public static void main(String[] args) {
        LoginForm loginForm = new LoginForm(null); // passing null as no parent frame
        loginForm.setVisible(true);
    }
}
