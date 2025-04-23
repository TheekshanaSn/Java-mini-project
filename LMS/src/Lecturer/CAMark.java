package Lecturer;

import net.proteanit.sql.DbUtils;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.Collections;

public class CAMark extends JFrame {
    private JTextField txtUndergraduateID;
    private JComboBox cmbMarkType;
    private JTextField txtMark;
    private JPanel CAMark;
    private JLabel lblCourseCode;
    private JTable tblMark;
    private JButton uploadButton;
    private JButton btnUpdate;
    private JTextField txtSearch;
    private JButton btnSearch;
    private JButton BACKButton;
    private JButton EXITButton;
    private JLabel lblCourseName;
    PreparedStatement pst;
    private String user_id;
    private String corse_code;;
    private String name;


    CAMark(String user_id) {
        this.user_id = user_id;
        getLecturerCorsecodeandName(user_id);
        table_load();


        setTitle("Lecturer Dashboard");
        setContentPane(CAMark);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(1000, 800);
        setLocationRelativeTo(null);
        setVisible(true);



        uploadButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                table_update();
            }
        });
        btnUpdate.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                updateMarkOnly();
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
                String User_id=new LectureDashBord().getUser_id();
                String Password=new LectureDashBord().getPassword();
                new LectureDashBord(User_id,Password).setVisible(true);
            }
        });
    }


    void table_load() {
        try {
            Conn conn = new Conn();
            String sql;
            PreparedStatement pst;
            ResultSet rs;
            DefaultTableModel model;
            String CASTATUS;
            switch (corse_code){
                case "ICT2113":
                    sql = "SELECT undergraduate_id, course_code, Quizze01, Quizze02, Quizze03, Midterm FROM camarks WHERE course_code = ?";
                    pst = conn.c.prepareStatement(sql);
                    pst.setString(1, corse_code);
                    rs = pst.executeQuery();


                    model = new DefaultTableModel(
                            new String[]{"Undergraduate ID", "Course Code", "Quizze01", "Quizze02", "Quizze03", "Midterm", "CAMARK","CASTATUS"}, 0
                    );


                    while (rs.next()) {
                        String id = rs.getString("undergraduate_id");
                        String code = rs.getString("course_code");
                        double q1 = rs.getDouble("Quizze01");
                        double q2 = rs.getDouble("Quizze02");
                        double q3 = rs.getDouble("Quizze03");
                        double mid = rs.getDouble("Midterm");

                        Double[] Mark = {q1, q2, q3};
                        Arrays.sort(Mark, Collections.reverseOrder());
                        double qm=(Mark[0]+Mark[1])/2;
                        double CAMARK = qm*10/100+mid*20/100;
                        CASTATUS="";
                        if(CAMARK>15){
                            CASTATUS="Pass";
                        }
                        else if(CAMARK<15){
                            CASTATUS="Fail";
                        }

                        model.addRow(new Object[]{id, code, q1, q2, q3, mid, CAMARK,CASTATUS});
                    }

                    tblMark.setModel(model);
                    System.out.println("Loading table for course_code: " + corse_code);
                    break;
                case "ICT2122":
                    sql = "SELECT undergraduate_id, course_code, Quizze01, Quizze02, Quizze03,Quizze04,Assessments01 ,Midterm FROM camarks WHERE course_code = ?";
                    pst = conn.c.prepareStatement(sql);
                    pst.setString(1, corse_code);
                    rs = pst.executeQuery();


                    model = new DefaultTableModel(
                            new String[]{"Undergraduate ID", "Course Code", "Quizze01", "Quizze02", "Quizze03","Quizze04","Assessments01", "Midterm", "CAMARK","CASTATUS"}, 0
                    );


                    while (rs.next()) {
                        String id = rs.getString("undergraduate_id");
                        String code = rs.getString("course_code");
                        double q1 = rs.getDouble("Quizze01");
                        double q2 = rs.getDouble("Quizze02");
                        double q3 = rs.getDouble("Quizze03");
                        double q4 = rs.getDouble("Quizze04");
                        double assessments01 = rs.getDouble("Assessments01");
                        double mid = rs.getDouble("Midterm");

                        Double[] Mark = {q1, q2, q3, q4};
                        Arrays.sort(Mark, Collections.reverseOrder());

                        double qm=((Mark[0]+Mark[1]+Mark[2])/3)*10/100;
                        double as=assessments01*10/100;
                        double midm=mid*20/100;
                        double CAMARK = qm+as+midm;
                        CASTATUS="";
                        if(CAMARK>20){
                            CASTATUS="Pass";
                        }
                        else if(CAMARK<20){
                            CASTATUS="Fail";
                        }

                        model.addRow(new Object[]{id, code, q1, q2, q3,q4,assessments01, mid, CAMARK,CASTATUS});
                    }

                    tblMark.setModel(model);
                    System.out.println("Loading table for course_code: " + corse_code);
                    break;


                case "ICT2133":
                    sql = "SELECT undergraduate_id, course_code, Quizze01, Quizze02, Quizze03,Assessments01,Assessments02  FROM camarks WHERE course_code = ?";
                    pst = conn.c.prepareStatement(sql);
                    pst.setString(1, corse_code);
                    rs = pst.executeQuery();


                    model = new DefaultTableModel(
                            new String[]{"Undergraduate ID", "Course Code", "Quizze01", "Quizze02", "Quizze03","Assessments01","Assessments02" , "CAMARK","CASTATUS"}, 0
                    );


                    while (rs.next()) {
                        String id = rs.getString("undergraduate_id");
                        String code = rs.getString("course_code");
                        double q1 = rs.getDouble("Quizze01");
                        double q2 = rs.getDouble("Quizze02");
                        double q3 = rs.getDouble("Quizze03");
                        double assessments01 = rs.getDouble("Assessments01");
                        double assessments02 = rs.getDouble("Assessments02");


                        Double[] Mark = {q1, q2, q3};
                        Arrays.sort(Mark, Collections.reverseOrder());
                        double qm=((Mark[0]+Mark[1]/3)*10/100);

                        double as=assessments01*10/100+assessments02*10/100;

                        double CAMARK = qm+as;
                        CASTATUS="";
                        if(CAMARK>15){
                            CASTATUS="Pass";
                        }
                        else if(CAMARK<15){
                            CASTATUS="Fail";
                        }

                        model.addRow(new Object[]{id, code, q1, q2, q3,assessments01,assessments01,CAMARK,CASTATUS});
                    }

                    tblMark.setModel(model);
                    System.out.println("Loading table for course_code: " + corse_code);
                    break;

                case "ICT2142":

                    sql = "SELECT undergraduate_id, course_code, Assessments01, Midterm FROM camarks WHERE course_code = ?";

                    pst = conn.c.prepareStatement(sql);
                    pst.setString(1, corse_code);
                    rs = pst.executeQuery();

                    // Define table model with column names
                    model = new DefaultTableModel(
                            new String[]{"Undergraduate ID", "Course Code","Assessments01","Midterm","CAMARK","CASTATUS"}, 0
                    );

                    // Populate model with rows + total calculation
                    while (rs.next()) {
                        String id = rs.getString("undergraduate_id");
                        String code = rs.getString("course_code");
                        double assessments01 = rs.getDouble("Assessments01");
                        double mid = rs.getDouble("Midterm");


                        double CAMARK = assessments01*20/100+mid*20/100;
                        CASTATUS="";
                        if(CAMARK>20){
                            CASTATUS="Pass";
                        }
                        else if(CAMARK<20){
                            CASTATUS="Fail";
                        }

                        model.addRow(new Object[]{id, code,assessments01,mid,CAMARK,CASTATUS});
                    }

                    tblMark.setModel(model);
                    System.out.println("Loading table for course_code: " + corse_code);
                    break;
                case "ICT2152":

                    sql = "SELECT undergraduate_id, course_code,Quizze01,Quizze02,Quizze03, Assessments01 FROM camarks WHERE course_code = ?";

                    pst = conn.c.prepareStatement(sql);
                    pst.setString(1, corse_code);
                    rs = pst.executeQuery();


                    model = new DefaultTableModel(
                            new String[]{"Undergraduate ID", "Course Code","Quizze01","Quizze02","Quizze03","Assessments01","Assessments02","CAMARK","CASTATUS"}, 0
                    );


                    while (rs.next()) {
                        String id = rs.getString("undergraduate_id");
                        String code = rs.getString("course_code");
                        double q1 = rs.getDouble("Quizze01");
                        double q2 = rs.getDouble("Quizze02");
                        double q3 = rs.getDouble("Quizze03");
                        double assessments01 = rs.getDouble("Assessments01");
                        double assessments02 = rs.getDouble("Assessments01");
                        Double[] Mark = {q1, q2, q3};
                        Arrays.sort(Mark, Collections.reverseOrder());
                        double qm=((Mark[0]+Mark[1]/2)*10/100);


                        double CAMARK = ((assessments01+assessments02)/2)*20/100;
                        CASTATUS="";
                        if(CAMARK>=15){
                            CASTATUS="Pass";
                        }
                        else if(CAMARK<15){
                            CASTATUS="Fail";
                        }

                        model.addRow(new Object[]{id, code,q1,q2,q3,assessments01,assessments02,CAMARK,CASTATUS});
                    }

                    tblMark.setModel(model);
                    System.out.println("Loading table for course_code: " + corse_code);
                    break;



            }


        } catch (Exception e) {
            e.printStackTrace();
        }
    }



