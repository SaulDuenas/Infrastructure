<!--METADATA TYPE="typelib" UUID="00000205-0000-0010-8000-00AA006D2EA4" NAME="ADODB Type Library" -->
<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="../Connections/connRecetas.asp" -->
<!--#include file="freeaspupload.asp" -->

<%
Dim lPagMaestro, lConnStr, lThisPage, rstAux, lCad, fso, UploadFolder, objUpload, keys, lAux

'Nombre de la página Maestro
lPagMaestro="lstChefs.asp"

'Nombre de ÉSTA página detalle
lThisPage=mid(Request.ServerVariables("SCRIPT_NAME"),instrrev(Request.ServerVariables("SCRIPT_NAME"),"/")+1)

'Nombre de la conexion a usar
lConnStr=MM_connRecetas_STRING

'Nombre del folder donde se realizarán los Uploads
UploadFolder="../Uploads"

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
			rstRS.Source = "SELECT * FROM Chefs WHERE ChefID = " & Replace(Request.QueryString("RecID"), "'", "''") & ""
			rstRS.CursorType = adOpenForwardOnly  '0
			rstRS.CursorLocation = adUseServer    '2
			rstRS.LockType = adLockReadOnly       '1
			rstRS.Open()
			lEditando=True

		Case Else
   	   Err.raise 35000,,"TSR: No se reconoce la Accion '" & lAccion & "'"
	End select
else
   if Request.QueryString("Accion")<>"Upload" then
		'Procesa el formulario
		Select case Request.form("hidAccion")
			Case "Alta"
				'arma el query
				lQry="INSERT INTO Chefs (Nombre,Descripcion) VALUES (" & _
					  "'" & Replace(Request.Form("Nombre"),"'","''") & "'," & _
					  "'" & Replace(Request.Form("Descripcion"),"'","''") & "')" 
			Case "Edicion", "EdicionBaja"
				lQry="UPDATE Chefs SET " & _
						  "Nombre='" & Replace(Request.Form("Nombre"),"'","''") & "'," & _
						  "Descripcion='" & Replace(Request.Form("Descripcion"),"'","''") & "'" & _
					  " WHERE ChefID=" & Replace(Request.Form("hidRecID"),"'","''") & ""
			Case "Baja"
				lQry="DELETE FROM Chefs" & _
					  " WHERE ChefID=" & Replace(Request.Form("hidRecID"),"'","''") & ""
				'Borra el archivo anterior
            if	Request.Form("hidFileName")<>"" then
					Set fso = CreateObject("Scripting.FileSystemObject")
					lCad=Server.MapPath(UploadFolder) & "\" & Request.Form("hidFileName")
					if fso.FileExists(lCad) then fso.DeleteFile lCad
					set fso=nothing
				End if
		End Select
		
		'Ejecuta el Query
		if lQry<>"" then
			Set cmdCMD = Server.CreateObject("ADODB.Command")
			cmdCMD.ActiveConnection = lConnStr
			cmdCMD.CommandText = lQry
			cmdCMD.Execute
			'**** Esta seccion se puede suprimir si no se usa como RecID un campo Autonumérico y solo se usa para los Uploads
			if Request.Form("hidAccionUpload")="NuevoUpload" then
				'Necesitamos obtener la clave del registro recien Insertado
				Set rstAux = Server.CreateObject("ADODB.Recordset")
				set rstAux.ActiveConnection = cmdCMD.ActiveConnection
				rstAux.Source = "SELECT @@IDENTITY AS RecID"
				rstAux.CursorType = adOpenForwardOnly  '0
				rstAux.CursorLocation = adUseServer    '2
				rstAux.LockType = adLockReadOnly       '1
				rstAux.Open()
				lCad=rstAux.Fields.Item("RecID").Value
				rstAux.Close()
				Set rstAux = Nothing
			end if
			'**** Fin de la seccion
			cmdCMD.ActiveConnection.Close
		else
			Err.raise 35000,,"TSR: No se recibió el campo hidAccion o trae un valor no reconocido"
		end if
		
		'Redirecciona
		if Request.Form("hidAccionUpload")="NuevoUpload" then
			'Salta a esta misma página en modo de edicion
			Response.Redirect(lThisPage & "?Accion=Edicion&RecID=" & Server.URLEncode(lCad))
		else
			Response.Redirect(lPagMaestro)
		end if

	else  'Hay que hacer el Upload
      'Borrar el archivo anterior
		if Request.QueryString("OldFileName")<>"" then
		   Set fso = CreateObject("Scripting.FileSystemObject")
			lCad=Server.MapPath(UploadFolder) & "\" & Request.QueryString("OldFileName")
			if fso.FileExists(lCad) then fso.DeleteFile lCad
			set fso=nothing
		end if
		'Salvar el nuevo archivo
		Set objUpload= New FreeASPUpload
		objUpload.Save(Server.MapPath(UploadFolder))
		'Obtiene el nombre del archivo (solo es uno)
		keys= objUpload.UploadedFiles.keys
		lCad= objUpload.UploadedFiles(Keys(0)).FileName
		'Registrarlo en la base de datos
		lQry="UPDATE Chefs SET " & _
				  "Foto='" & Replace(lCad,"'","''") & "'" & _
			  " WHERE ChefID=" & Replace(Request.QueryString("RecID"),"'","''") & ""
		Set cmdCMD = Server.CreateObject("ADODB.Command")
		cmdCMD.ActiveConnection = lConnStr
		cmdCMD.CommandText = lQry
		cmdCMD.Execute
		cmdCMD.ActiveConnection.Close
		'Redirecciona
		Response.Redirect(lThisPage & "?Accion=" & Request.QueryString("OldAccion") & "&RecID=" & Request.QueryString("RecID"))
   end if	
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
<script language="JavaScript" type="text/JavaScript">
<!--
function Eliminar(){
   if (confirm('¿Está Seguro?')) 
	   document.getElementById("frmBaja").submit();
}

