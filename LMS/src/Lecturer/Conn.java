package Lecturer;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class Conn {
    Connection c;
    Statement s;
    public Conn(){
        try{

            c= DriverManager.getConnection("jdbc:mysql:///techlms","root","");
            s=c.createStatement();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
}
