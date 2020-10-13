Attribute VB_Name = "TSR_excel"



Public Function ExcelOpen(pBookFileName As String) As Object
   
   Dim lobjXL As Object        'Objeto contenedor de la aplicación Microsoft Excel
   Dim lobjWkb As Object        ' Objeto contenedor del archivo
    

   'Set lobjXL = New Excel.Application      '
   Set lobjXL = CreateObject("Excel.Application")
   
   lobjXL.Visible = False
   lobjXL.DisplayAlerts = False
   Set lobjWkb = lobjXL.Workbooks.Open(pBookFileName, , False)
   
   Set ExcelOpen = lobjWkb
   
End Function


Public Function HojaAbrir(pObjWkb As Object, Worksheets As String) As Object

  Set HojaAbrir = pObjWkb.Worksheets(Worksheets)

End Function


Public Function TerminarExcel(pObjWkb As Object) As Object
   
   Dim lRetVal As Boolean
   
   'Guardar Archivo
  If Not (pObjWkb Is Nothing) Then
      
      pObjWkb.Save
      ' Cierra excel
      pObjWkb.Close False
 
    '  pObjWkb.Quit
      'Termina Excel
      
      Set pObjWkb = Nothing
      
   End If
   
   Set TerminarExcel = pObjWkb

End Function


Public Function ExcelQueryDatos(pQry As String, pWorksheets As Object, pRange As String) As Boolean

   Dim rsPubs As ADODB.Recordset
   Dim lRetVal As Boolean
  ' [3]. Copiamos las extensiones
   Set rsPubs = New ADODB.Recordset
     
   rsPubs.Open pQry, DefaultDB, adOpenStatic
   ' Copy the records into cell A1 on Sheet1.
   pWorksheets.Range(pRange).CopyFromRecordset rsPubs
   
   rsPubs.Close
   
   Set rsPubs = Nothing
   
   ExcelQueryDatos = lRetVal

End Function
