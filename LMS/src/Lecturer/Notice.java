package Lecturer;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class Notice extends JFrame {
    private JTextArea taDisplayNotice;
    private JTable tblNotice;
    private JButton btnBack;
    private JButton btnExit;
    private JPanel notice;
    private Map<String, String> noticeContents;
    private String user_id;
    private String password;

    public Notice(String user_id,String password) {
        this.user_id = user_id;
        this.password = password;

        noticeContents = new HashMap<>();



        btnExit.addActionListener(e -> System.exit(0));


        tblNotice.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                int row = tblNotice.getSelectedRow();
                if (row >= 0) {
                    String noticeId = tblNotice.getValueAt(row, 0).toString();

                    displayNoticeContent(noticeId);
                }
            }
        });

        LoadNoticeTable();
        setTitle("Notices");
        setContentPane(notice);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);
        setVisible(true);

        btnBack.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);

                new LectureDashBord(user_id,password).setVisible(true);
            }
        });
    }

    public void LoadNoticeTable() {
        PreparedStatement pst;
        try {
            Conn conn = new Conn();
            pst = conn.c.prepareStatement("SELECT * FROM Notice");
            ResultSet rs = pst.executeQuery();

            DefaultTableModel model = new DefaultTableModel(
                    new String[]{"Notice ID", "Title"}, 0
            );

            while (rs.next()) {
                String id = rs.getString("notice_id");
                String title = rs.getString("title");
                String content = rs.getString("content");

                // Store the content in the map
                noticeContents.put(id, content);

                model.addRow(new Object[]{id, title});
            }
            tblNotice.setModel(model);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void displayNoticeContent(String noticeId) {

        String content = noticeContents.get(noticeId);
        if (content != null) {
            taDisplayNotice.setText(content);
        } else {
            taDisplayNotice.setText("No content available for this notice.");
        }
    }

    public static void main(String[] args) {
        new Notice("","");
    }
}