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
    private String password;

    public ViewUndergraduate(String user_id,String password) {
    this.user_id = user_id;
    this.password = password;
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

        btnAttendence.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
              setVisible(false);
              new Attendance(user_id,password).setVisible(true);
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
                new UndergraduateGrades(user_id,password).setVisible(true);
            }
        });
        btnDetails.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new UndergraduateDetails(user_id,password).setVisible(true);
            }
        });
        btnBack.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);

                new LectureDashBord(user_id,password).setVisible(true);
            }
        });
        btnMedical.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                new Medical(user_id,password).setVisible(true);
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
        new ViewUndergraduate(""," ").setVisible(true);
    }
}
