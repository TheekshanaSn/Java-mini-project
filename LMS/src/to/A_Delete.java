package to;

import MyCon.MyConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class A_Delete {
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
    private JButton DELETEButton;
    private JComboBox comboBox3;

    public A_Delete() {
        frame = new JFrame();
        frame.setVisible(true);
        frame.setLocationRelativeTo(null);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setContentPane(panel1);
        frame.setSize(800, 600);

        // AutoCompleteDecorator.decorate(comboBox3);


        comboBox1.addItem("T");
        comboBox1.addItem("P");
        comboBox1.addItem("TP");

        comboBox2.addItem("present");
        comboBox2.addItem("absent");


        try {
            Connection conn = MyConnection.getConnection();
            String query = "select attendance_id from Attendance";
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
        DELETEButton.addActionListener(new ActionListener() {
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

                    String query = "DELETE FROM attendance WHERE attendance_id='" + attendence_id + "'";

                    Statement stmt = conn.createStatement();
                    int rs = stmt.executeUpdate(query);

                    comboBox3.setSelectedIndex(0);
                    textField2.setText("");
                    textField3.setText("");
                    textField4.setText("");
                    textField5.setText("");
                    textField6.setText("");
                    comboBox1.setSelectedIndex(0);
                    comboBox2.setSelectedIndex(0);
                    spinner1.setValue(1);

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
        new A_Delete();
        MyConnection myConnection = new MyConnection();

    }
}
