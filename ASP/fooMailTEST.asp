<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D" NAME="CDO for Windows 2000 Type Library" -->
<!--METADATA TYPE="typelib" UUID="00000205-0000-0010-8000-00AA006D2EA4" NAME="ADODB Type Library" -->

<%
Response.Expires =0
'vbCrLf= chr(13) & chr(10)

' Send by connecting to port 25 of the SMTP server.
Sub SendCDO_smtp()
	Dim iMsg 
	Dim iConf 
	Dim Flds 
	Dim strHTML
	set iMsg = CreateObject("CDO.Message")
	set iConf = CreateObject("CDO.Configuration")
	Set Flds = iConf.Fields 
	'Llenamos los campos de configuracion
	With Flds
		.Item(cdoSendUsingMethod) = cdoSendUsingPort
		.Item(cdoSMTPServer) = Request("txtSMTPServer")
		.Item(cdoSMTPServerPort) = 25
		.Item(cdoSMTPConnectionTimeout) = 20  
		.Item(cdoSMTPAuthenticate) = cdoBasic
		.Item(cdoSendUserName) = Request("txtUID")
		.Item(cdoSendPassword) = Request("txtPWD")
		.Update
	End With
	'Armar Mensaje
	lCad = "Este mensaje fué enviado desde el servidor " & Request.ServerVariables("SERVER_NAME") & vbCrLf
	lCad = lCad & "Desde la página: " & Request.ServerVariables("URL") & vbCrLf
	lCad = lCad & "el dia " & now() & vbCrLf
	lCad = lCad & "Mediante el método CDO for Win 2000 usando el servidor SMTP " & Request("txtSMTPServer") & vbCrLf
	lCad = lCad & "y la cuenta " & Request("txtUID") & vbCrLf

	'Ponemos la configuracion en el mensaje
	With iMsg
		Set .Configuration = iConf
		.To = Request("txtEmailTo") 
		.From = Request("txtEmailFrom")
		.Subject = "Mensaje de Prueba CDO for Win2000 (SMTP remoto)"
		'.HTMLBody = lCad
		.TextBody = lCad
		'Enviar
		.Send
	End With
	'Limpiamos variables
	Set iMsg = Nothing
	Set iConf = Nothing
	Set Flds = Nothing
End Sub



'Send using the Pickup directory on the IIS server.
Sub SendCDO_IIS()
	Dim iMsg 
	Dim iConf 
	Dim Flds 
	Dim strHTML
	set iMsg = CreateObject("CDO.Message")
	set iConf = CreateObject("CDO.Configuration")
	Set Flds = iConf.Fields
	With Flds 
		.Item(cdoSendUsingMethod) = cdoSendUsingPickup
      .Item(cdoSMTPServerPickupDirectory) = Request("txtPickupDir")
		.Update
	End With
	'Armar Mensaje
	lCad = "Este mensaje fué enviado desde el servidor " & Request.ServerVariables("SERVER_NAME") & vbCrLf
	lCad = lCad & "Desde la página: " & Request.ServerVariables("URL") & vbCrLf
	lCad = lCad & "el dia " & now() & vbCrLf
	lCad = lCad & "Mediante el método CDO for Win 2000 usando el directorio de pickup " & Request("txtPickupDir") & vbCrLf
   With iMsg
		Set .Configuration = iConf
		.To = Request("txtEmailTo") 'ToDo: Enter a valid email address.
		.From = Request("txtEmailFrom") 'ToDo: Enter a valid email address.
		.Subject = "Mensaje de Prueba CDO for Win2000 (Pickup directory)"
		'.HTMLBody = lCad
		.TextBody = lCad
		'Enviar
		.Send
	End With
	'Limpiamos variables
	Set iMsg = Nothing
	Set iConf = Nothing
	Set Flds = Nothing
End Sub

