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
    	
      String loginUser = "root";
	  String loginPasswd = "122b";
	  String loginUrl = "jdbc:mysql://localhost:3306/booksdb";
	  Class.forName("com.mysql.jdbc.Driver").newInstance();       
	  Connection c = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);      
	  PrintWriter out = response.getWriter();
      
    	//String searchQuery = request.getParameter("search").trim();
      
      
      /*String query = "SELECT * FROM book WHERE title = ?";
      PreparedStatement statement = c.prepareStatement(query);
      statement.setString(1, searchQuery);
      ResultSet rs = statement.executeQuery();
      */
	  
	  String str = request.getParameter("search").trim();
	  if (str != null && !str.equals("")){
			String[] searchstrings = str.split("\\s+");
			String query = "SELECT DISTINCT(title) FROM book WHERE MATCH (title) AGAINST (? IN BOOLEAN MODE) LIMIT 5;";
			
			//out.println(query);
			PreparedStatement pstatement = c.prepareStatement(query);
			
			String input = "";
			int searchstringIndex;
			for (searchstringIndex = 0; searchstringIndex < searchstrings.length - 1; searchstringIndex++){
				input += "+" + searchstrings[searchstringIndex] + " ";
			}
			input += "+" + searchstrings[searchstringIndex] + "*";
			
			pstatement.setString(1, input);
			//out.println(pstatement);
			ResultSet rs = pstatement.executeQuery();
			String writeOutput = "";


			String bookOutput = "";
			bookOutput += "titles:[";
	            
	
	       int count = 0;
	       while(rs.next()){
	    	   bookOutput += "\"" + rs.getString("title") + "\", ";
	    	   count++;
	       }
	       
	
	       if(count != 0){
	    	   bookOutput = bookOutput.substring(0, bookOutput.length() - 2);
	       }
	       bookOutput += "]";
	       out.print(bookOutput);
	  }

    }catch(Exception err){

    }
  }
}