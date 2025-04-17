package to;

import javax.swing.*;

public class M_Update {
    JFrame frame;
    private JPanel panel1;

    public M_Update() {
        frame = new JFrame();
        frame.setVisible(true);
        frame.setLocationRelativeTo(null);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setContentPane(panel1);
        frame.setSize(800, 600);
    }
}
