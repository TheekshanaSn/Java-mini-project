package Medical;

import ADMIN.MyCon.MyConnection;
import to.To_Profile;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class Medical {
    private JTable showTable;
    private JPanel Main_panel;
    private JButton HOMEButton;

    JFrame frame;

    public Medical() {
        frame = new JFrame();
        frame.setTitle("TO Profile");
        frame.setContentPane(Main_panel);
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        frame.setSize(1080, 600);
        frame.setVisible(true);

        try {
            Connection conn = MyConnection.getConnection();

            Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery("SELECT * FROM Medical");

            Statement stmt2 = conn.createStatement();
            ResultSet rs2 = stmt2.executeQuery("SELECT at_undergraduate_id, at_course_code, medical_status, attendance,session_no FROM Attendance");

            DefaultTableModel model = (DefaultTableModel) showTable.getModel();
            model.setColumnIdentifiers(new String[]{
                    "medical_id", "med_undergraduate_id", "course_code", "date", "reason","med_session_no"
            });

            while (rs2.next()) {
                String at_undergraduate_id = rs2.getString("at_undergraduate_id");
                String at_course_code = rs2.getString("at_course_code");
                String attendance = rs2.getString("attendance");
                String session_no = rs2.getString("session_no");

                if (attendance.equals("absent")) {
                    rs.beforeFirst(); // Reset  medical result set
                    while (rs.next()) {
                        String medical_id = rs.getString("medical_id");
                        String med_undergraduate_id = rs.getString("med_undergraduate_id");
                        String med_course_code = rs.getString("med_course_code");
                        String med_session_no = rs.getString("med_session_no");
                        //String reason = rs.getString("reason");

                        if (at_undergraduate_id.equals(med_undergraduate_id) && at_course_code.equals(med_course_code) && session_no.equals(med_session_no)) {
                            String updateQuery = "UPDATE Attendance SET medical_status = ? WHERE at_undergraduate_id = ? AND at_course_code = ? AND session_no = ?";
                            PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                            updateStmt.setString(1, medical_id);
                            updateStmt.setString(2, at_undergraduate_id);
                            updateStmt.setString(3, at_course_code);
                            updateStmt.setString(4, session_no);
                            updateStmt.executeUpdate();
                            updateStmt.close();
                        }
                    }
                }
            }

            rs.beforeFirst();
            while (rs.next()) {
                Object[] rowData = {
                        rs.getString("medical_id"),
                        rs.getString("med_undergraduate_id"),
                        rs.getString("med_course_code"),
                        rs.getString("date"),
                        rs.getString("reason"),
                        rs.getString("med_session_no")
                };
                model.addRow(rowData);
            }

            rs.close();
            stmt.close();
            rs2.close();
            stmt2.close();
            conn.close();

        } catch (SQLException e) {
            e.printStackTrace();

        }

        HOMEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                new To_Profile();

            }

        });
    }

    public static void main(String[] args) {
        new Medical();
    }
}
