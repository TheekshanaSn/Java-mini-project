import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LectureProfile extends JFrame {
    private JTextField txtUserName;
    private JTextField txtFullName;
    private JTextField txtPhone;
    private JPasswordField txtPassword;
    private JButton btnSave;
    private JButton btnBack;
    private JComboBox comRole;
    private JPanel formLectureProfile;
    private JTextField txtUserId;
    private JLabel lblHi;
    private JTextField txtEmail;
    private JButton refeshButton;

    private String password;
    private String user_id;

    PreparedStatement pst;

    public LectureProfile(String user_id, String password) {
        this.user_id = user_id;
        this.password = password;

        setTitle("Lecturer Profile");
        setContentPane(formLectureProfile);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(600, 600);
        setLocationRelativeTo(null);
        setResizable(false);
        setVisible(true);

        loadLectureProfile();

        refeshButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new LectureProfile(user_id, password).setVisible(true);
            }
        });

        btnBack.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new LectureDashBord(user_id, password).setVisible(true);
            }
        });

        btnSave.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                Conn conn = new Conn();
                String email, fullname, phone, username, role, user_id;
                user_id = txtUserId.getText();
                email = txtEmail.getText();
                fullname = txtFullName.getText();
                phone = txtPhone.getText();
                username = txtUserName.getText();
                role = comRole.getSelectedItem().toString();



                try {
                    if (email.isEmpty() || fullname.isEmpty() || phone.isEmpty() || username.isEmpty()) {
                        JOptionPane.showMessageDialog(null, "Please fill in all fields.");
                        return;
                    }
                    pst = conn.c.prepareStatement("UPDATE  User SET email=?, Name=?, phone=?, username=?, role=? WHERE user_id=?");
                    pst.setString(1, email);
                    pst.setString(2, fullname);
                    pst.setString(3, phone);
                    pst.setString(4, username);
                    pst.setString(5, role);
                    pst.setString(6, user_id);

                    pst.executeUpdate();
                    JOptionPane.showMessageDialog(null, "Lecturer Profile Updated");
                } catch (SQLException ex) {
                    System.out.println(ex);
                }
            }
        });
    }

    public void loadLectureProfile() {
        try {
            Conn conn = new Conn();
            pst = conn.c.prepareStatement("SELECT * FROM User WHERE user_id = ?");
            pst.setString(1, user_id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                String userid = rs.getString("user_id");
                String email = rs.getString("email");
                String fullname = rs.getString("Name");
                String phone = rs.getString("phone");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String role = rs.getString("role").trim();

                lblHi.setText("Hi " + username);
                txtUserId.setText(userid);
                txtUserName.setText(username);
                txtFullName.setText(fullname);
                txtEmail.setText(email);
                txtPhone.setText(phone);
                txtPassword.setText(password);
                comRole.setSelectedItem(role);
                txtUserName.requestFocus();
            }
        } catch (Exception e) {
            System.out.println("Error fetching username: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        new LectureProfile("LEC001", "pass123");
    }
}