'Send using the Pickup directory on the IIS server.
Sub SendCDO_IISlocal()
	Dim iMsg 
	Dim iConf 
	Dim Flds 
	Dim strHTML
	set iMsg = CreateObject("CDO.Message")
	set iConf = CreateObject("CDO.Configuration")
	Set Flds = iConf.Fields
	With Flds 
		.Item(cdoSendUsingMethod) = cdoSendUsingPort  '  cdoSendUsingPickup  
      ' No lo especificamos: .Item(cdoSMTPServerPickupDirectory) = Request("txtPickupDir")
		.Item(cdoSMTPServer) = "127.0.0.1"   '"http://127.0.0.1"
		.Item(cdoSMTPServerPort) = 25
		.Item(cdoSMTPConnectionTimeout) = 20  
		.Update
	End With
	'Armar Mensaje
	lCad = "Este mensaje fué enviado desde el servidor " & Request.ServerVariables("SERVER_NAME") & vbCrLf
	lCad = lCad & "Desde la página: " & Request.ServerVariables("URL") & vbCrLf
	lCad = lCad & "el dia " & now() & vbCrLf
	lCad = lCad & "Mediante el método CDO for Win 2000 usando el directorio de pickup SIN especificarlo (http://127.0.0.1)" & vbCrLf
   With iMsg
		Set .Configuration = iConf
		.To = Request("txtEmailTo") 'ToDo: Enter a valid email address.
		.From = Request("txtEmailFrom") 'ToDo: Enter a valid email address.
		.Subject = "Mensaje de Prueba CDO for Win2000 (Pickup directory Sin Esp)"
		'.HTMLBody = lCad
		.TextBody = lCad
		'Enviar
		.Send
	End With
	'Limpiamos variables
	Set iMsg = Nothing
	Set iConf = Nothing
	Set Flds = Nothing
End Sub




Sub SendCDONTS()
	'Armar Mensaje
	lCad = "Este mensaje fué enviado desde el servidor " & Request.ServerVariables("SERVER_NAME") & vbCrLf
	lCad = lCad & "Desde la página: " & Request.ServerVariables("URL") & vbCrLf
	lCad = lCad & "el dia " & now() & vbCrLf
	lCad = lCad & "Mediante el método CDONTS" & vbCrLf

	Set mailobj = Server.CreateObject("CDONTS.NewMail")
	mailobj.mailFormat = 0
	mailobj.bodyFormat = 1
	mailobj.to = Request("txtEmailTo")
	mailobj.from = Request("txtEmailFrom")
	mailobj.subject = "Mensaje de Prueba CDONTS"
	mailobj.body = lCad
	mailobj.send
	Set mailobj = nothing
end sub

if Request("optMetodo")="1" then SendCDO_smtp
if Request("optMetodo")="2" then SendCDO_IIS
if Request("optMetodo")="3" then SendCDO_IISlocal
if Request("optMetodo")="4" then SendCDONTS


%>

<html>
<head>
<title>Env&iacute;o de Mails</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--
function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' must contain an e-mail address.\n';
      } else if (test!='R') {
        if (isNaN(val)) errors+='- '+nm+' must contain a number.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (val<min || max<val) errors+='- '+nm+' must contain a number between '+min+' and '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' is required.\n'; }
  } if (errors) alert('The following error(s) occurred:\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<h1 align="center">P&aacute;gina de prueba para env&iacute;o de mails</h1>
<% if Request("optMetodo")="" then %>
<form name="form1" method="post" action="fooMailTest.asp" onSubmit="MM_validateForm('txtEmailTo','','RisEmail','txtEmailFrom','','RisEmail');return document.MM_returnValue">
   <p><b>Enviar usando:</b></p>
   <p> 
      <input type="radio" name="optMetodo" value="1">
      CDO for Win2000 con un SMTP remoto, Server: 
      <input type="text" name="txtSMTPServer">
      &nbsp;&nbsp; uid: 
      <input type="text" name="txtUID">
      &nbsp;&nbsp;pwd: 
      <input type="password" name="txtPWD">
      <br>
      <input type="radio" name="optMetodo" value="2">
      CDO for Win2000 usando el directorio Pickup de IIS. (normalmente es 
      <input type="text" name="txtPickupDir" value="c:\Inetpub\mailroot\Pickup" size="40">
      )<br>
      <input type="radio" name="optMetodo" value="3">
CDO for Win2000 usando ALGODON. (sin especificarlo, con server=
http://127.0.0.1
)      <br>
      <input type="radio" name="optMetodo" value="4" checked>
      CDO for NTS</p>
   <p><font size="2">(Esta p&aacute;gina est&aacute; almecenada en el directorio: 
      <%= server.mappath(Request.ServerVariables("PATH_INFO"))%>)</font></p>
   <p>E-Mail To: 
    <input type="text" name="txtEmailTo">
    <br>
    E-Mail From: 
    <input type="text" name="txtEmailFrom">
  </p>
  <p>
    <input type="submit" name="Submit" value="Enviar">
  </p>
</form>
<% Else %>  
<p>Mail enviado! M&eacute;todo <%= Request("optMetodo") %> </p>
<% End if %>  
</body>
</html>
