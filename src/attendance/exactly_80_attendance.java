package attendance;

import ADMIN.MyCon.MyConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class exactly_80_attendance{
    private JPanel panel1;
    private JButton previewButton;
    private JTable showTable;
    //private JScrollPane showTable;


    JFrame frame;

    public exactly_80_attendance() {
        frame = new JFrame();
        frame.setTitle("TO Profile");
        frame.setContentPane(panel1);
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        frame.setSize(1080, 600);
        frame.setVisible(true);


        DefaultTableModel model = new DefaultTableModel();
        showTable.setModel(model);


        try {
            Connection conn = MyConnection.getConnection();
            String Query = "SELECT at_undergraduate_id,at_course_code,(COUNT( attendance_id))/15*100 AS 'Attendance percentage'\n" +
                    "FROM Attendance \n" +
                    "WHERE attendance = 'Present'\n" +
                    "GROUP BY at_undergraduate_id,at_course_code\n" +
                    "HAVING ((COUNT( attendance_id))*100/15)=80 ORDER BY at_undergraduate_id;";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(Query);


            model.setRowCount(0); // clear previous data

            String[] columnNames = {
                    "at_undergraduate_id", "at_course_code", "Attendance percentage"
            };
            model.setColumnIdentifiers(columnNames);

            while (rs.next()) {
                Object[] rowData = {
                        rs.getString("at_undergraduate_id"),
                        rs.getString("at_course_code"),
                        rs.getString("Attendance percentage"),
                };
                model.addRow(rowData);
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(frame, "Database error: " + e.getMessage());
        }
        previewButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                new Attendance();
            }
        });
    }

    public static void main(String[] args) {
        new exactly_80_attendance();
    }
}

