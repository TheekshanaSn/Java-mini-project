package ADMIN;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.sql.*;
import java.awt.event.*;

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
    private JTextField textField1;
    private JTextField textField2;
    private JTextField textField3;

    public Notice() {
        setTitle("Notice");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);

        setupTable();
        loadNotices();

        userButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    User_profile userProfile = new User_profile();
                });
            }
        });

        courseButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                new Course_unit();
            }
        });

        noticeButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                SwingUtilities.invokeLater(() -> {
                   loadNotices();
                });
            }
        });

        timetableButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    Timetable timetable = new Timetable();
                });
            }
        });

        singOutButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose();
                SwingUtilities.invokeLater(() -> {
                    LoginForm loginForm = new LoginForm();
                });
            }
        });

        table1.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                int row = table1.getSelectedRow();
                if (row >= 0) {
                    textField3.setText(table1.getValueAt(row, 0).toString());
                    textField1.setText(table1.getValueAt(row, 1).toString());
                    textField2.setText(table1.getValueAt(row, 2).toString());
                }
            }
        });

        // Search by ID
        textField3.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String idText = textField3.getText().trim();
                if (!idText.isEmpty()) {
                    try {
                        int id = Integer.parseInt(idText);
                        loadNoticeById(id);
                    } catch (NumberFormatException ex) {
                        JOptionPane.showMessageDialog(Notice.this,
                                "Please enter a valid numeric ID",
                                "Invalid Input",
                                JOptionPane.ERROR_MESSAGE);
                    }
                }
            }
        });

        addNewButton.addActionListener(e -> {
            String title = textField1.getText().trim();
            String content = textField2.getText().trim();

            if (title.isEmpty() || content.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please fill in all fields.");
                return;
            }

            try (Connection conn = DatabaseConnect.getConnection()) {
                int id = 1;
                PreparedStatement findMissingID = conn.prepareStatement(
                        "SELECT t1.notice_id + 1 AS missing_id " +
                                "FROM notice t1 " +
                                "LEFT JOIN notice t2 ON t1.notice_id + 1 = t2.notice_id " +
                                "WHERE t2.notice_id IS NULL " +
                                "AND t1.notice_id + 1 NOT IN (SELECT MAX(notice_id) FROM notice) " +
                                "ORDER BY t1.notice_id LIMIT 1"
                );
                ResultSet rs = findMissingID.executeQuery();

                if (rs.next()) {
                    id = rs.getInt("missing_id");
                } else {
                    // If no missing IDs, use max(notice_id) + 1
                    PreparedStatement getMaxID = conn.prepareStatement("SELECT IFNULL(MAX(notice_id), 0) + 1 AS next_id FROM notice");
                    ResultSet rsMax = getMaxID.executeQuery();
                    if (rsMax.next()) {
                        id = rsMax.getInt("next_id");
                    }
                }

                PreparedStatement stmt = conn.prepareStatement("INSERT INTO notice (notice_id, title, content) VALUES (?, ?, ?)");
                stmt.setInt(1, id);
                stmt.setString(2, title);
                stmt.setString(3, content);
                stmt.executeUpdate();

                JOptionPane.showMessageDialog(this, "Notice added successfully with ID: " + id);
                loadNotices();
                clearFields();

            } catch (SQLException ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        });

        updateButton.addActionListener(e -> {
            String idText = textField3.getText().trim();
            if (idText.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please enter or select a notice ID to update.");
                return;
            }

            try {
                int id = Integer.parseInt(idText);
                String title = textField1.getText().trim();
                String content = textField2.getText().trim();

                if (title.isEmpty() || content.isEmpty()) {
                    JOptionPane.showMessageDialog(this, "Title and content cannot be empty.");
                    return;
                }

                try (Connection conn = DatabaseConnect.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(
                             "UPDATE notice SET title = ?, content = ? WHERE notice_id = ?")) {

                    stmt.setString(1, title);
                    stmt.setString(2, content);
                    stmt.setInt(3, id);
                    int affected = stmt.executeUpdate();

                    if (affected > 0) {
                        JOptionPane.showMessageDialog(this, "Notice updated successfully.");
                        loadNotices();
                        clearFields();
                    } else {
                        JOptionPane.showMessageDialog(this, "No notice found with ID: " + id);
                    }

                } catch (SQLException ex) {
                    ex.printStackTrace();
                    JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
                }
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(this, "Please enter a valid numeric ID");
            }
        });

        // Delete notice
        deleteButton.addActionListener(e -> {
            String idText = textField3.getText().trim();
            if (idText.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please enter or select a notice ID to delete.");
                return;
            }

            try {
                int id = Integer.parseInt(idText);

                int confirm = JOptionPane.showConfirmDialog(this,
                        "Are you sure you want to delete Notice with ID: " + id + "?",
                        "Confirm Delete", JOptionPane.YES_NO_OPTION);
                if (confirm != JOptionPane.YES_OPTION) return;

                try (Connection conn = DatabaseConnect.getConnection();
                     PreparedStatement stmt = conn.prepareStatement("DELETE FROM notice WHERE notice_id = ?")) {

                    stmt.setInt(1, id);
                    int affected = stmt.executeUpdate();

                    if (affected > 0) {
                        JOptionPane.showMessageDialog(this, "Notice deleted successfully.");
                        loadNotices();
                        clearFields();
                    } else {
                        JOptionPane.showMessageDialog(this, "No notice found with ID: " + id);
                    }

                } catch (SQLException ex) {
                    ex.printStackTrace();
                    JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
                }
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(this, "Please enter a valid numeric ID");
            }
        });

        setLocationRelativeTo(null);
        setVisible(true);
    }

    private void loadNoticeById(int id) {
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM notice WHERE notice_id = ?")) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                textField1.setText(rs.getString("title"));
                textField2.setText(rs.getString("content"));


                DefaultTableModel model = (DefaultTableModel) table1.getModel();
                for (int i = 0; i < model.getRowCount(); i++) {
                    if (Integer.parseInt(model.getValueAt(i, 0).toString()) == id) {
                        table1.setRowSelectionInterval(i, i);
                        break;
                    }
                }

            } else {
                JOptionPane.showMessageDialog(this,
                        "No notice found with ID: " + id,
                        "Notice Not Found",
                        JOptionPane.INFORMATION_MESSAGE);
                clearFields();
                textField3.setText(String.valueOf(id)); // Keep the ID for potential new entry
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    "Error loading notice: " + ex.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void setupTable() {
        DefaultTableModel model = new DefaultTableModel(new Object[]{"Id", "Title", "Content"}, 0);
        table1.setModel(model);
    }

    private void loadNotices() {
        DefaultTableModel model = (DefaultTableModel) table1.getModel();
        model.setRowCount(0);

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
                    "Error loading notice data: " + ex.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void clearFields() {
        textField3.setText("");
        textField1.setText("");
        textField2.setText("");
        table1.clearSelection();
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new Notice());
    }
}