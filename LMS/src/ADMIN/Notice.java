package ADMIN;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.table.DefaultTableModel;

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


    public Notice() {
        setTitle("Notice");
        setContentPane(JPanelMain);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);

        // Update table model after form initialization
        DefaultTableModel model = new DefaultTableModel(new Object[]{"Notice Content"}, 0);
        table1.setModel(model);

        // Add some sample data
        model.addRow(new Object[]{"round"});
        model.addRow(new Object[]{"square"});

        setVisible(true); // Center the window
    }

    public static void main(String[] args) {

        Notice n= new Notice();
    }
}
