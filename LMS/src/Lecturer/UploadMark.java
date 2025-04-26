package Lecturer;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class UploadMark extends JFrame {
    private JButton btnCaMark;
    private JButton btnFinalMark;
    private JButton btnBack;
    private JButton btnExit;
    private JPanel MarkUpload;
    private String user_id;
    private String password;

    public UploadMark(String user_id,String password) {


        this.user_id = user_id;
         this.password = password;

        setTitle("|LectureDashBord|UploadMark|");
        setContentPane(MarkUpload);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);
        setVisible(true);
        btnBack.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
//                String User_id=new LectureDashBord().getUser_id();
//                String Password=new LectureDashBord().getPassword();
                new LectureDashBord(user_id,password).setVisible(true);
            }
        });
        btnCaMark.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new CAMARKN(user_id,password).setVisible(true);
            }
        });
        btnFinalMark.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new FinalMark(user_id,password).setVisible(true);
            }
        });
        btnExit.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });

    }

    public static void main(String[] args) {
       new UploadMark("LEC004"," pass123").setVisible(true);
    }
}
