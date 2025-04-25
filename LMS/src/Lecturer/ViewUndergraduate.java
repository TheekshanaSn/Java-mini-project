package Lecturer;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class ViewUndergraduate extends JFrame {
    private JButton btnGrade;
    private JButton btnDetails;
    private JButton btnAttendence;
    private JButton btnMedical;
    private JButton btnBack;
    private JButton btnExit;
    private JPanel View;
    private String user_id;

    public ViewUndergraduate(String user_id) {
    this.user_id = user_id;
        setTitle("|LectureDashBord|UploadMark|");
        setContentPane(View);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);
        setVisible(true);

        btnGrade.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

            }
        });
        btnDetails.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

            }
        });
        btnAttendence.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

            }
        });
        btnMedical.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

            }
        });
        btnGrade.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new UndergraduateGrades().setVisible(true);
            }
        });
        btnDetails.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new UndergraduateDetails().setVisible(true);
            }
        });
        btnBack.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                String User_id=new LectureDashBord().getUser_id();
                String Password=new LectureDashBord().getPassword();
                new LectureDashBord(User_id,Password).setVisible(true);
            }
        });
    }

    public static void main(String[] args) {
        new ViewUndergraduate("").setVisible(true);
    }
}
