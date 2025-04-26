package UserLogin;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class undergraduateMedical extends JFrame {
    private JTable table1;
    private JButton backButton;
    private JPanel ugMedical;
    private JPanel messagaePanel;
    private JLabel message;

    private String userId;
    private String password;
    private PreparedStatement pst;

    public undergraduateMedical(String userId, String password) {
        this.userId = userId;
        this.password = password;

        setTitle("Undergraduate Medical Submissions");
        setContentPane(ugMedical);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);

        loadMedicalData();

        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new undergraduate_Dash(userId, password);
            }
        });

        setVisible(true);
    }

    private void loadMedicalData() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            String query = "SELECT * FROM Medical WHERE med_undergraduate_id = ?";
            pst = conn.prepareStatement(query);
            pst.setString(1, userId);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel();
            table1.setModel(model);

            String[] columnNames = {"Medical ID", "Course Code", "Date", "Reason"};
            model.setColumnIdentifiers(columnNames);

            boolean hasRecords = false;

            while (rs.next()) {
                hasRecords = true;
                Object[] row = {
                        rs.getString("medical_id"),
                        rs.getString("med_course_code"),
                        rs.getString("date"),
                        rs.getString("reason")
                };
                model.addRow(row);
            }

            if (!hasRecords) {
                message.setText("You have not submitted any medical documents.");
            } else {
                message.setText("");
            }

            rs.close();
            pst.close();
            conn.close();

        } catch (Exception e) {
            message.setText("Error loading medical data: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        new undergraduateMedical("UG003", "pass123");
    }
}
