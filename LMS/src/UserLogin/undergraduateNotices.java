package UserLogin;

import net.proteanit.sql.DbUtils;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class undergraduateNotices extends JFrame {
    private JTable table1;
    private JButton backButton;
    private JPanel ugNotices;

    private String userId;
    private String password;
    private PreparedStatement pst;

    public undergraduateNotices(String userId, String password) {
        this.userId = userId;
        this.password = password;

        setTitle("Undergraduate Notices");
        setContentPane(ugNotices);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);

        table_load();

        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new undergraduate_Dash(userId, password);
            }
        });

        setVisible(true);
    }

    private void table_load() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            pst = conn.prepareStatement("SELECT * FROM notice");
            ResultSet rs = pst.executeQuery();
            table1.setModel(DbUtils.resultSetToTableModel(rs));
        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Failed to load notices");
        }
    }

    public static void main(String[] args) {
        new undergraduateNotices("UG001", "pass123");
    }
}
