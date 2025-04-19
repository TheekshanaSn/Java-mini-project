package to;

import javax.swing.*;

public class A_Insert {
    private JPanel panel1;
    private JButton button1;
    private JButton button2;
    private JTextField textField1;
    private JTextField textField2;
    private JTextField textField3;
    private JComboBox comboBox1;
    private JTextField textField4;
    private JComboBox comboBox2;
    private JTextField textField5;
    private JSpinner spinner1;
    private JTextField textField6;

    JFrame frame;
    public A_Insert() {

            frame = new JFrame();
            frame.setVisible(true);
            frame.setLocationRelativeTo(null);
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setContentPane(panel1);
            frame.setSize(800, 600);
    }
}
