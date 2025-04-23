package Lecturer;

import net.proteanit.sql.DbUtils;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static javax.swing.WindowConstants.EXIT_ON_CLOSE;

public class UndergraduateDetails extends JFrame {
    private JTextField txtSearch;
    private JButton btnSearch;
    private JButton btnRefresh;
    private JButton btnBack;
    private JButton btnExit;
    private JTable tblUndergraduateDetails;
    private JComboBox cmbSearch;
    private JPanel UndergraduateDetails;
    PreparedStatement pst;

    UndergraduateDetails() {
        setTitle("Undergraduate Details:");
        setContentPane(UndergraduateDetails);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(1000, 800);
        setLocationRelativeTo(null);
        setVisible(true);

        table_load();
        btnSearch.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String keyword = txtSearch.getText().trim();
                String column = cmbSearch.getSelectedItem().toString();

                if (keyword.isEmpty()) {
                    JOptionPane.showMessageDialog(null, "Please enter a search term.");
                    return;
                }

                // Prevent SQL injection by allowing only specific columns
                String[] allowedColumns = {"user_id", "email", "Name", "phone", "username", "password", "role"};
                boolean validColumn = false;
                for (String col : allowedColumns) {
                    if (col.equalsIgnoreCase(column)) {
                        validColumn = true;
                        break;
                    }
                }

                if (!validColumn) {
                    JOptionPane.showMessageDialog(null, "Invalid search criteria.");
                    return;
                }

                String query = "SELECT u.user_id, u.email, u.Name, u.phone, u.username, u.role, ug.department " +
                        "FROM User u " +
                        "INNER JOIN Undergraduate ug ON u.user_id = ug.undergraduate_id " +
                        "WHERE u." + column + " LIKE ?";

                try {
                    Conn conn = new Conn();
                    pst = conn.c.prepareStatement(query);
                    pst.setString(1, "%" + keyword + "%");
                    ResultSet rs = pst.executeQuery();
                    tblUndergraduateDetails.setModel(DbUtils.resultSetToTableModel(rs));
                } catch (SQLException e1) {
                    e1.printStackTrace();
                }
            }
        });
        btnRefresh.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                table_load();
            }
        });
    }

    void  table_load(){
        try{
            Conn conn = new Conn();
            pst=conn.c.prepareStatement("SELECT u.user_id, u.email, u.Name, u.phone, u.username, u.role, ug.department\n" +
                    "FROM User u\n" +
                    "INNER JOIN Undergraduate ug ON u.user_id = ug.undergraduate_id;");
            ResultSet rs=pst.executeQuery();
            tblUndergraduateDetails.setModel(DbUtils.resultSetToTableModel(rs));
        }catch (Exception e){
            e.printStackTrace();
        }
    }



    public static void main(String[] args) {
        new UndergraduateDetails();
    }
}
