package Lecturer;

import net.proteanit.sql.DbUtils;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.sql.*;

public class CourseMaterials extends JFrame {
    private JTextField courseCodeField;
    private JButton uploadButton;
    private JButton replaceButton;
    private JButton deleteButton;
    private JButton refreshButton;
    private JTable materialsTable;
    private JScrollPane scrollPane;
    private JPanel panelMain;
    private JButton OPenButton;
    private JButton Back;
    private JButton Exit;
    private JLabel lblCourseName;
    private String user_id;
    private PreparedStatement pst;
    private String corse_code;
    private String corse_Name;
    private String password;
    public CourseMaterials(String user_id,String password) {
        this.user_id = user_id;
        this.password = password;

        setTitle("Course Metirial");
        setContentPane(panelMain);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(1000, 800);
        setLocationRelativeTo(null);

        getLecturerCorsecode(user_id);
        table_load();

        setVisible(true);




        materialsTable.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                if (e.getClickCount() == 2) {
                    openSelectedPDF();
                }
            }
        });
        uploadButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                uploadMaterial();
            }
        });
        replaceButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                replaceSelectedPDF();
            }
        });
        deleteButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                deleteSelectedPDF();
            }
        });
        OPenButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                openSelectedPDF();
            }
        });
        Back.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
//                String User_id=new LectureDashBord().getUser_id();
//                String Password=new LectureDashBord().getPassword();
                new LectureDashBord(user_id,password).setVisible(true);

            }
        });
        Exit.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });
    }


    private void getLecturerCorsecode(String user_id) {
        try {
            Conn conn = new Conn();
            pst=conn.c.prepareStatement("select course_code,name from course_unit where c_lecturer_id=?");
            pst.setString(1, user_id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()) {
                corse_code = rs.getString(1);
                courseCodeField.setText(corse_code);
                corse_Name=rs.getString(2);
                lblCourseName.setText(corse_Name);

            }

        }catch (Exception e){

        }


    }
    void table_load() {
        try {
            Conn conn = new Conn();
            pst = conn.c.prepareStatement("SELECT id,course_code, file_name FROM course_materials where course_code = ? ");
            pst.setString(1, corse_code);
            ResultSet rs = pst.executeQuery();
            materialsTable.setModel(DbUtils.resultSetToTableModel(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void uploadMaterial() {
        String course_code = courseCodeField.getText().trim();
        if (course_code .isEmpty()) {
            JOptionPane.showMessageDialog(null, "Enter subject code.");
            return;
        }

        JFileChooser chooser = new JFileChooser();
        chooser.setFileFilter(new javax.swing.filechooser.FileNameExtensionFilter("PDF Files", "pdf"));
        int result = chooser.showOpenDialog(null);

        if (result == JFileChooser.APPROVE_OPTION) {
            File file = chooser.getSelectedFile();
            try (FileInputStream fis = new FileInputStream(file)) {
                Conn db = new Conn();
                Connection conn = db.c;
                PreparedStatement ps = conn.prepareStatement("INSERT INTO course_materials (course_code , file_name, pdf_data) VALUES (?, ?, ?)");
                ps.setString(1, course_code );
                ps.setString(2, file.getName());
                ps.setBinaryStream(3, fis, (int) file.length());
                ps.executeUpdate();
                JOptionPane.showMessageDialog(null, "Material uploaded successfully!");
                table_load();
            } catch (Exception ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(null, "Upload failed: " + ex.getMessage());
            }
        }
    }

    private void replaceSelectedPDF() {
        int row = materialsTable.getSelectedRow();
        if (row == -1) {
            JOptionPane.showMessageDialog(null, "Select a material to replace.");
            return;
        }

        int id = Integer.parseInt(materialsTable.getValueAt(row, 0).toString());

        JFileChooser chooser = new JFileChooser();
        chooser.setFileFilter(new javax.swing.filechooser.FileNameExtensionFilter("PDF Files", "pdf"));
        int result = chooser.showOpenDialog(null);

        if (result == JFileChooser.APPROVE_OPTION) {
            File file = chooser.getSelectedFile();
            try (FileInputStream fis = new FileInputStream(file)) {
                Conn db = new Conn();
                Connection conn = db.c;
                PreparedStatement ps = conn.prepareStatement("UPDATE course_materials SET file_name = ?, pdf_data = ?, uploaded_at = CURRENT_TIMESTAMP WHERE id = ?");
                ps.setString(1, file.getName());
                ps.setBinaryStream(2, fis, (int) file.length());
                ps.setInt(3, id);
                ps.executeUpdate();
                JOptionPane.showMessageDialog(null, "Material replaced successfully!");
                table_load();
            } catch (Exception ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(null, "Replace failed: " + ex.getMessage());
            }
        }
    }

    private void deleteSelectedPDF() {
        int row = materialsTable.getSelectedRow();
        if (row == -1) {
            JOptionPane.showMessageDialog(null, "Select a material to delete.");
            return;
        }

        int id = Integer.parseInt(materialsTable.getValueAt(row, 0).toString());
        int confirm = JOptionPane.showConfirmDialog(null, "Are you sure to delete this material?", "Confirm", JOptionPane.YES_NO_OPTION);

        if (confirm == JOptionPane.YES_OPTION) {
            try {
                Conn db = new Conn();
                Connection conn = db.c;
                PreparedStatement ps = conn.prepareStatement("DELETE FROM course_materials WHERE id = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
                JOptionPane.showMessageDialog(null, "Material deleted successfully!");
                table_load();
            } catch (Exception ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(null, "Delete failed: " + ex.getMessage());
            }
        }
    }

    private void openSelectedPDF() {
        int row = materialsTable.getSelectedRow();
        if (row == -1) return;

        int id = Integer.parseInt(materialsTable.getValueAt(row, 0).toString());

        try {
            Conn db = new Conn();
            Connection conn = db.c;
            PreparedStatement ps = conn.prepareStatement("SELECT file_name, pdf_data FROM course_materials WHERE id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                InputStream is = rs.getBinaryStream("pdf_data");
                File tempFile = File.createTempFile("material_", ".pdf");
                try (FileOutputStream fos = new FileOutputStream(tempFile)) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = is.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesRead);
                    }
                }

                if (Desktop.isDesktopSupported()) {
                    Desktop.getDesktop().open(tempFile);
                } else {
                    JOptionPane.showMessageDialog(null, "Desktop not supported.");
                }
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(null, "Failed to open PDF: " + ex.getMessage());
        }
    }



    public static void main(String[] args) {

        new CourseMaterials(""," ");
    }
}

