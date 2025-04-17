package to;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class To_Profile {
    private JPanel panel1;
    private JButton EDITFROFILEButton;
    private JButton LOGOUTButton;
    private JButton INSERTButton;
    private JButton UPDATEButton;
    private JButton DELETEButton;
    private JButton DELETEButton1;
    private JButton UPDATEButton1;
    private JButton INSERTButton1;
    private JButton VIEWButton1;
    private JButton VIEWButton;
    private JPanel Main_panel;

    JFrame frame;

    public To_Profile() {
        frame = new JFrame();
        frame.setTitle("TO Profile");
        frame.setContentPane(Main_panel);
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        frame.setSize(900, 600);
        frame.setVisible(true);

        EDITFROFILEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {


            }
        });
    }

    public static void main(String[] args) {
        To_Profile p = new To_Profile();
    }
}
