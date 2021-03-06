<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@page import="com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array"%>
<%@page import="com.sun.org.apache.xpath.internal.functions.Function"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>New Train Information</title>
<meta name="keywords" content="Home" />
<link href="./css/templatemo_style.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.ennui.contentslider.css" rel="stylesheet" type="text/css" media="screen,projection" />


<%! 
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	
	
	public void jspInit(){
		try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/train","root","");
		}
		catch(Exception e ){
			e.printStackTrace();
		}
		}
%>


<script type="text/javascript">

// validation of empty, min and max limits for the inputs specified 
function validate(){

	if(document.form1.tname.value == "" ){
		alert("Event Name Cannot be left blank");
		document.form1.tname.focus();
		document.form1.tname.select();
		return;
	}

	var len = 0;
	for(var i=0; i < document.form1.days.length; i++){
		if(document.form1.days[i].checked)
			len = len +1;
		}
		if(len == 0){
			alert("Specify the days of departure for the Event");
			document.form1.days[0].focus();
			return;
		}
}
</script>
	
<!-- Input Validation Script -->
<script type="text/javascript" src="InputValidation.js">
</script>
		<!-- Special Font & Symbol -->	
   <script src="https://code.jquery.com/jquery-3.3.1.js"></script>
	
	
<script> 
    $(function(){
      $("#header").load("header.html"); 
    });
    </script>
	
		<script> 
    $(function(){
      $("#footer").load("footer.html"); 
    });
    </script>
	
</head>
<body>

<div id="templatemo_wrapper">

	<div id="templatemo_header">
		
		<div id="site_title">
            <h1><a href="home.jsp">
                <img src="./images/logo.jpg" alt="Commuters Guide" width="480" height="93" />
             
            </a></h1>
        </div>
 
        <!-- end of templatemo_menu -->
        
      <div class="cleaner"></div>
	</div> <!-- end of header -->
	<div id="header"></div>
    
    <div id="templatemo_content">


	<!-- Form Body -->

