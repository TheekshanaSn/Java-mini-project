package to;

import ADMIN.Notice;
import ADMIN.Timetable;
import Medical.Medical;
import MyCon.MyConnection;
import attendance.Attendance;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

//import static sun.tools.jconsole.inspector.XDataViewer.dispose;

//import static sun.tools.jconsole.inspector.XDataViewer.dispose;

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
    private JButton A_VIEWButton2;
    private JButton M_VIEWButton;
    private JPanel A_VIEWButton;

    JFrame frame;

    public To_Profile() {
        frame = new JFrame();
        frame.setTitle("TO Profile");
        frame.setContentPane(Main_panel);
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        frame.setSize(1080, 600);
        frame.setVisible(true);
        frame.setResizable(false);


        EDITFROFILEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                frame.dispose();
                TO_Profile_Update frame = new TO_Profile_Update();



            }
        });
        INSERTButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                frame.dispose();
                A_Insert frame = new A_Insert();

            }
        });
        UPDATEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
               A_Update frame = new A_Update();

            }
        });
        DELETEButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                A_Delete frame = new A_Delete();
            }
        });
        INSERTButton1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                M_Insert frame = new M_Insert();
            }
        });
        UPDATEButton1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                M_Update frame = new M_Update();
            }
        });
        DELETEButton1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                M_Delete frame = new M_Delete();
            }
        });
        VIEWButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                // Notice page view
            }
        });
        VIEWButton1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                //time table view
            }
        });

        A_VIEWButton2.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

               frame.dispose();
                Attendance attendance = new Attendance();

            }
        });

        M_VIEWButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                frame.dispose();
                Medical medical = new Medical();
            }
        });
        //see the notice
        VIEWButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                Notice notice = new Notice();
            }
        });

        //see the Time table
        VIEWButton1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.dispose();
                Timetable timetable = new Timetable();
            }
        });
    }



    public static void main(String[] args) {
        To_Profile p = new To_Profile();
    }
}