//    void table_load() {
//        try {
//            Conn conn = new Conn();
//
//            pst = conn.c.prepareStatement("SELECT undergraduate_id, course_code, Quizze01, Quizze02, Quizze03, Midterm FROM camarks WHERE course_code =?");
//            pst.setString(1, corse_code);
//            ResultSet rs = pst.executeQuery();
//
//            DefaultTableModel model = new DefaultTableModel(
//                    new String[]{"Undergraduate ID", "Course Code", "Quizze01", "Quizze02", "Quizze03", "Midterm", "CA Mark"},0
//            );
//
//            while (rs.next()) {
//                String id=rs.getString("undergraduate_id");
//                String course_code=rs.getString("course_code");
//                double quizze01=rs.getDouble("Quizze01");
//                double quizze02=rs.getDouble("Quizze02");
//                double quizze03=rs.getDouble("Quizze03");
//                double Midterm=rs.getDouble("Midterm");
//                double Mark[]={quizze01,quizze02,quizze03};
//                Arrays.sort(Mark);
//                double CAMark=((Mark[0]+Mark[1])*(10/100))+(Midterm*(20/100));
//
//                model.addRow(new Object[]{id,course_code,quizze01,quizze02,quizze03,Midterm,CAMark});
//                tblMark.setModel(model);
//                System.out.println("Loading table for course_code: " + corse_code);
//
//
//            }
//
////            tblMark.setModel(DbUtils.resultSetToTableModel(rs));
////            System.out.println("Loading table for course_code: " + corse_code);
//
//
    ////            pst = conn.c.prepareStatement("SELECT * FROM camarks WHERE course_code = ?");
    ////            pst.setString(1, corse_code);
    ////            ResultSet rs = pst.executeQuery();
    ////            tblMark.setModel(DbUtils.resultSetToTableModel(rs));
    ////            System.out.println("Loading table for course_code: " + corse_code);
