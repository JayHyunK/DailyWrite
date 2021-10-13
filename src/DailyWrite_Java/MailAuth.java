package DailyWrite_Java;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
 
public class MailAuth extends Authenticator{
    
    PasswordAuthentication pa;
    
    public MailAuth() {
        //String mail_id = "freesky132";
    	String mail_id = "programmer.jonghyun";
    	//String mail_pw = "luvflower_132as";
        String mail_pw = "jaykim3306127";
        
        pa = new PasswordAuthentication(mail_id, mail_pw);
    }
    
    public PasswordAuthentication getPasswordAuthentication() {
        return pa;
    }
}
