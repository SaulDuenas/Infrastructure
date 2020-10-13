VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMain 
   Caption         =   "Transposed Files"
   ClientHeight    =   1545
   ClientLeft      =   6690
   ClientTop       =   7950
   ClientWidth     =   5220
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   1545
   ScaleWidth      =   5220
   Begin VB.OptionButton opttsc 
      Caption         =   "Formato TSV"
      Height          =   195
      Left            =   120
      TabIndex        =   4
      Top             =   1080
      Width           =   1335
   End
   Begin VB.OptionButton optcsv 
      Caption         =   "Formato CSV"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   720
      Value           =   -1  'True
      Width           =   1335
   End
   Begin MSComDlg.CommonDialog dlgSeleccion 
      Left            =   3960
      Top             =   1680
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DialogTitle     =   "Eliga un archivo"
      Filter          =   "Archivos csv|*.csv| Archivos tsv|*.tsv"
   End
   Begin VB.CommandButton cmdSelecciona 
      Caption         =   "Seleccionar"
      Height          =   375
      Left            =   4020
      TabIndex        =   1
      Top             =   1020
      Width           =   1035
   End
   Begin VB.CommandButton cmdTransponer 
      Caption         =   "Transponer"
      Enabled         =   0   'False
      Height          =   375
      Left            =   2820
      TabIndex        =   0
      Top             =   1020
      Width           =   1035
   End
   Begin VB.Label lblRuta 
      BackColor       =   &H8000000E&
      BorderStyle     =   1  'Fixed Single
      Height          =   315
      Left            =   60
      TabIndex        =   2
      Top             =   180
      Width           =   5055
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Dim mDatosTrans() As String
Dim mDataRef() As String
Dim mMaxX As Integer
Dim mMaxY As Integer
Dim mFilter As String
Dim mFileName As String
Dim mSeparator As String

Option Explicit

Private Sub Form_Load()
   
   ' centro ventana
   Me.Top = (Screen.Height - Me.Height) / 2
   Me.Left = (Screen.Width - Me.Width) / 2
   optcsv_Click

End Sub

Private Sub optcsv_Click()
   mFilter = "Archivos csv|*.csv"
   mFileName = "Trans.csv"
   mSeparator = ","
End Sub

Private Sub opttsc_Click()
   mFilter = "Archivos tsv|*.tsv"
   mFileName = "Trans.tsv"
   mSeparator = Chr(9)
End Sub



Private Sub cmdSelecciona_Click()
   'Seleccionar Archivo svc
   dlgSeleccion.Flags = cdlOFNCreatePrompt + cdlOFNOverwritePrompt
   dlgSeleccion.DialogTitle = "Eliga un archivo"
   dlgSeleccion.Filter = "Archivos csv|*.csv| Archivos tsv|*.tsv"
   dlgSeleccion.FileName = ""
   dlgSeleccion.ShowOpen
   
   lblRuta.Caption = dlgSeleccion.FileName
   If dlgSeleccion.FileName <> "" Then mDatosTrans = ReadTextFile(dlgSeleccion.FileName)
   
   cmdTransponer.Enabled = dlgSeleccion.FileName <> ""
   
   
End Sub

Function ReadTextFile(lRuta As String) As String()
      
   Dim lLineofText As String
   Dim lLineSplit() As String
   Dim i As Integer
   Dim j As Integer
   Dim lFile As String
   Dim lRetData() As String
               
   i = 1
   mMaxX = 0
   mMaxY = 0
   
   On Error GoTo ErrCancelar
     
   lFile = Right(lRuta, 4)
          
   If lFile = ".csv" Or lFile = ".tsv" Then
       ' Open the file for Input.
      Open lRuta For Input As #1
      
      ' Read each line of the text file into a single string
      ' variable.
      Do While Not EOF(1)
         Line Input #1, lLineofText
         ' Generamos las subcadenas con el separador correspondiente
         lLineSplit = Split(lLineofText, IIf(lFile = ".csv", ",", Chr(9)))
         ' Actualizamos el la referencia del tamaño de las dimension
         mMaxY = i
         If (UBound(lLineSplit) + 1) > mMaxX Then mMaxX = (UBound(lLineSplit) + 1)
         
         ' Redimensionamos nuestra matriz
         ReDim Preserve lRetData(1 To mMaxX, 1 To mMaxY)
         
         ' Almacenamos los datos de forma transpuesta
         For j = 1 To mMaxX Step 1
            
            lRetData(j, i) = lLineSplit(j - 1)
         
         Next j
         
         i = i + 1
      
      Loop
      
         
   Else
      Call MsgBox("Archivo con extensión incorrecto !", vbInformation)
      
   End If
   GoTo Fin
Fin:
    ' Close the file.
   Close #1
   ReadTextFile = lRetData
   Exit Function
   
ErrCancelar:
   
   Call MsgBox("ERROR!!!: " & Err.Number & ": " & Err.Description & vbCrLf, vbOKOnly + vbCritical)
   
   Resume Fin
  
      
   End Function

Private Sub cmdTransponer_Click()

   dlgSeleccion.Flags = cdlOFNCreatePrompt + cdlOFNOverwritePrompt
   dlgSeleccion.DialogTitle = "Guardar archivo como..."
   dlgSeleccion.FileName = mFileName
   dlgSeleccion.Filter = mFilter
   dlgSeleccion.ShowSave
   
   If dlgSeleccion.FileName <> mFileName Then GeneraTranspuesto (dlgSeleccion.FileName)

End Sub


Private Sub GeneraTranspuesto(lRuta As String)
   Dim i As Integer
   Dim j As Integer
   Dim lLineofText() As String
   ' Generamos el Archivo Transpuesto
   ' i = InStr(Ruta, IIf(optcsv, ".csv", ".tsv"))
    On Error GoTo ErrCancelar
   Open lRuta For Output As #1
   
   For i = 1 To mMaxX
      ReDim lLineofText(1 To 1)
      For j = 1 To mMaxY
        
         ReDim Preserve lLineofText(1 To j)
         lLineofText(j) = mDatosTrans(i, j)
         
      Next j
      ' Escribimos la linea en el archivo
      Print #1, Join(lLineofText, mSeparator)
   
   Next i
  
   Call MsgBox("Archivo con extensión csv/tsv fue generado en la ruta especificada !", vbInformation)
   GoTo Fin

Fin:
    ' Close the file.
   Close #1
   Exit Sub
   
ErrCancelar:
   
   Call MsgBox("ERROR!!!: " & Err.Number & ": " & Err.Description & vbCrLf, vbOKOnly + vbCritical)
   Resume Fin
   
   
End Sub




