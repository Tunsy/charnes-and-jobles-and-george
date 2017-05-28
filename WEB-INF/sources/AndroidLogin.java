import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import javax.sql.*;
import java.io.IOException;
import javax.servlet.*;
import java.util.*;

public class AndroidLogin extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try{
      // Credential check
      if(email == null || password == null){
        request.setAttribute("login", -1);
      }

      String loginUser = "root";
      String loginPasswd = "122b";
      String loginUrl = "jdbc:mysql://localhost:3306/booksdb";
      Class.forName("com.mysql.jdbc.Driver").newInstance();       
      Connection c = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);      

      String query = "SELECT email, emailpw, id FROM customers WHERE customers.email = ?";
      PreparedStatement statement = c.prepareStatement(query);
      statement.setString(1, email);
      ResultSet rs = statement.executeQuery();

      if (!rs.isBeforeFirst()) {
        request.setAttribute("login", "-1");
      }
      else{
        rs.next();
        if (!password.equals(rs.getString(2))){
          request.setAttribute("login", "-1");
        }
        else{
          request.setAttribute("login", "1");
        }
      }
    }catch(Exception err){

    }
  }
}