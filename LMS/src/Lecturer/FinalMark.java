package Lecturer;

import net.proteanit.sql.DbUtils;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.Collections;

public class FinalMark extends JFrame {
    private JPanel CAMark;
    private JLabel lblCourseCode;
    private JTextField txtUndergraduateID;
    private JComboBox cmbMarkType;
    private JTextField txtMark;
    private JTable tblMark;
    private JButton btnUpdate;
    private JButton uploadButton;
    private JButton BACKButton;
    private JButton EXITButton;
    private JTextField txtSearch;
    private JButton btnSearch;
    private JLabel lblCourseName;
    private JPanel finalmark;
    private String user_id;
    private String password;

    private String corse_code;
    public FinalMark(String user_id ,String password ) {

        CAMARKN camarkn= new CAMARKN(user_id,password);
        camarkn.setVisible(false);
        camarkn.ENG2122codeca();
        camarkn.ICT2113codeca();
        camarkn.ICT2122codeca();
        camarkn.ICT2133codeca();
        camarkn.ICT2142codeca();
        camarkn.ICT2152codeca();


        this.user_id = user_id;
        this.password = password;
        getLecturerCorsecodeandName(user_id);
        table_load();

        setTitle("| LectureDashBord | UploadMark | FinalMark |");
        setContentPane(finalmark);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(1000, 800);
        setLocationRelativeTo(null);
        setVisible(true);


        txtMark.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                char c = evt.getKeyChar();

                if (!(Character.isDigit(c) || c == '.' || c == KeyEvent.VK_BACK_SPACE || c == KeyEvent.VK_DELETE)) {
                    evt.consume();
                }
                if (c == '.' && txtMark.getText().contains(".")) {
                    evt.consume();
                }
            }
        });

        uploadButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (validateMarkInput()) {
                    table_update();
                }
            }
        });
        btnUpdate.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (validateMarkInput()) {
                    updateMarkOnly();
                }
            }
        });
        btnSearch.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                searchMarkByUndergraduateID();
            }
        });
        EXITButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });
        BACKButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new UploadMark(user_id,password).setVisible(true);
            }
        });
    }


    private boolean validateMarkInput() {
        String markText = txtMark.getText().trim();
        String undergraduateID = txtUndergraduateID.getText().trim();


        if (undergraduateID.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Undergraduate ID cannot be empty.", "Validation Error", JOptionPane.ERROR_MESSAGE);
            txtUndergraduateID.requestFocus();
            return false;
        }

        if (markText.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Mark cannot be empty.", "Validation Error", JOptionPane.ERROR_MESSAGE);
            txtMark.requestFocus();
            return false;
        }

        try {
            double mark = Double.parseDouble(markText);

            if (mark < 0 || mark > 100) {
                JOptionPane.showMessageDialog(this, "Mark must be between 0 and 100.", "Validation Error", JOptionPane.ERROR_MESSAGE);
                txtMark.requestFocus();
                return false;
            }

            return true;
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(this, "Mark must be a valid number.", "Validation Error", JOptionPane.ERROR_MESSAGE);
            txtMark.requestFocus();
            return false;
        }
    }

    void table_load() {
        try {
            String CASTATUS;
            switch (corse_code){
                case "ICT2113":
                    ICT2113codefinal();
                    break;
                case "ICT2122":
                    ICT2122codecafinal();
                    break;
                case "ICT2133":
                    ICT2133codefinal();
                    break;
                case "ICT2142":
                    ICT2142codefinal();
                    break;
                case "ICT2152":
                    ICT2152codefinal();
                    break;
                case "ENG2122":
                    ENG2122codefinal();
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void getLecturerCorsecodeandName(String user_id) {
        try {
            Conn conn = new Conn();
            PreparedStatement pst=conn.c.prepareStatement("select course_code,name from course_unit where c_lecturer_id=?");
            pst.setString(1, user_id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()) {
                corse_code = rs.getString(1);
                lblCourseCode.setText(corse_code);
                String name=rs.getString(2);
                lblCourseName.setText(name);
                System.out.println(corse_code);
            }
        } catch (Exception e){
            System.out.println(e.getMessage());
        }
    }

    void table_update() {
        String courseCode = corse_code;
        String undergraduateID = txtUndergraduateID.getText().trim();
        String markType = cmbMarkType.getSelectedItem().toString();
        String mark = txtMark.getText().trim();

        try {
            Conn conn = new Conn();
            PreparedStatement pst = conn.c.prepareStatement("SELECT * FROM camarks WHERE undergraduate_id = ? AND course_code = ?");
            pst.setString(1, undergraduateID);
            pst.setString(2, corse_code);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                pst = conn.c.prepareStatement("UPDATE finalmarks SET " + markType + " = ? WHERE undergraduate_id = ? AND course_code = ?");
                pst.setString(1, mark);
                pst.setString(2, undergraduateID);
                pst.setString(3, corse_code);
            } else {
                String sql = "INSERT INTO finalmarks (undergraduate_id, course_code, " + markType + ") VALUES (?, ?, ?)";
                pst = conn.c.prepareStatement(sql);
                pst.setString(1, undergraduateID);
                pst.setString(2, corse_code);
                pst.setString(3, mark);
            }

            pst.executeUpdate();
            JOptionPane.showMessageDialog(this, "Mark uploaded successfully.");
            table_load();
            clearInputFields();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Error uploading mark: " + e.getMessage());
        }
    }

    void updateMarkOnly() {
        String courseCode = corse_code;
        String undergraduateID = txtUndergraduateID.getText().trim();
        String markType = cmbMarkType.getSelectedItem().toString();
        String mark = txtMark.getText().trim();

        try {
            Conn conn = new Conn();
            PreparedStatement pst = conn.c.prepareStatement("SELECT * FROM finalmarks WHERE undergraduate_id = ? AND course_code = ?");
            pst.setString(1, undergraduateID);
            pst.setString(2, courseCode);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                pst = conn.c.prepareStatement("UPDATE finalmarks SET " + markType + " = ? WHERE undergraduate_id = ? AND course_code = ?");
                pst.setString(1, mark);
                pst.setString(2, undergraduateID);
                pst.setString(3, courseCode);
                pst.executeUpdate();

                JOptionPane.showMessageDialog(this, "Mark updated successfully.");
                table_load();
                clearInputFields();
            } else {
                JOptionPane.showMessageDialog(this, "Record not found. Please upload the mark first.");
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Error updating mark: " + e.getMessage());
        }
    }

    /**
     * Clear input fields after successful operations
     */
    private void clearInputFields() {
        txtUndergraduateID.setText("");
        txtMark.setText("");
        txtUndergraduateID.requestFocus();
    }

    void searchMarkByUndergraduateID() {
        String undergraduateID = txtSearch.getText().trim();

        if (undergraduateID.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter an Undergraduate ID to search.");
            return;
        }

        try {
            Conn conn = new Conn();
            PreparedStatement pst = conn.c.prepareStatement("SELECT * FROM finalmarks WHERE undergraduate_id = ? AND course_code=?");
            pst.setString(1, undergraduateID);
            pst.setString(2, corse_code);
            ResultSet rs = pst.executeQuery();

            if (!rs.isBeforeFirst()) {
                JOptionPane.showMessageDialog(this, "No record found for Undergraduate ID: " + undergraduateID);
                return;
            }

            tblMark.setModel(DbUtils.resultSetToTableModel(rs));
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Error searching marks: " + e.getMessage());
        }
    }

    public void ICT2113codefinal(){
        String sql = "SELECT undergraduate_id, course_code, Finaltheory, Finalpracticaly FROM finalmarks WHERE course_code = ?";
        Conn conn = new Conn();
        try {
            PreparedStatement pst = conn.c.prepareStatement(sql);
            pst.setString(1, corse_code);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"Undergraduate ID", "Course Code", "Finaltheory","FinalPracticaly" ,"Final exam Mark", }, 0
            );

            while (rs.next()) {
                String id = rs.getString("undergraduate_id");
                String code = rs.getString("course_code");
                double ft=rs.getDouble("Finaltheory");
                double fp=rs.getDouble("Finalpracticaly");




                double FEMark = ft * 0.40 + fp * 0.30;
                sql="update finalmarks set finalmarks=? where course_code=? and undergraduate_id=?";
                pst = conn.c.prepareStatement(sql);
                pst.setDouble(1, FEMark);
                pst.setString(2, code);
                pst.setString(3, id);
                pst.executeUpdate();


                model.addRow(new Object[]{id, code,ft,fp, FEMark });
            }

            tblMark.setModel(model);
            System.out.println("Loading table for course_code: " + corse_code);

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error loading CA marks.");
        }
    }

    public void ICT2122codecafinal(){
        String sql = "SELECT undergraduate_id, course_code, Finaltheory FROM finalmarks WHERE course_code = ?";
        Conn conn = new Conn();
        try {
            PreparedStatement pst = conn.c.prepareStatement(sql);
            pst.setString(1, corse_code);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"Undergraduate ID", "Course Code", "Finaltheory", "Final exam Mark", }, 0
            );

            while (rs.next()) {
                String id = rs.getString("undergraduate_id");
                String code = rs.getString("course_code");
                double ft=rs.getDouble("Finaltheory");

                double FEMark = ft * 0.60 ;
                sql="update finalmarks set finalmarks=? where course_code=? and undergraduate_id=?";
                pst = conn.c.prepareStatement(sql);
                pst.setDouble(1, FEMark);
                pst.setString(2, code);
                pst.setString(3, id);
                pst.executeUpdate();
                model.addRow(new Object[]{id, code,ft, FEMark });
            }

            tblMark.setModel(model);
            System.out.println("Loading table for course_code: " + corse_code);

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error loading CA marks.");
        }
    }

    public void ICT2133codefinal(){
        String sql = "SELECT undergraduate_id, course_code,Finaltheory, Finalpracticaly FROM finalmarks WHERE course_code = ?";
        Conn conn = new Conn();
        try {
            PreparedStatement pst = conn.c.prepareStatement(sql);
            pst.setString(1, corse_code);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"Undergraduate ID", "Course Code", "Finaltheory","Finalpracticaly", "Final exam Mark", }, 0
            );

            while (rs.next()) {
                String id = rs.getString("undergraduate_id");
                String code = rs.getString("course_code");
                double ft=rs.getDouble("Finaltheory");
                double fp=rs.getDouble("Finalpracticaly");

                double FEMark = ft * 0.40+fp * 0.30 ;

                sql="update finalmarks set finalmarks=? where course_code=? and undergraduate_id=?";
                pst = conn.c.prepareStatement(sql);
                pst.setDouble(1, FEMark);
                pst.setString(2, code);
                pst.setString(3, id);
                pst.executeUpdate();
                model.addRow(new Object[]{id, code,ft,fp, FEMark });
            }

            tblMark.setModel(model);
            System.out.println("Loading table for course_code: " + corse_code);

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error loading CA marks.");
        }
    }

    public void ICT2142codefinal(){
        String sql = "SELECT undergraduate_id, course_code,Finalpracticaly FROM finalmarks WHERE course_code = ?";
        Conn conn = new Conn();
        try {
            PreparedStatement pst = conn.c.prepareStatement(sql);
            pst.setString(1, corse_code);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"Undergraduate ID", "Course Code", "Finalpracticaly", "Final exam Mark", }, 0
            );

            while (rs.next()) {
                String id = rs.getString("undergraduate_id");
                String code = rs.getString("course_code");
                double fp=rs.getDouble("Finalpracticaly");


                double FEMark = fp * 0.60;

                sql="update finalmarks set finalmarks=? where course_code=? and undergraduate_id=?";
                pst = conn.c.prepareStatement(sql);
                pst.setDouble(1, FEMark);
                pst.setString(2, code);
                pst.setString(3, id);
                pst.executeUpdate();

                model.addRow(new Object[]{id, code,fp,FEMark });
            }

            tblMark.setModel(model);
            System.out.println("Loading table for course_code: " + corse_code);

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error loading CA marks.");
        }
    }

    public void ICT2152codefinal(){
        String sql = "SELECT undergraduate_id, course_code,Finaltheory FROM finalmarks WHERE course_code = ?";
        Conn conn = new Conn();
        try {
            PreparedStatement pst = conn.c.prepareStatement(sql);
            pst.setString(1, corse_code);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"Undergraduate ID", "Course Code", "Finaltheory", "Final exam Mark", }, 0
            );

            while (rs.next()) {
                String id = rs.getString("undergraduate_id");
                String code = rs.getString("course_code");
                double ft=rs.getDouble("Finaltheory");


                double FEMark = ft * 0.70;
                sql="update finalmarks set finalmarks=? where course_code=? and undergraduate_id=?";
                pst = conn.c.prepareStatement(sql);
                pst.setDouble(1, FEMark);
                pst.setString(2, code);
                pst.setString(3, id);
                pst.executeUpdate();



                model.addRow(new Object[]{id, code,ft,FEMark });
            }

            tblMark.setModel(model);
            System.out.println("Loading table for course_code: " + corse_code);

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error loading CA marks.");
        }
    }

    public void ENG2122codefinal(){
        String sql = "SELECT undergraduate_id, course_code,Finaltheory FROM finalmarks WHERE course_code = ?";
        Conn conn = new Conn();
        try {
            PreparedStatement pst = conn.c.prepareStatement(sql);
            pst.setString(1, corse_code);
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"Undergraduate ID", "Course Code", "Finaltheory", "Final exam Mark", }, 0
            );

            while (rs.next()) {
                String id = rs.getString("undergraduate_id");
                String code = rs.getString("course_code");
                double ft=rs.getDouble("Finaltheory");


                double FEMark = ft * 0.70;
                sql="update finalmarks set finalmarks=? where course_code=? and undergraduate_id=?";
                pst = conn.c.prepareStatement(sql);
                pst.setDouble(1, FEMark);
                pst.setString(2, code);
                pst.setString(3, id);
                pst.executeUpdate();

                model.addRow(new Object[]{id, code,ft,FEMark });
            }

            tblMark.setModel(model);
            System.out.println("Loading table for course_code: " + corse_code);

        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error loading CA marks.");
        }
    }

    public static void main(String[] args) {
        FinalMark frame = new FinalMark("LEC006","pass123");
    }
}