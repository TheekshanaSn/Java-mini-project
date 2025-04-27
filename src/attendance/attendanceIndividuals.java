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


public class attendanceIndividuals {
    private JPanel panel1;
    private JButton previewButton;
    private JComboBox comboBox1;
    private JTable showTable;
    //private JScrollPane showTable;


    JFrame frame;

    public attendanceIndividuals() {
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
            String query = "SELECT  DISTINCT at_undergraduate_id from Attendance order by at_undergraduate_id ";
            Statement stmt1 = conn.createStatement();
            ResultSet rs1 = stmt1.executeQuery(query);
            comboBox1.removeAllItems();

            while (rs1.next()) {
                String id = rs1.getString("at_undergraduate_id");
                comboBox1.addItem(id); // Add to JComboBox

            }
            rs1.close();
            stmt1.close();


        }catch (SQLException ex) {
            throw new RuntimeException(ex);
        }


        comboBox1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                try {

                    Connection conn = MyConnection.getConnection();
                    String query2 = "SELECT * FROM Attendance WHERE at_undergraduate_id='" + comboBox1.getSelectedItem() + "'" ;
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(query2);

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


                } catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }

            }

        });




//        try {
//            Connection conn = MyConnection.getConnection();
//            String Query = "SELECT * FROM Attendance WHERE attendance_id= query ORDER BY attendance_id ";
//            Statement stmt = conn.createStatement();
//            ResultSet rs = stmt.executeQuery(Query);
//
//
//            model.setRowCount(0); // clear previous data
//
//            String[] columnNames = {
//                    "at_undergraduate_id", "at_course_code", "Attendance percentage"
//            };
//            model.setColumnIdentifiers(columnNames);
//
//            while (rs.next()) {
//                Object[] rowData = {
//                        rs.getString("at_undergraduate_id"),
//                        rs.getString("at_course_code"),
//                        rs.getString("Attendance percentage"),
//                };
//                model.addRow(rowData);
//            }
//
//            rs.close();
//            stmt.close();
//            conn.close();
//        } catch (SQLException e) {
//            e.printStackTrace();
//            JOptionPane.showMessageDialog(frame, "Database error: " + e.getMessage());
//        }
        previewButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                new Attendance();
            }
        });
    }

    public static void main(String[] args) {
        new attendanceIndividuals();
    }
}

