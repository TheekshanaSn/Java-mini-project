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

public class M_Update {
    JFrame frame;
    private JPanel panel1;
    private JTextField textField3;
    private JTextField textField2;
    private JButton HOMEButton;
    private JButton UPDATEButton;
    private JScrollPane Jpane;
    private JTable showTable;
    private JComboBox comboBox1;

    public M_Update() {
        frame = new JFrame();
        frame.setVisible(true);
        frame.setLocationRelativeTo(null);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setContentPane(panel1);
        frame.setSize(1080, 600);


        try {
            Connection conn = MyConnection.getConnection();
            String query = "select medical_id from Medical order by medical_id";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            // stmt = conn.createStatement();
            comboBox1.removeAllItems(); // Clear previous items

            while (rs.next()) {
                String id = rs.getString("medical_id");
                comboBox1.addItem(id); // Add to JComboBox

            }



            rs.close();
            stmt.close();

        } catch (SQLException ex) {
            throw new RuntimeException(ex);
            //JOptionPane.showMessageDialog("Error"+ex.getMessage());
        }

        comboBox1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                try {

                    Connection conn = MyConnection.getConnection();
                    String query2 = "SELECT * FROM Medical WHERE medical_id='" + comboBox1.getSelectedItem() + "'";
                    Statement stmt2 = conn.createStatement();
                    ResultSet rs2 = stmt2.executeQuery(query2);


                    while (rs2.next()) {
                        textField2.setText(rs2.getString("med_undergraduate_id"));
                        textField3.setText(rs2.getString("date"));

                    }
                }catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }
            }
        });

        UPDATEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String medical_id =comboBox1.getSelectedItem().toString() ;
                String med_undergraduate_id = textField2.getText();
                String date = textField3.getText();

                try {

                    Connection conn = MyConnection.getConnection();

                    String query = "UPDATE Medical SET " +
                            "med_undergraduate_id = '" + med_undergraduate_id + "', " +
                            "date = '" + date + "' " +
                            "WHERE medical_id = '" + medical_id + "'";


                    Statement stmt = conn.createStatement();
                    int rs = stmt.executeUpdate(query);


                    DefaultTableModel model = (DefaultTableModel) showTable.getModel();


                    if (model.getColumnCount() == 0) {
                        String[] columnNames = {
                                "medical_id", "med_undergraduate_id", "date"
                        };
                        model.setColumnIdentifiers(columnNames);
                    }

                    Object[] rowData = {
                            medical_id, med_undergraduate_id, date
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
        new M_Update();
    }
}
