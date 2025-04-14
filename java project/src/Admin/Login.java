package Admin;

import javax.swing.*;

public class Login extends JFrame {
    private JPanel JPanelM;
    private JTextField textField1;
    private JTextField textField2;
    private JButton loginButton;
    private JButton cancelButton;
    private JPanel JPanel1;
    private JPanel JPanel2;


    public Login() {
        setTitle("Login");
        setContentPane(JPanelM);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(900, 600);
        setVisible(true); // Center the window
    }

    public static void main(String[] args) {
       Login log = new Login();
    }


}
