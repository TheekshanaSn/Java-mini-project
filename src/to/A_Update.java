package to;

import ADMIN.MyCon.MyConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class A_Update extends JFrame {
    private final Object AutoCompleteDecorator = null;
    JFrame frame;
    private JPanel panel1;
    private JComboBox comboBox2;
    private JTextField textField3;
    private JSpinner spinner1;
    private JComboBox comboBox1;
    private JTextField textField6;
    private JTextField textField2;
    private JTextField textField5;
    private JTextField textField4;
    private JButton HOMEButton;
    private JButton UPDATEButton;
    private JTable showTable;
    private JComboBox comboBox3;

    public A_Update() {
        frame = new JFrame();
        frame.setVisible(true);
        frame.setLocationRelativeTo(null);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setContentPane(panel1);
        frame.setSize(1080, 600);
        frame.setResizable(false);

       // AutoCompleteDecorator.decorate(comboBox3);


        comboBox1.addItem("T");
        comboBox1.addItem("P");
        comboBox1.addItem("TP");

        comboBox2.addItem("present");
        comboBox2.addItem("absent");


                try {
                    Connection conn = MyConnection.getConnection();
                    String query = "select attendance_id from Attendance ORDER BY attendance_id";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                   // stmt = conn.createStatement();
                    comboBox3.removeAllItems(); // Clear previous items

                    while (rs.next()) {
                        String id = rs.getString("attendance_id");
                        comboBox3.addItem(id); // Add to JComboBox

                    }




                    rs.close();
                    stmt.close();

                } catch (SQLException ex) {
                    throw new RuntimeException(ex);
                    //JOptionPane.showMessageDialog("Error"+ex.getMessage());
                }
        comboBox3.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                try {

                    Connection conn = MyConnection.getConnection();
                    String query2 = "SELECT * FROM attendance WHERE attendance_id='" + comboBox3.getSelectedItem() + "'";
                    Statement stmt2 = conn.createStatement();
                    ResultSet rs2 = stmt2.executeQuery(query2);


                    while (rs2.next()) {
                        textField2.setText(rs2.getString("at_undergraduate_id"));
                        textField3.setText(rs2.getString("at_course_code"));
                        textField4.setText(rs2.getString("date"));
                        textField5.setText(rs2.getString("medical_status"));
                        textField6.setText(rs2.getString("at_to_id"));
                        comboBox1.setSelectedItem(rs2.getString("at_course_type"));
                        comboBox2.setSelectedItem(rs2.getString("attendance"));
                        spinner1.setValue(Integer.parseInt(rs2.getString("session_no")));

                    }
                }catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }

            }
        });
        UPDATEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String attendence_id =comboBox3.getSelectedItem().toString() ;
                String at_undergraduate_id = textField2.getText();
                String at_corse_code = textField3.getText();
                String date = textField4.getText();
                String medical_status = textField5.getText();
                String at_to_id = textField6.getText();
                String at_corse_type = comboBox1.getSelectedItem().toString();
                String attendance = comboBox2.getSelectedItem().toString();
                String session = spinner1.getModel().getValue().toString();

                try {

                    Connection conn = MyConnection.getConnection();

                    String medical_status_value = (medical_status == null || medical_status.trim().isEmpty()) ? "NULL" : "'" + medical_status + "'";

                    String query = "UPDATE Attendance SET " +
                            "at_undergraduate_id = '" + at_undergraduate_id + "', " +
                            "at_course_code = '" + at_corse_code + "', " +
                            "at_course_type = '" + at_corse_type + "', " +
                            "date = '" + date + "', " +
                            "attendance = '" + attendance + "', " +
                            "medical_status = " + medical_status_value + ", " +
                            "session_no = '" + session + "', " +
                            "at_to_id = '" + at_to_id + "' " +
                            "WHERE attendance_id = '" + attendence_id + "'";

                    Statement stmt = conn.createStatement();
                    int rs = stmt.executeUpdate(query);


                    DefaultTableModel model = (DefaultTableModel) showTable.getModel();


                    if (model.getColumnCount() == 0) {
                        String[] columnNames = {
                                "attendence_id", "at_undergraduate_id", "at_corse_code", "at_course_type",
                                "date", "attendence", "medical_status", "session", "at_to_id"
                        };
                        model.setColumnIdentifiers(columnNames);
                    }

                    Object[] rowData = {
                            attendence_id, at_undergraduate_id, at_corse_code, at_corse_type,
                            date, attendance, medical_status, session, at_to_id
                    };

                    model.addRow(rowData); // inside the try block neither not working

                }catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }




            }
        });
        HOMEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                To_Profile profile = new To_Profile();

            }
        });
    }


    public static void main(String[] args) {
        new A_Update();
        MyConnection myConnection = new MyConnection();

    }
}
