package ADMIN;

import MyCon.MyConnection; // connect the connection in the another package access
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.sql.*;
import java.awt.event.*;



public class Course_unit extends JFrame {
    private JPanel rootPanel;
    private JTextField textField1;
    private JTextField textField2;
    private JTextField textField5;
    private JButton addNewCourseButton;
    private JButton updateButton;
    private JButton deleteButton;
    private JButton userButton;
    private JButton courseButton;
    private JButton noticeButton;
    private JButton timetableButton;
    private JButton signOutButton;
    private JTable table1;
    private JComboBox comboBox1;
    private JComboBox comboBox2;
    private JPanel JPanel1;
    private JPanel JPanel2;
    private JScrollPane JScrollPane;

    // main  Constructor
    public Course_unit() {
        setTitle("Course Unit");
        setContentPane(rootPanel);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(1080, 600);

        // combobox set values
        setupComboBoxes();
        setupTable();

        loadCourseData(); // Load the records into the database

        addNewCourseButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                addNewCourseButtonActionPerformed(e);
            }
        });

        updateButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                updateButtonActionPerformed(e);
            }
        });

        deleteButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                deleteButtonActionPerformed(e);
            }
        });


        // navigate the  side buttons
        userButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    new User_profile();
                });
            }
        });

        courseButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                SwingUtilities.invokeLater(() -> {
                    loadCourseData();
                });
            }
        });

        noticeButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    new Notice();
                });
            }
        });


        timetableButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    new Timetable();
                });
            }
        });

        signOutButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    new LoginForm();
                });
            }
        });

        // selected raw data is load to the textfeilds
        table1.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                int selectedRow = table1.getSelectedRow();
                if (selectedRow >= 0) {
                    textField1.setText(table1.getValueAt(selectedRow, 0).toString());
                    textField2.setText(table1.getValueAt(selectedRow, 1).toString());
                    comboBox1.setSelectedItem(table1.getValueAt(selectedRow, 2).toString());
                    comboBox2.setSelectedItem(table1.getValueAt(selectedRow, 3).toString());
                    textField5.setText(table1.getValueAt(selectedRow, 4).toString());
                    textField1.setEditable(false); // prevent changing primary key
                }
            }
        });


        setLocationRelativeTo(null);
        setVisible(true);
    }


    private void setupComboBoxes() {
        // Set valus for c_type combobox
        comboBox1.removeAllItems();
        String[] types = {"TP", "T", "P"};
        for (String type : types) {
            comboBox1.addItem(type);
        }

        comboBox2.removeAllItems();
        String[] credits = {"1", "2", "3"};
        for (String credit : credits) {
            comboBox2.addItem(credit);
        }
    }

    private void setupTable() {
        DefaultTableModel model = new DefaultTableModel(
                new Object[]{"Course ID", "Course Name", "Course Type", "Credit", "Lecturer ID"}, 0);
        table1.setModel(model);
    }

    private Object loadCourseData() {
        DefaultTableModel model = (DefaultTableModel) table1.getModel();
        model.setRowCount(0); // Clear display feilds data


        try (Connection conn = MyConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM course_unit");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                model.addRow(new Object[]{
                        rs.getString("course_code"),
                        rs.getString("name"),
                        rs.getString("type"),
                        rs.getString("credit"),
                        rs.getString("c_lecturer_id")
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

  // use gui
    private void createUIComponents() {
        JPanel1 = new JPanel();
        JPanel2 = new JPanel();
    }

    // insert records in to the database
    private void addNewCourseButtonActionPerformed(ActionEvent evt) {
        String course_code = textField1.getText().trim();
        String name = textField2.getText().trim();
        String type = comboBox1.getSelectedItem().toString();
        String credit = comboBox2.getSelectedItem().toString();
        String lecturer_id = textField5.getText().trim();

        if (course_code.isEmpty() || name.isEmpty() || lecturer_id.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please fill in all required fields.");
            return;
        }else if (!course_code.matches("^ICT\\d{4}$")) {
            JOptionPane.showMessageDialog(this, "Invalid course code format.");
            return;
        }


        char lastDigit =course_code.charAt(course_code.length() - 1);
        String lastDigitStr =String.valueOf(lastDigit);

        if(!lastDigitStr.equals(credit)) {
            JOptionPane.showMessageDialog(this, "The last digit of course code not match the credit value ");
            return;
        }

        String sql = "INSERT INTO course_unit (course_code, name, type, credit, c_lecturer_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = MyConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, course_code);
            pstmt.setString(2, name);
            pstmt.setString(3, type);
            pstmt.setString(4, credit);
            pstmt.setString(5, lecturer_id);

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
//                JOptionPane.showMessageDialog(this, "New course added successfully.");
                loadCourseData();
                clearFields();
            } else {
                JOptionPane.showMessageDialog(this, "Failed to add course.");
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error: LEC id is not initilize in DB" );
            e.printStackTrace();
        }
    }

    private void updateButtonActionPerformed(ActionEvent evt) {
        String course_code = textField1.getText().trim();
        String name = textField2.getText().trim();
        String type = comboBox1.getSelectedItem().toString();
        String credit = comboBox2.getSelectedItem().toString();
        String lecturer_id = textField5.getText().trim();

        if (course_code.isEmpty() ) {
            JOptionPane.showMessageDialog(this, "Select a course to update.");
            return;
        }

        String sql = "UPDATE course_unit SET name = ?, type = ?, credit = ?, c_lecturer_id = ? WHERE course_code = ?";

        try (Connection conn = MyConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {


            pstmt.setString(1, name);
            pstmt.setString(2, type);
            pstmt.setString(3, credit);
            pstmt.setString(4, lecturer_id);
            pstmt.setString(5, course_code);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                JOptionPane.showMessageDialog(this, "Course updated successfully.");
                loadCourseData();
                clearFields();
            } else {
                JOptionPane.showMessageDialog(this, "Update failed.L");
            }

        }catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error: "+ e.getMessage());
            e.printStackTrace();
        }
    }

    private void deleteButtonActionPerformed(ActionEvent evt) {
        String course_code = textField1.getText().trim();

        if (course_code.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Select a course to delete.");
            return;
        }

        int confirm = JOptionPane.showConfirmDialog(this, "Are you sure you want to delete this course?",
                "Confirm Delete", JOptionPane.YES_NO_OPTION);
        if (confirm != JOptionPane.YES_OPTION) return;

        String sql = "DELETE FROM course_unit WHERE course_code = ?";

        try (Connection conn = MyConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, course_code);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                JOptionPane.showMessageDialog(this, "Course deleted successfully.");
                loadCourseData();
                clearFields();
            } else {
                JOptionPane.showMessageDialog(this, "Delete failed.");
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void clearFields() {
        textField1.setText("");
        textField2.setText("");
        textField5.setText("");
        comboBox1.setSelectedIndex(0);
        comboBox2.setSelectedIndex(0);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new Course_unit();
        });

    }

}