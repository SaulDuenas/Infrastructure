<!--METADATA TYPE="typelib" UUID="00000205-0000-0010-8000-00AA006D2EA4" NAME="ADODB Type Library" -->
<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="../Connections/connRecetas.asp" -->

<%
Dim lPagMaestro, lConnStr, lThisPage

'Nombre de la página Maestro
lPagMaestro="lstMaestro.asp"

'Nombre de ÉSTA página detalle
lThisPage=mid(Request.ServerVariables("SCRIPT_NAME"),instrrev(Request.ServerVariables("SCRIPT_NAME"),"/")+1)

'Nombre de la conexion a usar
lConnStr=MM_connRecetas_STRING


Dim lQry,rstRS, cmdCMD, lAccion, lEditando
lEditando=False

'Se está enviando información capturada en la forma?
if Request.ServerVariables("REQUEST_METHOD")<>"POST" then
   'Apenas vamos a mostrar la página, no se ha procesado nada aún
	'Que accion nos solicitan?
	lAccion=Request.QueryString("Accion")
	Select Case lAccion
	   Case ""
   	   Err.raise 35000,,"TSR: No se recibió el parámetro 'Accion'"
		Case "Alta"
		   'No hacemos nada
		Case "Edicion","EdicionBaja"
		   'Abrimos un recordset para mostrar la info a editar
			Set rstRS = Server.CreateObject("ADODB.Recordset")
			rstRS.ActiveConnection = lConnStr
			rstRS.Source = "SELECT * FROM Tablita WHERE Clave = '" & Replace(Request.QueryString("RecID"), "'", "''") & "'"
			rstRS.CursorType = adOpenForwardOnly  '0
			rstRS.CursorLocation = adUseServer    '2
			rstRS.LockType = adLockReadOnly       '1
			rstRS.Open()
			lEditando=True

		Case Else
   	   Err.raise 35000,,"TSR: No se reconoce la Accion '" & lAccion & "'"
	End select
else
   'Procesa el formulario
	Select case Request.form("hidAccion")
	   Case "Alta"
			'arma el query
			lQry="INSERT INTO Tablita (Clave,Nombre,Descripcion) VALUES (" & _
			     "'" & Replace(Request.Form("Clave"),"'","''") & "'," & _
			     "'" & Replace(Request.Form("Nombre"),"'","''") & "'," & _
			     "'" & Replace(Request.Form("Descripcion"),"'","''") & "')" 
		Case "Edicion", "EdicionBaja"
			lQry="UPDATE Tablita SET " & _
					  "Nombre='" & Replace(Request.Form("Nombre"),"'","''") & "'," & _
					  "Descripcion='" & Replace(Request.Form("Descripcion"),"'","''") & "'" & _
				  " WHERE Clave='" & Replace(Request.Form("hidRecID"),"'","''") & "'"
		Case "Baja"
			lQry="DELETE FROM Tablita" & _
				  " WHERE Clave='" & Replace(Request.Form("hidRecID"),"'","''") & "'"
	End Select
	
	'Ejecuta el Query
	if lQry<>"" then
		Set cmdCMD = Server.CreateObject("ADODB.Command")
		cmdCMD.ActiveConnection = lConnStr
		cmdCMD.CommandText = lQry
		cmdCMD.Execute
		cmdCMD.ActiveConnection.Close
	else
  	   Err.raise 35000,,"TSR: No se recibió el campo hidAccion o trae un valor no reconocido"
	end if
	
	'Redirecciona
   Response.Redirect(lPagMaestro)
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_goToURL() { //v3.0
  var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
  for (i=0; i<(args.length-1); i+=2) eval(args[i]+".location='"+args[i+1]+"'");
}
//-->
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
function Eliminar(){
   if (confirm('¿Está Seguro?')) 
	   document.getElementById("frmBaja").submit();
}
//-->
</script>

</head>

<body>
<h1>Esta es una plantilla de detalle.</h1>
<form action="<%=lThisPage%>" method="post" name="frmDetalle" id="frmDetalle">
   <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
         <td width="21%">Clave (RecID) </td>
         <td width="79%">
			<% if not lEditando then %>
			   <input name="Clave" type="text" id="Clave">
			<% Else %>
			   <%=Request.QueryString("RecID") %>
         <% End If %>
         </td>
      </tr>
      <tr>
         <td>Nombre</td>
         <td><input name="Nombre" type="text" id="Nombre" <%if lEditando then %> value="<%=(rstRS.Fields.Item("Nombre").Value)%>" <%end if%>  ></td>
      </tr>
      <tr>
         <td>Descripcion</td>
         <td><textarea name="Descripcion" id="Descripcion"><%if lEditando then %><%=(rstRS.Fields.Item("Descripcion").Value)%><%end if%></textarea></td>
      </tr>
   </table>
   <p align="center">
      <input name="cmdOK" type="submit" id="cmdOK" value="Aceptar">
&nbsp;&nbsp;&nbsp;
<input name="cmdCancel" type="button" id="cmdCancel" onClick="MM_goToURL('parent','<%=lPagMaestro%>');return document.MM_returnValue" value="Cancelar"> 
<% if lAccion="EdicionBaja" then %>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input name="cmdBorrar" type="button" id="cmdBorrar" onClick="Eliminar()" value="Eliminar">
<% End If %>
</p>
   <p>
      <input name="hidAccion" type="hidden" id="hidAccion" value="<%=lAccion%>">
&lt;--Este elemento oculto guarda la &quot;Accion&quot; </p>
   <p>
      <input name="hidRecID" type="hidden" id="hidRecID" value="<%=Request.QueryString("RecID") %>">
&lt;--Este elemento oculto guarda el RecID </p>
</form>
<% if lAccion="EdicionBaja" then %>
<form action="<%=lThisPage%>" method="post" name="frmBaja" id="frmBaja">
   <input name="hidAccion" type="hidden" id="hidAccion" value="Baja">
   <input name="hidRecID" type="hidden" id="hidRecID" value="<%=Request.QueryString("RecID") %>">
&lt;--El primer elemento es la Accion=Baja , el segundo es el RecID
</form>
<% End If %>

<p>&nbsp;</p>
<p>Debe ser llamada por una p&aacute;gina maestro con los siguientes
   par&aacute;metros de URL:<br>
   Accion=Alta: para insertar un nuevo registro<br>
   Accion=Edicion: para editar un registro. <br>
   Accion=EdicionBaja: para editar y permitir eliminar el registro <br>
   para edici&oacute;n: incluir el par&aacute;metro RecID=(clave del registro) </p>
<p>Revisar los siguientes puntos: </p>
<ul>
   <li>Se sugiere que los nombres de los controles coincidan con los nombres
      de los campos en la tabla</li>
   <li>Al agregar nuevos campos tener cuidado de que contengan el c&oacute;digo
      ASP como en los que aqu&iacute; se muestran (if lEditando.... end if) </li>
   <li>Checar la longitud de los campos </li>
   <li>Establecer la variable lPagMaestro=nombre de la p&aacute;gina maestro que llama
   a &eacute;sta p&aacute;gina </li>
   <li>El bot&oacute;n Aceptar valida la forma y la env&iacute;a</li>
   <li>La accion de las formas debe apuntar a este mismo archivo (como se llame)</li>
   <li>Establecer la variable lConnStr=MM_ConexionAUsar_STRING</li>
   <li>Revisar todos los queries </li>
</ul>
<p>&nbsp;</p>
<p>&nbsp; </p>
</body>
</html>
<%
if lEditando then
   rstRS.Close()
   Set rstRS = Nothing
end if
%>
