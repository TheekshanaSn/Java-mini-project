package Lecturer;

import net.proteanit.sql.DbUtils;

import javax.swing.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UndergraduateGrades extends JFrame {
    private JTextField txtSearch;
    private JButton btnSearch;
    private JTable tblGradeMark;
    private JButton btnExit;
    private JScrollPane tblgrade;
    private JButton btnBack;
    private JPanel Grade;

    UndergraduateGrades(){
        setTitle("CA Mark Profile");
        setContentPane(Grade);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(1000, 800);
        setLocationRelativeTo(null);
        setVisible(true);
        table_load();


    }
    void table_load() {
        try {
            Conn conn = new Conn();
            PreparedStatement pst = conn.c.prepareStatement(
                    "SELECT c.undergraduate_id, c.course_code, c.camarks, f.finalmarks " +
                            "FROM camarks c JOIN finalmarks f ON c.undergraduate_id = f.undergraduate_id " +
                            "WHERE c.status = 'pass'"
            );

            ResultSet rs = pst.executeQuery();
            tblGradeMark.setModel(DbUtils.resultSetToTableModel(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        new UndergraduateGrades().setVisible(true);


    }
}
