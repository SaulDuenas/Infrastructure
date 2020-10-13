<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>
<h1><strong>Server Variables </strong></h1>
<p><%=Server.MapPath("Uplads")%></p>
<p><%=mid(Request.ServerVariables("SCRIPT_NAME"),instrrev(Request.ServerVariables("SCRIPT_NAME"),"/")+1)%></p>
<TABLE>
<TR><TD><B>Server Variable</B></TD><TD><B>Value</B></TD></TR>
<% For Each name In Request.ServerVariables %> 
<TR valign="top"><TD> <%= name %> </TD><TD>  <%= Request.ServerVariables(name) %> </TD></TR>
<% Next %> 
</TABLE>

<p><BR>
</p>
<h2>Request.Form</h2>
<TABLE>
   <TR>
      <TD><B>Elemento</B></TD>
      <TD><B>Value</B></TD>
   </TR>
   <% For Each name In Request.Form %>
   <TR valign="top">
      <TD><%= name %> </TD>
      <TD><%= Request.Form(name) %> </TD>
   </TR>
   <% Next %>
</TABLE>
<p>&nbsp;</p>
<h2>Request.QueryString</h2>
<TABLE>
   <TR>
      <TD><B>Elemento</B></TD>
      <TD><B>Value</B></TD>
   </TR>
   <% For Each name In Request.QueryString %>
   <TR valign="top">
      <TD><%= name %> </TD>
      <TD><%= Request.QueryString(name) %> </TD>
   </TR>
   <% Next %>
</TABLE>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>
