package ADMIN;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.sql.*;


public class User_profile extends JFrame{
    private JButton undergraduateButton;
    private JButton lecturerButton;
    private JButton technicalOfficerButton;
    private JButton addNewButton;
    private JPanel JPanel1;
    private JPanel JPanel2;
    private JPanel JPanelMain;
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton singOutButton;
    private JTable table1;
    private JTextField textField1;
    private JTextField textField2;
    private JButton deleteButton;
    private JButton updateButton;


    public User_profile() {
        setTitle("User");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);

        setupTable();

        loadCourseData();


        setVisible(true); // Center the window
    }

    private void setupTable() {
        DefaultTableModel model = new DefaultTableModel(
                new Object[]{"ID", "Department"}, 0);
        table1.setModel(model);
    }

    private Object loadCourseData() {
        DefaultTableModel model = (DefaultTableModel) table1.getModel();
        model.setRowCount(0);


        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM  Undergraduate");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                model.addRow(new Object[]{
                        rs.getString("undergraduate_id"),
                        rs.getString("department")
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

        User_profile user = new User_profile();
    }
}