//
//        } catch (Exception e) {
//            System.out.println("Error loading table: " + e.getMessage());
//        }
//    }

    void table_update() {
        String courseCode =corse_code;
        String undergraduateID = txtUndergraduateID.getText();
        String markType = cmbMarkType.getSelectedItem().toString();
        String mark = txtMark.getText();

        if (undergraduateID.isEmpty() || mark.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please fill in all fields.");
            return;
        }

        try {
            Conn conn = new Conn();

            // Check if the row already exists
            pst = conn.c.prepareStatement("SELECT * FROM camarks WHERE undergraduate_id = ? AND course_code = ?");
            pst.setString(1, undergraduateID);
            pst.setString(2, corse_code);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // If row exists, update the specific mark type
                pst = conn.c.prepareStatement("UPDATE camarks SET " + markType + " = ? WHERE undergraduate_id = ? AND course_code = ?");
                pst.setString(1, mark);
                pst.setString(2, undergraduateID);
                pst.setString(3, corse_code);
            } else {
                // If not, insert a new row with the specific mark type filled
                String sql = "INSERT INTO camarks (undergraduate_id, course_code, " + markType + ") VALUES (?, ?, ?)";
                pst = conn.c.prepareStatement(sql);
                pst.setString(1, undergraduateID);
                pst.setString(2, corse_code);
                pst.setString(3, mark);
            }

            pst.executeUpdate();
            JOptionPane.showMessageDialog(this, "Mark uploaded successfully.");
            table_load();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Error uploading mark: " + e.getMessage());
        }
    }
    void updateMarkOnly() {
        String courseCode = corse_code; // you can make this dynamic if needed
        String undergraduateID = txtUndergraduateID.getText();
        String markType = cmbMarkType.getSelectedItem().toString();
        String mark = txtMark.getText();

        if (undergraduateID.isEmpty() || mark.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please fill in all fields.");
            return;
        }

        try {
            Conn conn = new Conn();

            // Check if the row exists before updating
            pst = conn.c.prepareStatement("SELECT * FROM camarks WHERE undergraduate_id = ? AND course_code = ?");
            pst.setString(1, undergraduateID);
            pst.setString(2, courseCode);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // Update only if the row exists
                pst = conn.c.prepareStatement("UPDATE camarks SET " + markType + " = ? WHERE undergraduate_id = ? AND course_code = ?");
                pst.setString(1, mark);
                pst.setString(2, undergraduateID);
                pst.setString(3, courseCode);
                pst.executeUpdate();

                JOptionPane.showMessageDialog(this, "Mark updated successfully.");
                table_load();
            } else {
                JOptionPane.showMessageDialog(this, "Record not found. Please upload the mark first.");
            }

        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Error updating mark: " + e.getMessage());
        }
    }


    void searchMarkByUndergraduateID() {
        String undergraduateID = txtSearch.getText().trim();

        if (undergraduateID.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter an Undergraduate ID to search.");
            return;
        }

        try {
            Conn conn = new Conn();
            pst = conn.c.prepareStatement("SELECT * FROM camarks WHERE undergraduate_id = ?");
            pst.setString(1, undergraduateID);
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



    private void getLecturerCorsecodeandName(String user_id) {

        try {
            Conn conn = new Conn();
            pst=conn.c.prepareStatement("select course_code,name from course_unit where c_lecturer_id=?");
            pst.setString(1, user_id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()) {
                corse_code = rs.getString(1);
                lblCourseCode.setText(corse_code);
                name=rs.getString(2);
                lblCourseName.setText(name);


                System.out.println(corse_code);


            }

        }catch (Exception e){
            System.out.println(e.getMessage());
        }
    }


    public static void main(String[] args) {
        new CAMark("").setVisible(true);
    }


}

