package ADMIN;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Notice extends JFrame {
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton singOutButton;
    private JButton updateButton;
    private JButton deleteButton;
    private JButton addNewButton;
    private JPanel JPanelMain;
    private JPanel JPanel1;
    private JPanel JPanel2;
    private JTable table1;
    private JScrollPane JScrollPane;


    public Notice() {
        setTitle("Notice");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);


        setupTable();

        loadCourseData();

        setVisible(true); // Center the window
    }

    private void setupTable() {
        DefaultTableModel model = new DefaultTableModel(new Object[]{"Id","Title","Content"}, 0);
        table1.setModel(model);
    }

    private Object loadCourseData() {
        DefaultTableModel model = (DefaultTableModel) table1.getModel();
        model.setRowCount(0); // Clear existing data


        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM notice");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                model.addRow(new Object[]{
                        rs.getString("notice_id"),
                        rs.getString("title"),
                        rs.getString("content")
                });
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading course data: " + ex.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }

        return null;
    }
    public static void main(String[] args) {

        Notice n= new Notice();
    }
}
