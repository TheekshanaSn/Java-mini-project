package to;

import MyCon.MyConnection;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class TO_Profile_Update {
    private JPanel panel1;
    private JTextField textField2;
    private JTextField textField3;
    private JTextField textField4;
    private JTextField textField5;
    private JTextField textField6;
    private JButton HOMEButton;
    private JTextField textField1;
    private JButton UPDATEButton;
    private JPasswordField passwordField1;
    private JComboBox comboBox1;

    JFrame frame;

    public static void main(String[] args) {

        new TO_Profile_Update();
        MyConnection myConnection = new MyConnection();
    }

    public void setPanel1(JPanel panel1) {
        this.panel1 = panel1;
    }

    public TO_Profile_Update() {
        frame = new JFrame();
        frame.setVisible(true);
        frame.setLocationRelativeTo(null);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setContentPane(panel1);
        frame.setSize(1080, 600);
        frame.setResizable(false);

        //___________________________________________________________________________________

        // create this get method user login
        // set to query to set method into variable
        //  public void setTo(to_id){
          //this.to_id=to_id
         //}
        //___________________________________________________________________________________


        try {
            // String selectedId = comboBox1.getSelectedItem().toString(); // Get selected ID
            Connection conn = MyConnection.getConnection();
            String query = "SELECT * FROM technical_officer t INNER JOIN user u ON t.to_id = u.user_id where t.to_id ='TCO002'"; // i need the login page to id
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            if (rs.next()) {
                textField1.setText(rs.getString("to_id"));
                textField2.setText(rs.getString("email"));
                textField3.setText(rs.getString("Name"));
                textField4.setText(rs.getString("phone"));
                textField5.setText(rs.getString("username"));
                passwordField1.setText(rs.getString("password"));
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(frame, "Error: " + ex.getMessage());
        }
        UPDATEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {




                String to_id = textField1.getText();
                String to_name = textField2.getText();
                String to_email = textField3.getText();
                String to_phone = textField4.getText();
                String to_username = textField5.getText();

                if (to_id.isEmpty() || to_name.isEmpty() || to_email.isEmpty() || to_phone.isEmpty()) {
                    JOptionPane.showMessageDialog(frame, "Please fill all fields.");
                    return;
                }



                String query = "UPDATE user SET " +
                        "user_id = '" + to_id + "', " +
                        "Name = '" + to_name + "', " +
                        "email = '" + to_email + "', " +
                        "phone = '" + to_phone + "' " +
                        "WHERE username = '" + to_username + "'";


                try {
                    Connection conn = MyConnection.getConnection();
                    Statement stmt = conn.createStatement();

                    int result = stmt.executeUpdate(query);
                    // JOptionPane.showMessageDialog(frame, result);

                    // Optional: run the SELECT if needed
                    String query2 = "SELECT * FROM technical_officer t INNER JOIN user u ON t.to_id = u.user_id WHERE t.to_id = 'TCO002'";
                    ResultSet rs = stmt.executeQuery(query2);

                    if (rs.next()) {
                        String to_id2 = rs.getString("to_id");
                        String name = rs.getString("Name");
                        String email = rs.getString("email");
                        String phone = rs.getString("phone");

                        JOptionPane.showMessageDialog(frame,
                                "to_id: " + to_id2 + "\nName: " + name + "\nEmail: " + email + "\nPhone: " + phone);
                    } else {
                        JOptionPane.showMessageDialog(frame, "No data found.");
                    }

                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                    JOptionPane.showMessageDialog(frame, "Error: " + ex.getMessage());
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



}


