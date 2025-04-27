package UserLogin;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.FileOutputStream;
import java.sql.*;

public class undergraduateLectureNotes extends JFrame {
    private JTable table1;
    private JButton backButton;
    private JButton downloadButton;
    private JPanel mainPanel;

    private String userId;
    private String password;
    private DefaultTableModel model;

    public undergraduateLectureNotes(String userId, String password) {
        this.userId = userId;
        this.password = password;

        setTitle("Lecture Notes");
        setContentPane(mainPanel);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(900, 600);
        setLocationRelativeTo(null);

        loadLectureNotes();

        downloadButton = new JButton("Download Note");
        mainPanel.add(downloadButton);

        downloadButton.addActionListener(e -> downloadSelectedNote());

        backButton.addActionListener(e -> {
            dispose();
            new undergraduate_Dash(userId, password);
        });

        setVisible(true);
    }

    private void loadLectureNotes() {
        model = new DefaultTableModel();
        model.addColumn("ID");
        model.addColumn("Course Code");
        model.addColumn("File Name");
        model.addColumn("Uploaded At");

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            String sql = "SELECT id, course_code, file_name, uploaded_at FROM lecture_notes";
            PreparedStatement pst = conn.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                model.addRow(new Object[]{
                        rs.getInt("id"),
                        rs.getString("course_code"),
                        rs.getString("file_name"),
                        rs.getTimestamp("uploaded_at")
                });
            }

            table1.setModel(model);
            table1.setRowHeight(25);
            table1.getTableHeader().setFont(new Font("SansSerif", Font.BOLD, 14));

            rs.close();
            pst.close();
            conn.close();

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error loading lecture notes: " + e.getMessage());
        }
    }

    private void downloadSelectedNote() {
        int selectedRow = table1.getSelectedRow();
        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(this, "Please select a note to download.");
            return;
        }

        int id = (int) model.getValueAt(selectedRow, 0); // Get the id

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/techlms", "root", "");
            String sql = "SELECT file_name, pdf_data FROM lecture_notes WHERE id = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String fileName = rs.getString("file_name");
                byte[] pdfBytes = rs.getBytes("pdf_data");

                JFileChooser fileChooser = new JFileChooser();
                fileChooser.setSelectedFile(new java.io.File(fileName));
                int option = fileChooser.showSaveDialog(this);

                if (option == JFileChooser.APPROVE_OPTION) {
                    FileOutputStream fos = new FileOutputStream(fileChooser.getSelectedFile());
                    fos.write(pdfBytes);
                    fos.close();
                    JOptionPane.showMessageDialog(this, "Lecture Note downloaded successfully!");
                }
            }

            rs.close();
            pst.close();
            conn.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Error downloading file: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        new undergraduateLectureNotes("UG001", "pass123");
    }
}
