package to;

import MyCon.MyConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class A_Insert {
    private JPanel panel1;
    private JButton HOMEButton;
    private JButton INSERTButton;
    private JTextField textField1;
    private JTextField textField2;
    private JTextField textField3;
    private JComboBox comboBox1;
    private JTextField textField4;
    private JComboBox comboBox2;
    private JTextField textField5;
    private JSpinner spinner1;
    private JTextField textField6;
    private JTable showTable;

    JFrame frame;


    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    Date date1 = null;
    Calendar calendar = Calendar.getInstance();
    DefaultTableModel model;


    public A_Insert() {

            frame = new JFrame();
            frame.setVisible(true);
            frame.setLocationRelativeTo(null);
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setContentPane(panel1);
            frame.setSize(800, 600);


            String [] course_type={"T","P","TP"};

              for (String id : course_type) {
            comboBox1.addItem(id);
             }

        String [] attendence={"present","absent"};

        for (String at : attendence) {
            comboBox2.addItem(at);
        }


              initComponents();
              model = new DefaultTableModel();
              textField4.setText(" "+dateFormat.format(calendar.getTime()));








        INSERTButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                String attendence_id = textField1.getText();
                String at_undergraduate_id = textField2.getText();
                String at_corse_code = textField3.getText();
                String date = textField4.getText();
                String medical_status = textField5.getText();
                String at_to_id = textField6.getText();
                String at_corse_type = comboBox1.getSelectedItem().toString();
                String attendance = comboBox2.getSelectedItem().toString();
                String session = spinner1.getModel().getValue().toString();


                int value = (int) spinner1.getValue();
                if (value <= 0) {
                    JOptionPane.showMessageDialog(frame, "Enter valid number");
                    return;
                }

                if (attendence_id.isEmpty() || at_undergraduate_id.isEmpty() || at_corse_code.isEmpty()
                        || date.isEmpty() || at_to_id.isEmpty()) {
                    JOptionPane.showMessageDialog(frame, "You need to fill out all the data!!!");
                    return;
                }


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



                try{
                    Connection conn = MyConnection.getConnection();
                    String query = "INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) " +
                            "VALUES ('" + attendence_id + "', '" + at_undergraduate_id + "', '" + at_corse_code + "', '" + at_corse_type + "', '" +
                            date + "', '" + attendance + "', '" + medical_status + "', '" + session + "', '" + at_to_id + "')";

                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(query);



                }catch (Exception s){
                    JOptionPane.showMessageDialog(frame, "Something went wrong");
                }

                model.addRow(rowData);

                textField1.setText("");
                textField2.setText("");
                textField3.setText("");
                textField4.setText("");
                textField5.setText("");
                textField6.setText("");
                comboBox1.setSelectedIndex(0);
                comboBox2.setSelectedIndex(0);
                spinner1.setValue(1);
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





    private void initComponents() {

    }

    public static void main(String[] args) {
        new A_Insert();
        MyConnection myConnection = new MyConnection();
    }
}
