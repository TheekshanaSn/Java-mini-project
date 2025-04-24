package Medical;

import MyCon.MyConnection;
import to.To_Profile;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Medical {
    private JTable showTable;
    private JPanel Main_panel;
    private JButton HOMEButton;

    JFrame frame;

    public Medical() {
        frame = new JFrame();
        frame.setTitle("TO Profile");
        frame.setContentPane(Main_panel);
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        frame.setSize(1080, 600);
        frame.setVisible(true);





        try {
            Connection conn = MyConnection.getConnection();
            String query = "SELECT * FROM Medical";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            DefaultTableModel model = (DefaultTableModel) showTable.getModel();

            String[] columnNames = {
                    "medical_id", "med_undergraduate_id", "course_code","date","reason",
            };
            model.setColumnIdentifiers(columnNames);

            while (rs.next()) {
                Object[] rowData = {
                        rs.getString("medical_id"),
                        rs.getString("med_undergraduate_id"),
                        rs.getString("med_course_code"),
                        rs.getString("date"),
                        rs.getString("reason"),

                };
                model.addRow(rowData);
            }

            rs.close();
            stmt.close();
            conn.close();

        }catch (SQLException e) {
            e.printStackTrace();
        }

        HOMEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                To_Profile profile = new To_Profile();

            }
        });
    }



    public static void main(String[] args) {
        new Medical();

    }
}

