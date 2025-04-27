package Lecturer;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Medical extends JFrame {
    private JButton btnBack;
    private JButton btnExit;
    private JTable table1;
    private JTextArea arReason;
    private JTextField txtSearchMedical;
    private JLabel lblUID;
    private JScrollPane tblMedical;
    private JButton btnSearch;
    private JPanel medical;
    private JButton rereshButton;

    private String user_id;
    private String password;
    private String course_code;

    public Medical(String user_id, String password) {
        this.user_id = user_id;
        this.password = password;

        setTitle("Medical");
        setContentPane(medical);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);
        setVisible(true);

        getLecturerCourseCode(user_id);
        tableLoad();

        table1.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                showSelectedMedicalReason();
            }
        });

        btnExit.addActionListener(e -> System.exit(0));

        btnBack.addActionListener(e -> {

            setVisible(false);
            new ViewUndergraduate(user_id, password).setVisible(true);
        });

        btnSearch.addActionListener(e -> searchMedicalById());
        rereshButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new Medical(user_id,password).setVisible(true);
            }
        });
    }

    private void getLecturerCourseCode(String user_id) {
        PreparedStatement pst;
        try {
            Conn conn = new Conn();
            pst = conn.c.prepareStatement("SELECT course_code FROM course_unit WHERE c_lecturer_id = ?");
            pst.setString(1, user_id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                course_code = rs.getString("course_code");
                System.out.println("Lecturer course code loaded: " + course_code);
            }
        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error loading lecturer course code.");
        }
    }

    public void tableLoad() {
        PreparedStatement pst;
        Conn conn = new Conn();
        try {
            String sql = "SELECT medical_id, med_undergraduate_id, date FROM medical WHERE med_course_code = ?";
            pst = conn.c.prepareStatement(sql);
            pst.setString(1, course_code);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"MEDICAL ID", "Undergraduate ID", "Date"}, 0
            );

            while (rs.next()) {
                String mid = rs.getString("medical_id");
                String uid = rs.getString("med_undergraduate_id");
                String date = rs.getString("date");

                model.addRow(new Object[]{mid, uid, date});
            }

            table1.setModel(model);

            System.out.println("Medical records loaded for course: " + course_code);

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error loading medical records.");
        }
    }

    private void showSelectedMedicalReason() {
        int row = table1.getSelectedRow();
        if (row != -1) {
            String medicalId = table1.getValueAt(row, 0).toString();
            String undergraduateId = table1.getValueAt(row, 1).toString();

            lblUID.setText(undergraduateId);
            fetchMedicalReason(medicalId);
        }
    }

    private void fetchMedicalReason(String medicalId) {
        PreparedStatement pst;
        Conn conn = new Conn();
        try {
            String sql = "SELECT reason FROM medical WHERE medical_id = ?";
            pst = conn.c.prepareStatement(sql);
            pst.setString(1, medicalId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String reason = rs.getString("reason");
                arReason.setText(reason);
            }
        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error fetching medical reason.");
        }
    }

    private void searchMedicalById() {
        String searchText = txtSearchMedical.getText().trim();
        if (searchText.isEmpty()) {
            tableLoad();
            return;
        }

        PreparedStatement pst;
        Conn conn = new Conn();
        try {
            String sql = "SELECT medical_id, med_undergraduate_id, date FROM medical WHERE medical_id LIKE ?";
            pst = conn.c.prepareStatement(sql);
            pst.setString(1, "%" + searchText + "%");
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"MEDICAL ID", "Undergraduate ID", "Date"}, 0
            );

            while (rs.next()) {
                String mid = rs.getString("medical_id");
                String uid = rs.getString("med_undergraduate_id");
                String date = rs.getString("date");

                model.addRow(new Object[]{mid, uid, date});
            }

            table1.setModel(model);
            System.out.println("Medical search done: " + searchText);

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error searching medical records.");
        }
    }

    public static void main(String[] args) {
        new Medical("LEC001", "pass123").setVisible(true);
    }
}
