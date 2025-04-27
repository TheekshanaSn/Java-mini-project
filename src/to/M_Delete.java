package to;

import ADMIN.MyCon.MyConnection;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class M_Delete {
    JFrame frame;
    private JPanel panel1;
    private JComboBox comboBox1;
    private JTextField textField1;
    private JTextField textField2;
    private JButton HOMEButton;
    private JButton DELETEButton;
    private JTextField textField3;
    private JTextField textField4;

    public M_Delete() {
        frame = new JFrame();
        frame.setVisible(true);
        frame.setLocationRelativeTo(null);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setContentPane(panel1);
        frame.setSize(1080, 600);
        frame.setResizable(false);



        try {
            Connection conn = MyConnection.getConnection();
            String query = "select medical_id from Medical order by medical_id";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            comboBox1.removeAllItems(); // Clear previous items

            while (rs.next()) {
                String id = rs.getString("medical_id");
                comboBox1.addItem(id);

            }



            rs.close();
            stmt.close();

        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }

        comboBox1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                try {

                    Connection conn = MyConnection.getConnection();
                    String query2 = "SELECT * FROM medical WHERE medical_id='" + comboBox1.getSelectedItem() + "'" ;
                    Statement stmt2 = conn.createStatement();
                    ResultSet rs2 = stmt2.executeQuery(query2);


                    while (rs2.next()) {
                        textField1.setText(rs2.getString("med_undergraduate_id"));
                        textField2.setText(rs2.getString("date"));
                        textField3.setText(rs2.getString("med_course_code"));
                        textField4.setText(rs2.getString("reason"));


                    }
                } catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }

            }

        });


        DELETEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String medical_id =comboBox1.getSelectedItem().toString() ;
                String med_undergraduate_id = textField1.getText();
               String date = textField2.getText();

                try {

                    Connection conn = MyConnection.getConnection();

                    String query = "DELETE FROM Medical WHERE medical_id='" + medical_id + "'";

                    Statement stmt = conn.createStatement();
                    int rs = stmt.executeUpdate(query);

                    comboBox1.setSelectedIndex(0);
                    textField1.setText("");
                    textField2.setText("");
                    textField3.setText("");
                    textField4.setText("");

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
        new M_Delete();
    }

    }