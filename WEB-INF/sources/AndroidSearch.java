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

public class AndroidSearch extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    try{
      String searchQuery = request.getParameter("search");
      PrintWriter out = response.getWriter();
      out.print("1");

      String loginUser = "root";
      String loginPasswd = "122b";
      String loginUrl = "jdbc:mysql://localhost:3306/booksdb";
      Class.forName("com.mysql.jdbc.Driver").newInstance();       
      Connection c = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);      
      String query = "SELECT * FROM book WHERE title = ?";
      PreparedStatement statement = c.prepareStatement(query);
      statement.setString(1, searchQuery);
      ResultSet rs = statement.executeQuery();
      out.print("2");


      String bookOutput = "";
      bookOutput += "[";
            out.print("3");

      int count = 0;
      while(rs.next()){
          bookOutput += "\"" + rs.getString("title") + "\", ";
          count++;
      }
      out.print("4");

      if(count != 0){
          bookOutput = bookOutput.substring(0, bookOutput.length() - 2);
      }
      bookOutput += "]";
      out.print(bookOutput);

    }catch(Exception err){

    }
  }
}