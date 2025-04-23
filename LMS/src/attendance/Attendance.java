package attendance;

import MyCon.MyConnection;
import to.To_Profile;

import javax.management.Query;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Attendance {
    private JPanel panel1;
    private JTable showTable;
    private JPanel Main_panel;
    private JButton HOMEButton;
    private JButton button1;
    private JButton exactly80AttendanceButton;
    private JButton lessThan80AttendanceButton;
    private JButton moreThan80AttendanceButton;
    private JButton lessThan80AttendanceButton1;
    private JButton attendanceIndividualsButton;
    //private String select_query = "SELECT * FROM attendance"; // default query select all data

    JFrame frame;

    public Attendance() {
        frame = new JFrame();
        frame.setTitle("TO Profile");
        frame.setContentPane(Main_panel);
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        frame.setSize(1080, 600);
        frame.setVisible(true);


        DefaultTableModel model = new DefaultTableModel();
        showTable.setModel(model);


        try {
            Connection conn = MyConnection.getConnection();
            String Query = "SELECT * FROM attendance ORDER BY attendance_id";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(Query);


            model.setRowCount(0); // clear previous data

            String[] columnNames = {
                    "attendance_id", "at_undergraduate_id", "at_course_code", "at_course_type",
                    "date", "attendance", "medical_status", "session_no", "at_to_id"
            };
            model.setColumnIdentifiers(columnNames);

            while (rs.next()) {
                Object[] rowData = {
                        rs.getString("attendance_id"),
                        rs.getString("at_undergraduate_id"),
                        rs.getString("at_course_code"),
                        rs.getString("at_course_type"),
                        rs.getString("date"),
                        rs.getString("attendance"),
                        rs.getString("medical_status"),
                        rs.getInt("session_no"),
                        rs.getString("at_to_id")
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




        button1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new moreThan_80_attendance();
            }
        });



        exactly80AttendanceButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new exactly_80_attendance();
            }
        });
        lessThan80AttendanceButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new lessThan_80_AttendanceWithout_Medical();

            }
        });
        moreThan80AttendanceButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new moreThan_80_attendanceWithMedicals();
            }
        });
        lessThan80AttendanceButton1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new lessThan_80_AttendanceWithMedical();
            }
        });
        attendanceIndividualsButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new attendanceIndividuals();
            }
        });


        HOMEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                new To_Profile();
            }
        });

    }

    private void loadTableData() {

    }

    public static void main(String[] args) {
        new Attendance();
    }
}