<div>
<%
//Session Validation
try{
	if(session.isNew()){
			out.println("<h3><span style='color: red;'>Access Denied please login to access </span></h3>");	
	}
	else{
	String uname = (String)session.getAttribute("uname");
	String ssid = (String)session.getAttribute("sid");
	String author = (String)session.getAttribute("author");
	String sessionid = (String)session.getId();
		if(ssid == sessionid && author.equals("admin")) {
		%>
<form name="form1" action="./TrainSchedule.jsp">
<h1 align="center"> New Event Details Addition  </h1>

<div id="divHead" >
            <%
            String tno=request.getParameter("trainno");           
            
            String sql5 ="select * from vehi_info where vehi_no=?";
            
            pstmt = con.prepareStatement(sql5);
            
            pstmt.setString(1,tno);
            
            rs = pstmt.executeQuery();
            
            if(rs.next()){
    			out.println("<h3> <span style='color: red;'> Vehical NO Already Exist TRY AGAIN </span> </h3>");
    			out.println("<a href='TrainInfo.jsp'> OK </a>");
    			out.println("</div>");
  		}
            else{
            %>
            <br/>
	  	<table id="table1" align="center" style="font-weight: bold;" >
		  <tr>
      		<th colspan="2" style="font-size: 18px;"> Event Details </th>
		</tr>
          <tr>
            <td><label> Vehical N0 </label></td>
            <td>       
			<input type="text" name="trainno" value="<%= tno %>" readonly="readonly" tabindex="-1"/></td>
			
          </tr>
         
         
         <!-- Scriplet to fetch the source and destination from back end based on the destination Id -->
          <%
              int did=Integer.parseInt(request.getParameter("destid"));
	          
	          String sql1 = "select station_name, km from route where station_id="+did+";"; 
	          
	          pstmt = con.prepareStatement(sql1);
	          
	          rs = pstmt.executeQuery();
	          
	          String dest="";
	          int km=0;
	          while (rs.next()){
	        	  dest = rs.getString("station_name");
	        	  km = rs.getInt("km");
	          }
	
	          
	          int sid= did - 99;
	          
	          String sql2 = "select station_name from route where station_id="+sid+";"; 
	          
	          pstmt = con.prepareStatement(sql2);
	          
	          rs = pstmt.executeQuery();
	          
	          String src="";
	          while (rs.next()){
	        	  src = rs.getString("station_name");
	          }
          
          %>
         <!-- End of Scriplet to fetch the source and destination from back end based on the destination Id -->
          
         
          <tr>
         
         
            <td><label> Source </label></td>
            <td>
            
            <!-- To forward the id's fetched from backend -->
            <input type="hidden" name="srcid" value=<%=sid %>>
            <input type="hidden" name="destid" value=<%=did %>>
            <input type="hidden" name="km" value=<%=km %>>

            <input type="text"  name="src" value=<%= src %> readonly="readonly" tabindex="-1"/> </td>
          </tr>
          <tr>
            <td><label> Destination </label></td>
            <td><input type="text" name="dest"value=<%= dest %> readonly="readonly" tabindex="-1"/> </td>
          </tr><tr>
            <td><label> Distance </label></td>
            <td><input type="text" value=<%=km %> readonly="readonly" tabindex="-1"/></td>
          </tr>
          <tr>
            <td><label> Vehical Name </label></td>
            <td><input type="text" name="tname" maxlength="30" onkeyup="alp1(this)" onkeydown="alp1(this)" /></td>
          </tr>
          <tr>
            <td><label> Type </label></td>
            <td>
            <select name="type">
            <option> ORDINARY </option>
            <option> EXPRESS </option>
            </select>
            </td>
          </tr>
          <tr>
            <td><label> Departures On </label></td>
            <td align="left">
            <input type="checkbox" name="days" value="mon" /> Monday<br>
            <input type="checkbox" name="days" value="tue" /> Tuesday<br> 
            <input type="checkbox" name="days" value="wed" /> Wednesday<br> 
            <input type="checkbox" name="days" value="thu" /> Thursday<br> 
            <input type="checkbox" name="days" value="fri" /> Friday<br> 
            <input type="checkbox" name="days" value="sat" /> Saturday<br>
            <input type="checkbox" name="days" value="sun" /> Sunday 
            </td>
          </tr>
    </table>
    
    <p align="center">
    	<input type="submit" value="Save Details" onclick="validate()" />
    	<input type="reset" />
    </p>
  
</div>
</form>
	<%
		//Session Validation
            }//close of if statement of train no
		}
		else{
			out.println("<h3><span style='color: red;'>Access Denied please login to access </span></h3>");	
		}
	}
}
catch(Exception e){
	out.println("<h3><span style='color: red;'>Access Denied please login to access </span></h3>");	
}
%>


</div>

	<!-- Form Body -->

    </div> <!-- end of templatemo_content -->
    
    <div id="templatemo_sidebar">
    		<div id="request_a_quote">
        <%
        	try{
			if(session.isNew()){			//session.isNew is true for the first time when the page is loaded
			}
			else{
			String uname = (String)session.getAttribute("uname");
			String ssid = (String)session.getAttribute("sid");
			String author = (String)session.getAttribute("author");
			String error = (String)session.getAttribute("error");
			String sessionid = (String)session.getId();
				if(error=="Y"){				//error=Y is set when the email and password are mismatched
				}
				else if(ssid == sessionid) {			//To verify the session id of page and sid i.e session id set during session creation match
				%>
					<h2> Login Details</h2><br/>
					<p style="font-size: 12pt">
					<label style="color:#DD0000;"> UserName</label> &nbsp; <%= uname %>	<br/>
					<label style="color:#DD0000;"> Authority </label> &nbsp; <%= author.toUpperCase() %>	<br/>
					<br/>
					<a href="<%= author%>home.jsp"> <%= author.toUpperCase() %>	Home</a>
					<a href='Logout.jsp'> Logout</a>
					</p>
				<%
				}
				else{			//if all cases fail login is prompted
				}
			}
        }
        catch(Exception e){       	
        }
		%>
        </div>
    
      <div id="sidebar_featured_project">
			<div class="cleaner"></div>
            <div class="cleaner"></div>
            <div class="cleaner"></div>
            <div class="cleaner"></div>      
        </div>
        <div class="cleaner"></div>
    </div>

</div> <!-- end of wrapper -->

<div id="footer"></div>
</body>
</html>
