index.jsp:

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>CRUD Home</title>
</head>
<body>
    <h1 align="center">CRUD Using JSP</h1>
    <a href="Insert.jsp">Insert</a> &nbsp; <a href="Read.jsp">Read</a>
</body>
</html>

Read.jsp:

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Table Content</title>
</head>
<body>
	<a href="index.jsp">HOME</a>
	<center>
		<h1>Student_Detail Table Content</h1>
	</center>
	<table border='1'>
		<tr>
		    <th>S.No</th>
			<th>Student_Name</th>
			<th>Branch_Name</th>
			<th>College_Name</th>
			<th>Actions</th>
		</tr>
		<tr>
			<%
				try {
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");
					Statement stmt = conn.createStatement();
					ResultSet rs = stmt.executeQuery("select * from studentdetail");
					int i=1;

					while (rs.next()) {
			%>
             <td><%=i++ %></td>
			<td><%=rs.getString(1)%></td>
			<td><%=rs.getString(2)%></td>
			<td><%=rs.getString(3)%></td>
			<td><a href="Edit.jsp?studentname=<%=rs.getString(1) %>">Edit </a>|<a href="Delete.jsp"><a href="Delete.jsp?studentname=<%=rs.getString(1) %>"> Delete</a></td>
		</tr>

		<%
			}
				rs.close();
				stmt.close();
				conn.close();
		%>
	</table>
	<%
		}catch (Exception e) {
			out.println(e.getMessage());
		}
	%>
</body>
</html>

Delete.jsp:

<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Delete Page</title>
</head>
<body>
<%
try {
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");
	String str=request.getParameter("studentname");
	Statement stmt = conn.createStatement();
	int deletestatus=0;
	deletestatus=stmt.executeUpdate("delete from studentdetail where studentname='"+str+"'");
	if(deletestatus==0)
		out.println("Error while deleting the content");
	else
		response.sendRedirect("Read.jsp");
	
	}catch(Exception e)
{
		out.print(e.getMessage());}

%>
</body>
</html>

insert.jsp:


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html ">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert Page</title>
</head>
<body>
	<center>
		<h1>ADD a New Record</h1>
	</center>
	<a href="index.jsp">HOME</a>
	<form action=insertaction.jsp>
		<table border='1'>
			<tr>
				<th>Column Name</th>
				<th>Value</th>
			</tr>
			<tr>
				<td>studentname:</td>
				<td><input type="text" name="sname" required="required"></td>
			</tr>
			<tr>
				<td>collegename</td>
				<td><input type="text" name="cname" required="required"></td>
			</tr>
			<tr>
				<td>deptname</td>
				<td><input type="text" name="dname" required="required"></td>
			</tr>
			<tr>
				<td><input type="reset" value="Clear"></td>
				<td><input type="submit" value="Insert"></td>
			</tr>

		</table>
	</form>
</body>
</html>

insertAction.jsp:

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");
			String str = "insert into studentdetail values(?,?,?)";
			String sname = request.getParameter("sname");
			String dname = request.getParameter("dname");
			String cname = request.getParameter("cname");
			PreparedStatement stmt = conn.prepareStatement(str);
			stmt.setString(1, sname);
			stmt.setString(2, dname);
			stmt.setString(3, cname);
			int insertStatus;
			insertStatus = stmt.executeUpdate();
			if (insertStatus == 0)
				out.println("Error while inserting the content");
			else
				response.sendRedirect("Read.jsp");

		} catch (Exception e) {
			out.print(e.getMessage());
		}
	%>
</body>
</html>

Edit.jsp:

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Update Page</title>
</head>
<body>
<center>
		<h1>Edit Record</h1>
	</center>
	<a href="index.jsp">HOME</a>
	<form action=editaction.jsp>
		<table border='1'>
			<tr>
				<th>Column Name</th>
				<th>Value</th>
			</tr>
				<%
				String sname=request.getParameter("studentname");
				try {
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");
					String s="select * from studentdetail where studentname='"+sname+"'";
					PreparedStatement stmt = conn.prepareStatement(s);
					ResultSet rs = stmt.executeQuery();
					int i=1;

					if(rs.next()) {
		
			
		%>
			<tr>
				<td>studentname:</td>
				<td><input type="text" name="sname" value="<%=rs.getString(1)%>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>collegename</td>
				<td><input type="text" name="cname" value="<%=rs.getString(2)%>"></td>
			</tr>
			<tr>
				<td>deptname</td>
				<td><input type="text" name="dname" value="<%=rs.getString(3)%>"></td>
			</tr>
			<tr>
				<td><input type="reset" value="Clear"></td>
				<td><input type="submit" value="Insert"></td>
			</tr>
			</table>
			<%
			}
				rs.close();
				stmt.close();
				conn.close();
		%>

		
		<%
		}catch (Exception e) {
			out.println(e.getMessage());
		}
	%>
	</form>
</body>
</html>

editAction.jsp:

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Action</title>
</head>
<body>
	<%
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");
			String str = "update studentdetail set deptname=?,collegename=? where studentname=?";
			String sname = request.getParameter("sname");
			String dname = request.getParameter("dname");
			String cname = request.getParameter("cname");
			PreparedStatement stmt = conn.prepareStatement(str);
			stmt.setString(3, sname);
			stmt.setString(1, dname);
			stmt.setString(2, cname);
			int insertStatus;
			insertStatus = stmt.executeUpdate();
			if (insertStatus == 0)
				out.println("Error while inserting the content");
			else
				response.sendRedirect("Read.jsp");

		} catch (Exception e) {
			out.print(e.getMessage());
		}
	%>
</body>
</html>
