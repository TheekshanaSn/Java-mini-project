package to;

import MyCon.MyConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class M_Insert {

    JFrame frame;
    private JPanel Main_panel;
    private JTextField textField1;
    private JTextField textField2;
    private JTextField textField3;
    private JButton HOMEButton;
    private JButton INSERTButton;
    private JTable showTable;
    private JScrollPane Jpane;


    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    Date date1 = null;
    Calendar calendar = Calendar.getInstance();
    DefaultTableModel model;

    public M_Insert() {
        frame = new JFrame();
        frame.setVisible(true);
        frame.setLocationRelativeTo(null);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setContentPane(Main_panel);
        frame.setSize(1080, 600);


        initComponents();
        model = new DefaultTableModel();
        textField3.setText(" "+dateFormat.format(calendar.getTime()));


        INSERTButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String medical_id = textField1.getText();
                String med_undergraduate_id = textField2.getText();
                String date = textField3.getText();

                if (medical_id.isEmpty() || med_undergraduate_id.isEmpty() || date.isEmpty()) {
                    JOptionPane.showMessageDialog(frame, "Please fill all the fields");
                    return;
                }

                DefaultTableModel model = (DefaultTableModel) showTable.getModel();


                if (model.getColumnCount() == 0) {
                    String[] columnNames = {
                            "Medical_id","Med_undergraduate_id","Date"
                    };
                    model.setColumnIdentifiers(columnNames);
                }

                Object[] rowData = {
                        medical_id, med_undergraduate_id, date
                };



                try {
                    Connection conn = MyConnection.getConnection();

                    String query = "INSERT INTO Medical (medical_id, med_undergraduate_id, date) " +
                            "VALUES ('" + medical_id + "', '" + med_undergraduate_id + "', '" + date + "')";

                    Statement stmt = conn.createStatement();
                    int result = stmt.executeUpdate(query);

                    stmt.close();
                    conn.close();

                } catch (Exception s) {
                    s.printStackTrace();
                    JOptionPane.showMessageDialog(frame, "Something went wrong: " + s.getMessage());
                }
                model.addRow(rowData);

                textField1.setText("");
                textField2.setText("");
                textField3.setText("");

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
        new M_Insert();
    }
}
