VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsExcel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
  
'local variable(s) to hold property value(s)
Private mvarobjXL As Object 'local copy
Private mvarobjWkb As Object 'local copy
'local variable(s) to hold property value(s)
Private mvarBookFileName As String 'local copy

Public Property Let BookFileName(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.BookFileName = 5
    mvarBookFileName = vData
End Property


Public Property Get BookFileName() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.BookFileName
    BookFileName = mvarBookFileName
End Property


Public Property Set objWkb(ByVal vData As Object)
Attribute objWkb.VB_Description = "Objeto contenedor del archivo"
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.objWkb = Form1
    Set mvarobjWkb = vData
End Property


Public Property Get objWkb() As Object
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.objWkb
    Set objWkb = mvarobjWkb
End Property



Public Property Set objXL(ByVal vData As Object)
Attribute objXL.VB_Description = "Objeto contenedor de la aplicacion"
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.objXL = Form1
    Set mvarobjXL = vData
End Property


Public Property Get objXL() As Object
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.objXL
    Set objXL = mvarobjXL
End Property


Public Function ExcelOpen(pBookFileName As String) As Object
   
   mvarBookFileName = pBookFileName
 
   'Set lobjXL = New Excel.Application      '
   Set mvarobjXL = CreateObject("Excel.Application")
   
   mvarobjXL.Visible = False
   mvarobjXL.DisplayAlerts = False
   Set mvarobjWkb = mvarobjXL.Workbooks.Open(mvarBookFileName, , False)
   
   Set ExcelOpen = mvarobjWkb
   
End Function


Public Function HojaAbrir(Worksheet As String) As Object

  Set HojaAbrir = mvarobjWkb.Worksheets(Worksheet)

End Function


Public Function TerminarExcel() As Object
   
   Dim lRetVal As Boolean
   
   'Guardar Archivo
   If Not (mvarobjWkb Is Nothing) Then
      
      mvarobjWkb.Save
      ' Cierra excel
      mvarobjWkb.Close False
      
      Set mvarobjWkb = Nothing
      
      'Termina Excel
      
      mvarobjXL.Application.Workbooks.Close
      mvarobjXL.Quit
      Set mvarobjXL = Nothing
      
   End If
   
   Set TerminarExcel = mvarobjWkb

End Function


Public Function ExcelQueryDatos(pQry As String, pWorksheet As String, pRange As String) As Object

   Dim lWorksheet As Object
   Dim rsPubs As ADODB.Recordset
   Dim lRetVal As Boolean
  ' [3]. Copiamos las extensiones
   Set rsPubs = New ADODB.Recordset
   
   ' Abrimos la hoja de calculo
   
   Set lWorksheet = HojaAbrir(pWorksheet)
     
    On Error GoTo ErrFn
   rsPubs.Open pQry, DefaultDB, adOpenStatic
   ' Copy the records into cell A1 on Sheet1.
   lWorksheet.Range(pRange).CopyFromRecordset rsPubs
   GoTo Fin
   
ErrFn:
   FNReportaError "ERROR ExcelQueryDatos: " & Err.Number & ": " & Err.Description & vbCrLf
   Resume Fin
Fin:
   
   rsPubs.Close
   Set rsPubs = Nothing
   
   Set ExcelQueryDatos = lWorksheet

End Function



