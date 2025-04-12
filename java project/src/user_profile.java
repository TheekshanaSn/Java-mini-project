import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;

//public class user_profile {
//    private JButton userButton;
//    private JButton courseButton;
//    private JButton noticeButton;
//    private JButton timetableButton;
//    private JPanel JPanel1;
//    private JPanel JPanelMain;
//    private JPanel JPanel2;
//    private JButton undegraduateButton;
//    private JButton lecturerButton;
//    private JButton technicalOfficerButton;
//    private JButton addNewButton;
//    private JButton singOutButton;
//    private JTable table1;

//    private void createUIComponents() {
//        // TODO: place custom component creation code here
//
//
//    }

    public class user_profile {
        private JButton userButton;
        private JButton courseButton;
        private JButton noticeButton;
        private JButton timetableButton;
        private JPanel JPanel1;
        private JPanel JPanelMain;
        private JPanel JPanel2;
        private JButton undegraduateButton;
        private JButton lecturerButton;
        private JButton technicalOfficerButton;
        private JButton addNewButton;
        private JButton singOutButton;
        private JTable table1;

        public static void main(String[] args) {
            JFrame frame = new JFrame("User Profile");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.getContentPane().setLayout(new BorderLayout());

        }

        private void createUIComponents() {
            // Initialize the JTable - this is called before the form's auto-generated setup code
            table1 = new JTable();
        }

        public user_profile() {
            // This constructor is called after the form's auto-generated setup code
            initTableColumns();
        }

        private void initTableColumns() {
            // Create a table model with your desired columns
            DefaultTableModel model = new DefaultTableModel();

            // Add the columns
            model.addColumn("table1");
            model.addColumn("JTable");
            model.addColumn("id");
            model.addColumn("name");

            // Add sample data row
            model.addRow(new Object[]{"square", "", "", ""});

            // Set the model to the table
            table1.setModel(model);
        }
    }

