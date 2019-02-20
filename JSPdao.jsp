Index.jsp:

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>CRUD Home</title>
</head>
<body>
    <h1 align="center">CRUD Using JSP & DAO</h1>
    <a href="Insert.jsp">Insert</a> &nbsp; <a href="Read.jsp">Read</a>
</body>
</html>

EmployeeBean.java:

package com.cognizant.bean;
import java.math.BigDecimal;
import java.math.BigInteger;

public class EmployeeBean {
private int empId;
private String empName;
private String email;
private Long mobile;
public String getEmail() {
       return email;
}
public void setEmail(String email) {
       this.email = email;
}
public int getEmpId() {
       return empId;
}
public void setEmpId(int empId)
{
       this.empId=empId;
       }
public String getEmpName() {
       return empName;
}
public void setEmpName(String empName) {
       this.empName = empName;
}
public Long getMobile() {
       return mobile;
}
public void setMobile(Long mobile) {
       this.mobile = mobile;
}
}


EmployeeDAO.java:

package com.cognizant.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.cognizant.bean.EmployeeBean;

public class EmployeeDAO  {
       public static Connection Connect() throws Exception{
              Connection conn=null;
              Class.forName("com.mysql.jdbc.Driver");
              conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");
              return conn;
       }
public int insert(EmployeeBean emp) throws Exception {
       Connection conn=Connect();
       String insertQuery="insert into employee values(?,?,?,?)";
       PreparedStatement pstmt=conn.prepareStatement(insertQuery);
       pstmt.setInt(1, emp.getEmpId());
       pstmt.setString(2, emp.getEmpName());
       pstmt.setString(3,emp.getEmail());
       pstmt.setBigDecimal(4, BigDecimal.valueOf(emp.getMobile()));
       int insertStatus=0;
       insertStatus=pstmt.executeUpdate();
       return insertStatus;
}
public int delete(int empId) throws Exception {
       Connection conn=Connect();
       String deleteQuery="delete from employee where emp_id="+empId;
       Statement stmt=conn.createStatement();
       int deleteStatus=0;
       deleteStatus=stmt.executeUpdate(deleteQuery);
return deleteStatus;
}
public int update(EmployeeBean emp) throws Exception {
       Connection conn=Connect();
       String insertQuery="update employee set emp_name=?,email=?,mobile=? where emp_id=?";
       PreparedStatement pstmt=conn.prepareStatement(insertQuery);
       pstmt.setInt(4, emp.getEmpId());
       pstmt.setString(1, emp.getEmpName());
       pstmt.setString(2,emp.getEmail());
       pstmt.setBigDecimal(3, BigDecimal.valueOf(emp.getMobile()));
       int updateStatus=0;
       updateStatus=pstmt.executeUpdate();
return updateStatus;
}
public EmployeeBean read(int empId) throws Exception {
       Connection conn=Connect();
       String readQuery="select * from employee where emp_id"+empId;
       Statement stmt=conn.createStatement();
       ResultSet rs=stmt.executeQuery(readQuery);
       EmployeeBean emp=new EmployeeBean();
       if(rs.next())
       {emp.setEmpId(rs.getInt(1));
       emp.setEmpName(rs.getString(2));
       emp.setEmail(rs.getString(3));
       emp.setMobile(rs.getLong(4));}

return emp;
}
public List<EmployeeBean> readAll() throws Exception{
       
       List<EmployeeBean> empList=new ArrayList<EmployeeBean>();
       Connection conn=Connect();
       String readQuery="select * from employee";
       Statement stmt=conn.createStatement();
       ResultSet rs=stmt.executeQuery(readQuery);
       
       while(rs.next())
       {
       EmployeeBean emp=new EmployeeBean();
       emp.setEmpId(rs.getInt(1));
       emp.setEmpName(rs.getString(2));
       emp.setEmail(rs.getString(3));
       emp.setMobile(rs.getLong(4));
       empList.add(emp);
       }
       return empList;
}
}


Insert.jsp:
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
                           <td>empId:</td>
                           <td><input type="number" name="empId" required="required"></td>
                     </tr>
                     <tr>
                           <td>empname:</td>
                           <td><input type="text" name="empName" required="required"></td>
                     </tr>
                     <tr>
                           <td>email:</td>
                           <td><input type="email" name="email" required="required"></td>
                     </tr>
                     <tr>
                           <td>mobile:</td>
                           <td><input type="tel" name="mobile" required="required"></td>
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


