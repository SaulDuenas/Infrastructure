<%
nombrepdf= nombrearchivo

'response.redirect("etc/"& nombrepdf)

'Forza download de archivo ///////////////////////////////////////////////////////////////////////////////////

'--------------------------------------------
Response.Buffer = True
Dim strFilePath, strFileSize, strFileName

Const adTypeBinary = 1

strFilePath = Path
'strFileSize = ... the size of file .. optional
strFileName = nombrepdf

Response.Clear

'8*******************************8
' Requires MDAC 2.5 to be stable
' I recommend MDAC 2.6 or 2.7
'8*******************************8
Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = adTypeBinary
objStream.LoadFromFile strFilePath

strFileType = lcase(Right(strFileName, 4))

' Feel Free to Add Your Own Content-Types Here
Select Case strFileType
'Case ".asf"
'ContentType = "video/x-ms-asf"
'Case ".avi"
'ContentType = "video/avi"
'Case ".doc"
'ContentType = "application/msword"
'Case ".zip"
'ContentType = "application/zip"
'Case ".xls"
'ContentType = "application/vnd.ms-excel"
'Case ".gif"
'ContentType = "image/gif"
'Case ".jpg", "jpeg"
'ContentType = "image/jpeg"
'Case ".wav"
'ContentType = "audio/wav"
'Case ".mp3"
'ContentType = "audio/mpeg3"
'Case ".mpg", "mpeg"
'ContentType = "video/mpeg"
'Case ".rtf"
'ContentType = "application/rtf"
'Case ".htm", "html"
'ContentType = "text/html"
'Case ".asp"
'ContentType = "text/asp"
Case ".pdf"
ContentType = "application/pdf"
'Case Else
'Handle All Other Files
'ContentType = "application/octet-stream"
End Select


Response.AddHeader "Content-Disposition", "attachment; filename=" & strFileName
Response.AddHeader "Content-Length", strFileSize
' In a Perfect World, Your Client would also have UTF-8 as the default 
' In Their Browser
Response.Charset = "UTF-8"
Response.ContentType = ContentType

Response.BinaryWrite objStream.Read
Response.Flush

objStream.Close
Set objStream = Nothing
%>