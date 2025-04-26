package ADMIN;

import MyCon.MyConnection;

import javax.swing.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

// Correct: Only abstract class, no need to extend JFrame
public abstract class Adminname {

    // Reusable method to load admin name into any JLabel
    public void loadAdminName(JLabel label) {
        try {
            Connection con = MyConnection.getConnection();
            String sql = "SELECT name FROM user WHERE role = 'admin' LIMIT 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String adminName = rs.getString("name");
                label.setText("Hi " + adminName);
            } else {
                label.setText("No Admin Found");
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            label.setText("Error Loading Admin");
        }
    }
}
