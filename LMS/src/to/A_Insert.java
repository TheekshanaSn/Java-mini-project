package to;

import javax.swing.*;

public class A_Insert {
    private JPanel panel1;
    private JButton button1;

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
