package UserLogin;

import net.proteanit.sql.DbUtils;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;



public class courseDetails extends JFrame {

    private String userId;
    private String password;

    private JTable table1;
    private JPanel coursePanel;
    private JButton backButton;
    private PreparedStatement pst;

    public courseDetails(String userId, String password) {

        this.userId = userId;
        this.password = password;

        setTitle("Undergraduate Course Details");
        setContentPane(coursePanel);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);
        setVisible(true);

        table_load();
        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                setVisible(false);
                new undergraduate_Dash(userId, password);
            }
        });
    }



    private void table_load() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            pst = conn.prepareStatement(
                    "SELECT * from course_unit ");
            ResultSet rs = pst.executeQuery();
            table1.setModel(DbUtils.resultSetToTableModel(rs));
        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Failed to load course details");
        }
    }

    public static void main(String[] args) {
        new courseDetails("UG001", "pass123");
    }
}
