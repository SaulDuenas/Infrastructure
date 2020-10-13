<%
'Este ASP inicia un Download de un archivo binario

'Set the content type to the specific type that you are sending.
Response.ContentType = "application/x-msexcel"

Dim strFilePath
strFilePath = "C:\ExcelFiles\Excel1.xls" 'This is the path to the file on disk. 

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1 ' adTypeBinary , y creo que 0=adTypeText
objStream.LoadFromFile strFilePath
Response.BinaryWrite objStream.Read
objStream.Close
Set objStream = Nothing
%> 




<%
'Para descargar un HTML en Excel:
Response.ContentType = "application/vnd.ms-excel"
'Response.AddHeader "content-disposition", "inline; filename=CuestionariosRoy.xls"      'Esto muestra el Excel en una ventana
Response.AddHeader "content-disposition", "attachment; filename=CuestionariosRoy.xls"   'Esto hace un download
%>