<%@page import="com.cognizant.bean.EmployeeBean"%>
<%@page import="com.cognizant.dao.EmployeeDAO"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%try{
EmployeeDAO empDAO=new EmployeeDAO();
EmployeeBean emp=new EmployeeBean();
emp.setEmpId(Integer.parseInt(request.getParameter("empId")));
emp.setEmpName(request.getParameter("empName"));
emp.setMobile(Long.parseLong(request.getParameter("mobile")));
emp.setEmail(request.getParameter("email"));
int insertStatus=0;
insertStatus =empDAO.insert(emp);
if(insertStatus==0)
       out.println("Error while inserting");
else
       response.sendRedirect("Read.jsp");
}
catch(Exception e){
       out.println(e.getMessage());
}
%>
</body>
</html>

Read.jsp:

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.cognizant.dao.EmployeeDAO"%>
<%@page import="com.cognizant.bean.EmployeeBean"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
       pageEncoding="ISO-8859-1"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Read Page</title>
</head>
<body>
       <%
              try {
                     EmployeeDAO empDAO = new EmployeeDAO();
                     
                     List<EmployeeBean> empList = new ArrayList<EmployeeBean>();
                     empList = empDAO.readAll();
                     
       %>
       <table>
              <tr>
                     <th>ID</th>
                     <th>EmpName</th>
                     <th>Email</th>
                     <th>Mobile</th>
                     <th>Actions</th>
                     </tr>
       
       <%for (EmployeeBean emp : empList) { %>
       <tr>
       <td><%=emp.getEmpId()%></td> 
       <td><%=emp.getEmpName()%></td> 
       <td><%=emp.getEmail()%></td> 
       <td><%=emp.getMobile()%></td> 
       <td><a href="edit.jsp?emp_Id=<%=emp.getEmpId() %>">Edit </a>|<a href="delete.jsp?emp_Id=<%=emp.getEmpId() %>">Delete</a></td>
              </tr>
       
       <%
              }
                     out.println("</table>");
              } catch (Exception e) {
                     out.println(e.getMessage());
              }
       %>
</body>
</html>


Delete.jsp:

<%@page import="com.cognizant.bean.EmployeeBean"%>
<%@page import="com.cognizant.dao.EmployeeDAO"%>
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
try{EmployeeDAO empDAO=new EmployeeDAO();
EmployeeBean emp=new EmployeeBean();
int status=0;
status=empDAO.delete(Integer.parseInt(request.getParameter("emp_Id")));
if(status==0)
       out.println("Error while inserting");
else
       response.sendRedirect("Read.jsp");
}
catch(Exception e){
       out.println(e.getMessage());
}
%>
</body>
</html>

Edit.jsp:

<%@page import="com.cognizant.dao.EmployeeDAO"%>
<%@page import="com.cognizant.bean.EmployeeBean"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
       <center>
              <h1>UPDATE Record</h1>
       </center>
       <a href="index.jsp">HOME</a>
       <form action=editAction.jsp>
       <% 
       EmployeeDAO empDAO=new EmployeeDAO();
       EmployeeBean emp=new EmployeeBean();
       empDAO.read(Integer.parseInt(request.getParameter("emp_id")));
       %>
              <table border='1'>
                     <tr>
                           <th>Column Name</th>
                           <th>Value</th>
                     </tr>
                     <tr>
                           <td>empId:</td>
                           <td><input type="number" name="empId" value="<%=emp.getEmpId()%>"readonly="readonly"></td>
                     </tr>
                     <tr>
                           <td>empname:</td>
                           <td><input type="text" name="empName" value="<%=emp.getEmpName()%>"></td>
                     </tr>
                     <tr>
                           <td>email:</td>
                           <td><input type="email" name="email" value="<%=emp.getEmail()%>"></td>
                     </tr>
                     <tr>
                           <td>mobile:</td>
                           <td><input type="tel" name="mobile" value="<%=emp.getMobile()%>"></td>
                     </tr>
                     <tr>
                           <td><input type="reset" value="Clear"></td>
                           <td><input type="submit" value="Insert"></td>
                     </tr>

              </table>
       </form>
</body>
</html>

editAction.jsp:


<%@page import="com.cognizant.dao.EmployeeDAO"%>
<%@page import="com.cognizant.bean.EmployeeBean"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Action</title>
</head>
<body>
<%try{
EmployeeDAO empDAO=new EmployeeDAO();
EmployeeBean emp=new EmployeeBean();
emp.setEmpId(Integer.parseInt(request.getParameter("emp_Id")));
emp.setEmpName(request.getParameter("empName"));
emp.setMobile(Long.parseLong(request.getParameter("mobile")));
emp.setEmail(request.getParameter("email"));
int Status=0;
Status =empDAO.update(emp);
if(Status==0)
       out.println("Error while inserting");
else
       response.sendRedirect("Read.jsp");
}
catch(Exception e){
       out.println(e.getMessage());
}
%>
</body>
</html>