function NuevoUpload(){
   //Primero valida la forma
	MM_validateForm('Nombre','','R','Descripcion','','R');
	if (document.MM_returnValue){
		//Indica en el campo oculto hidAccionUpload que debemos dar de alta primero y después regresar a modo edición
		document.getElementById("hidAccionUpload").value="NuevoUpload";
		//Envía la forma
	   document.getElementById("frmDetalle").submit();
	}
}

function MM_goToURL() { //v3.0
  var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
  for (i=0; i<(args.length-1); i+=2) eval(args[i]+".location='"+args[i+1]+"'");
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' must contain an e-mail address.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' must contain a number.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' must contain a number between '+min+' and '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' is required.\n'; }
  } if (errors) alert('The following error(s) occurred:\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>

</head>

<body>
<h1>Esta es una plantilla de detalle.</h1>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
   <tr>
      <td width="57%"><form action="<%=lThisPage%>" method="post" name="frmDetalle" id="frmDetalle">
         <table width="100%"  border="0" cellspacing="5" cellpadding="0">
            <tr>
               <td width="21%">Nombre</td>
               <td><input name="Nombre" type="text" id="Nombre" size="54" <%if lEditando then %>value="<%=(rstRS.Fields.Item("Nombre").Value)%>"<%end if%>></td>
            </tr>
            <tr>
               <td height="153">Descripcion</td>
               <td>
					<textarea name="Descripcion" cols="41" rows="10" id="Descripcion"><%if lEditando then %><%=(rstRS.Fields.Item("Descripcion").Value)%><%end if%></textarea>
					</td>
            </tr>
         </table>
         <p align="center">
            <input name="cmdOK" type="submit" id="cmdOK" onClick="MM_validateForm('Nombre','','R','Descripcion','','R');return document.MM_returnValue" value="Aceptar">
&nbsp;&nbsp;&nbsp;
      <input name="cmdCancel" type="button" id="cmdCancel" onClick="MM_goToURL('parent','<%=lPagMaestro%>');return document.MM_returnValue" value="Cancelar">
      <% if lAccion="EdicionBaja" then %>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <input name="cmdBorrar" type="button" id="cmdBorrar" onClick="Eliminar()" value="Eliminar">
      <% End If %>
         </p>
         <p>
            <input name="hidAccion" type="hidden" id="hidAccion" value="<%=lAccion%>">
            <input name="hidRecID" type="hidden" id="hidRecID" value="<%=Request.QueryString("RecID") %>">
            <input name="hidAccionUpload" type="hidden" id="hidAccionUpload">
         </p>
      </form></td>
      <td width="43%" valign="top"><form action="<%=lThisPage%>?Accion=Upload&RecID=<%=Request.QueryString("RecID")%><%if lEditando then%>&OldFileName=<%=rstRS.Fields.Item("Foto").Value%><%end if%>&OldAccion=<%=lAccion%>" method="post" enctype="multipart/form-data" name="frmFoto" id="frmFoto">
		   <p align="center">
			<% 
			if lEditando then
			   if (rstRS.Fields.Item("Foto").Value & "")<>"" then
				   lCad=UploadFolder & "/" & rstRS.Fields.Item("Foto").Value
					lAux=rstRS.Fields.Item("Foto").Value
				Else
      			lCad=UploadFolder & "/Chef00.jpg"
					lAux="No tiene Foto"
				end if
			else
				lAux=""
     			lCad=UploadFolder & "/Chef00.jpg"
			end if
			%>
			<img name="imgFoto" src="<%=lCad%>" width="88" height="133" alt="Foto del Chef"><br>
            <%=lAux%>
         </p>
         <p align="center">
            <%if lEditando then %>
<input name="FileName" type="file" id="FileName">
            <input type="submit" name="Submit" value="Submit">
            <%else%>
            <input name="cmdFoto" type="button" id="cmdFoto" onClick="NuevoUpload()" value="Foto...">
            <%end if%>
         </p>
         <p>&nbsp;         </p>
      </form></td>
   </tr>
</table>
<p>&nbsp;</p>
<% if lAccion="EdicionBaja" then %>
<form action="<%=lThisPage%>" method="post" name="frmBaja" id="frmBaja">
   <input name="hidAccion" type="hidden" id="hidAccion" value="Baja">
   <input name="hidRecID" type="hidden" id="hidRecID" value="<%=Request.QueryString("RecID") %>">
   <input name="hidFileName" type="hidden" id="hidFileName" value="<%=(rstRS.Fields.Item("Foto").Value)%>">
&lt;--El primer elemento es la Accion=Baja , el segundo es el RecID
</form>
<% End If %>

<p>&nbsp;</p>
<h2>Forma de Uso </h2>
<p>Debe ser llamada por una p&aacute;gina maestro con los siguientes
   par&aacute;metros de URL:<br>
   Accion=<strong>Alta</strong>: para insertar un nuevo registro<br>
   Accion=<strong>Edicion</strong>: para editar un registro. <br>
   Accion=<strong>EdicionBaja</strong>: para editar y permitir eliminar el registro <br>
   para edici&oacute;n: incluir el par&aacute;metro <strong>RecID</strong>=(clave del registro) </p>
<p>Revisar los siguientes puntos: </p>
<ul>
   <li>Se sugiere que los nombres de los controles coincidan con los nombres
      de los campos en la tabla</li>
   <li>Al agregar nuevos campos tener cuidado de que contengan el c&oacute;digo ASP
      como en los que aqu&iacute; se muestran (if lEditando.... end if) </li>
   <li>Checar la longitud de los campos </li>
   <li>Establecer la variable lPagMaestro=nombre de la p&aacute;gina maestro que llama
   a &eacute;sta p&aacute;gina </li>
   <li>El bot&oacute;n Aceptar valida la forma y la env&iacute;a</li>
   <li>Checar la validacion de la forma: tanto en el evento click del boton Aceptar
   como en el script NuevoUpload debe ser igualita </li>
   <li>Establecer la variable lConnStr=MM_ConexionAUsar_STRING</li>
   <li>Revisar todos los queries</li>
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
