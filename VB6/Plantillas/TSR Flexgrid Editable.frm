VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form frmGridEditable 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Grid editable"
   ClientHeight    =   3135
   ClientLeft      =   2400
   ClientTop       =   2040
   ClientWidth     =   5310
   Icon            =   "TSR Flexgrid Editable.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3135
   ScaleWidth      =   5310
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdAplicar 
      Caption         =   "A&plicar"
      Height          =   375
      Left            =   3540
      TabIndex        =   6
      Top             =   2640
      Width           =   1275
   End
   Begin VB.TextBox txtEdit 
      Alignment       =   1  'Right Justify
      BorderStyle     =   0  'None
      Height          =   615
      Left            =   3360
      TabIndex        =   7
      Text            =   "txtEdit"
      Top             =   1020
      Width           =   975
   End
   Begin VB.CommandButton cmdDelRow 
      Height          =   315
      Left            =   4980
      Picture         =   "TSR Flexgrid Editable.frx":000C
      Style           =   1  'Graphical
      TabIndex        =   3
      ToolTipText     =   "Borrar Renglón (CTRL-B)"
      Top             =   720
      Width           =   255
   End
   Begin VB.CommandButton cmdNewRow 
      Height          =   315
      Left            =   4980
      Picture         =   "TSR Flexgrid Editable.frx":034E
      Style           =   1  'Graphical
      TabIndex        =   2
      ToolTipText     =   "Nuevo Renglón (CTRL-N)"
      Top             =   300
      Width           =   255
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&Aceptar"
      Height          =   375
      Left            =   780
      TabIndex        =   4
      Top             =   2640
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   375
      Left            =   2160
      TabIndex        =   5
      Top             =   2640
      Width           =   1275
   End
   Begin MSFlexGridLib.MSFlexGrid grdGridEditable 
      Height          =   2115
      Left            =   120
      TabIndex        =   1
      Top             =   300
      Width           =   4755
      _ExtentX        =   8387
      _ExtentY        =   3731
      _Version        =   393216
      Cols            =   3
      FixedCols       =   0
      FocusRect       =   2
      ScrollBars      =   2
      FormatString    =   ">Límite Inferior|> Valor Nominal|> Límite Superior"
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Datos:"
      Height          =   195
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   465
   End
   Begin VB.Menu mnuGrd 
      Caption         =   "PopUp Menu para Grid"
      Visible         =   0   'False
      Begin VB.Menu mnuGridNewRow 
         Caption         =   "Nuevo Renglón"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuGridDelRow 
         Caption         =   "Borrar Renglón"
         Shortcut        =   ^B
      End
   End
End
Attribute VB_Name = "frmGridEditable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' frmGridEditable.frm - Teseracto (c) 2005
'                    Ing. Miguel A. Torres-Orozco Bermeo.
' Proyecto:
' Módulo:

'Forma para usar como plantilla de Grid Editable
'Requiere TSR_FG.bas

Option Explicit

'*** Constantes del módulo ***
'Anchos de las columnas del grid grdGridEditable
Private Const CW_Columna1 = 1465
Private Const CW_Columna2 = 1465
Private Const CW_Columna3 = 1465
'Private Const CW_VARIABLE = 0



Private mOK As Boolean            'Indica si se oprimió OK
Private mGridModified As Boolean  'Indica si el usuario realizó cambios en el grid
                              

Sub Presenta()
   
   'Inicia
   mGridModified = False
   
   'Carga la forma
   Load Me
   
   'Llena los controles
   
'   '****2. A partir de la clave de la variable hacer queries
'   '       para llenar el grid (Seleccionar el primer elemento)
'   lQry$ = " SELECT LimInf, ValorNominal, LimSup FROM Frecuencias WHERE Variable=" & mVariable
'
'   If Not FGLlenar(grdGridEditable, lQry$) Then
'      FNErrorBox "No se pudo leer el catálogo de Frecuencias"
'   Else
'      'Selecciona el 1er renglón
'      If grdGridEditable.Rows > 1 Then
'      FGSelectRow grdGridEditable, 1
'      Else
'      cmdImprimir.Enabled = False
'
'      End If
'   End If
   
   '(Des)Habilita Botones
   EnableButtons
   cmdAplicar.Enabled = False
   
   'Presenta la forma
   Me.Show vbModal
      
Salida:
   'Descarga la forma
   Unload Me
   
End Sub

'Funcion que borra y actualiza los datos del grid en la base de datos
'Regresa True si se actualizo con exito
Private Function UpdateGrid() As Boolean
' Dim lQry$
' Dim i As Integer
'
'   'Inicia
'   FNMouseEspera True
'
'   'Borra las frecuencias de la tabla pertenecientes a la variable
'   lQry$ = "DELETE FROM Frecuencias WHERE Variable=" & mVariable
'   If Not DBEjecutar(lQry$) Then GoTo ExitError
'
'
'   'Escribe en la tabla Frecuencias el contenido del grid
'   For i = 1 To grdGridEditable.Rows - 1
'      'Inserta Renglon
'      lQry$ = "INSERT INTO Frecuencias (Variable, ValorNominal, LimInf, LimSup) " & _
'            "     VALUES (" & mVariable & "," & FGLeeDato(grdGridEditable, i, 1) & "," & FGLeeDato(grdGridEditable, i, 0) & "," & FGLeeDato(grdGridEditable, i, 2) & ")"
'      If Not DBEjecutar(lQry$) Then GoTo ExitError
'   Next i
'
'   FNMouseEspera False
'   UpdateGrid = True
'   cmdImprimir.Enabled = False
'   Exit Function
'
''Rutina de error
'ExitError:
'   'Avisa al usuario
'   FNMouseEspera False
'   FNExclamBox ("No se pudo guardar los cambios, intente de nuevo.")
'   UpdateGrid = False
End Function

Private Sub cmdAplicar_Click()
'  Dim lRenglon As Variant, lFila As Variant
'   'Valida la Forma
'   If Valida(lRenglon, lFila) Then
'
'       'Si hubo cambios actualiza
'      If mGridModified Then
'         'Si actualizo correctamente, actualiza el grid
'         UpdateGrid
'         'habilita el boton de impresion
'         cmdImprimir.Enabled = True
'         cmdAplicar.Enabled = False
'         mGridModified = False
'      End If
'
'   Else
'      grdGridEditable.SetFocus
'      grdGridEditable.Row = lRenglon
'      grdGridEditable.Col = lFila
'   End If
End Sub

'Oprimió OK
Private Sub cmdOK_Click()
' Dim lRenglon As Variant, lFila As Variant
'   'Valida la Forma
'   If Valida(lRenglon, lFila) Then
'      'Indica que se oprimio OK
'      mOK = True
'
'      'Si hubo cambios actualiza
'      If mGridModified Then
'         'Si actualizo correctamente, oculta la forma
'         If UpdateGrid() Then Me.Hide
'      Else
'         'Sale sin guardar
'         Me.Hide
'      End If
'
'   Else
'      grdGridEditable.SetFocus
'      grdGridEditable.Row = lRenglon
'      grdGridEditable.Col = lFila
'   End If
   
End Sub

'Oprimió Cancel
Private Sub cmdCancel_Click()
   'Oculta el formulario
   mOK = False
   Me.Hide
End Sub



'Valida los datos capturados en la forma

Private Function Valida(pRenglon As Variant, pFila As Variant) As Boolean
 'pRenglon   -(OUT)  Regresa el renglon donde se encuentra el error
 'pFila      -(OUT)  Regresa la fila donde se encuentra el error
 'Si no hay error regresa (0,0)
 Dim lMsg$, lOK As Boolean
 Dim i As Integer, j As Integer, lCeldaError As Integer
 Dim lLimInf As Variant, lLimSup As Variant, lValorNominal As Variant, lAux As Variant
 Dim lCad$
 
   'Inicia
   lOK = True
'   pRenglon = 0
'   pFila = 0
'
'   '1. Valida que el grid esté lleno correctamente
'   'Recorre Renglones
'   '(al encontrar un error se sale y pone la celda activa en el lugar del error)
'   'Verifica que los 3 datos estén llenos (FGLeeDato)
'
'   For i = 1 To grdGridEditable.Rows - 1
'      'Checar que no esten vacios
'      'Inicializa
'      lLimInf = FGLeeDato(grdGridEditable, i, 0)
'      lValorNominal = FGLeeDato(grdGridEditable, i, 1)
'      lLimSup = FGLeeDato(grdGridEditable, i, 2)
'
'      j = i + 1
'
'      'Verifica si esta vacio el campo limite inicial
'      If Trim(lLimInf) = "" Then
'         lOK = False
'         lMsg$ = "Debe llenar el campo limite Inferior "
'         lCeldaError = 0
'         GoTo ExitValida
'      End If
'
'      'Verifica si esta vacio el campo valor nominal
'      If Trim(lValorNominal) = "" Then
'         lOK = False
'         lMsg$ = "Debe llenar el campo valor nominal"
'         lCeldaError = 1
'         GoTo ExitValida
'      End If
'
'      'Verifica si esta vacio el campo limite superior
'      If Trim(lLimSup) = "" Then
'         lOK = False
'         lMsg$ = "Debe llenar el campo limite superior "
'         lCeldaError = 2
'         GoTo ExitValida
'      End If
'
'      'Verifica si esta vacio el campo limite inferior de la siguiente corrida
'      If j < grdGridEditable.Rows Then
'         lAux = FGLeeDato(grdGridEditable, j, 0)
'         If Trim(lAux) = "" Then
'            lOK = False
'            lMsg$ = "Debe llenar el campo limite Inferior"
'            i = i + 1
'            lCeldaError = 0
'            GoTo ExitValida
'         End If
'      End If
'
'      'Convirte los datos a  formato Numerico
'      lLimInf = CDbl(lLimInf)
'      lValorNominal = CDbl(lValorNominal)
'      lLimSup = CDbl(lLimSup)
'      lAux = CDbl(lAux)
'
'      'Verifica  LimInf < ValorNominal
'      If lLimInf >= lValorNominal Then
'         lOK = False
'         lMsg$ = "El limite inferior tiene que ser menor que el Valor nominal"
'         lCeldaError = 0
'         GoTo ExitValida
'      End If
'
'      'Verifica ValorNominal < LimSup
'      If lValorNominal >= lLimSup Then
'         lOK = False
'         lMsg$ = "El Valor Nominal tiene que ser menor al limite Superior"
'         lCeldaError = 1
'         GoTo ExitValida
'      End If
'
'      'Verifica si el limite inferior es igual que el limite superior anterior
'      If j < grdGridEditable.Rows Then
'            If Not lLimSup = lAux Then
'               lOK = False
'               lMsg$ = "El limite Superior debe ser igual al siguiente limite inferior"
'               lCeldaError = 2
'               GoTo ExitValida
'            End If
'      End If
'
'   Next i
'
'
'ExitValida:
'   If Not lOK Then
'      FNExclamBox lMsg$
'      pRenglon = i
'      pFila = lCeldaError
'   End If
   
ExitRapido:
   Valida = lOK
   
End Function



'Inserta Renglón
Private Sub cmdNewRow_Click()
   'Inserta Renglón
   grdGridEditable.AddItem "", grdGridEditable.Row + 1
   'Habilita botón de borrar
   EnableButtons
   grdGridEditable.HighLight = flexHighlightWithFocus
   
   'Envía foco al grid
   grdGridEditable.SetFocus
   
   'Hubo Cambios
   mGridModified = True
   cmdAplicar.Enabled = True
End Sub


'Inserta Renglón
Private Sub mnuGridNewRow_Click()
   cmdNewRow_Click
End Sub

'Borra Renglón
Private Sub cmdDelRow_Click()
   
   'Borra renglón
   If grdGridEditable.Rows > 2 Then
      grdGridEditable.RemoveItem grdGridEditable.Row
   ElseIf grdGridEditable.Rows = 2 Then
      'Caso especial al eliminar el último renglón
      grdGridEditable.Rows = 1
      grdGridEditable.HighLight = flexHighlightNever
      EnableButtons
      cmdImprimir.Enabled = False
      cmdAplicar.Enabled = True
   End If
   'Envía foco al grid
   grdGridEditable.SetFocus
   'Hubo Cambios
   mGridModified = True

End Sub

'Borra Renglón
Private Sub mnuGridDelRow_Click()
   cmdDelRow_Click
End Sub

Private Sub Form_Load()
   
   'Fija ancho de columnas
   With grdGridEditable
      .ColWidth(0) = CW_Columna1
      .ColWidth(1) = CW_Columna2
      .ColWidth(2) = CW_Columna3
      'Evita la seleccion del encabezado
      .HighLight = flexHighlightNever
   End With
   
   'Limpia txtEdit
   txtEdit = ""
   txtEdit.Visible = False
End Sub

'Muestra popupmenu
Private Sub grdGridEditable_MouseDown(Button As Integer, Shift As Integer, X As Single, y As Single)
   If Button = vbRightButton Then PopupMenu mnuGrd
End Sub


'(Des)Habilita el botón de Borrar, según sea el caso
Private Sub EnableButtons()
 Dim lEnabled As Boolean
   
   'Habilita si hay elementos en el grid
   lEnabled = (grdGridEditable.Rows > 1)
   
   '(Des)Habilita los botones
   cmdDelRow.Enabled = lEnabled
   mnuGridDelRow.Enabled = lEnabled
   
End Sub



'**********************************************************************************
'***** Rutinas de edición de grid
'**********************************************************************************

Sub FGCopyTxt(MSFlexGrid As Control, Edt As Control)
   'Copia el texto de un control text a la celda activa del grid
   'Debe ser llamada porlos eventos LeaveCell(), GotFocus(), Scroll() de MSFlexGrid
   If Not Edt.Visible Then Exit Sub
   'If Not FNValidarNumero(Edt, V_Double) Then Exit Sub
   MSFlexGrid = Edt
   Edt.Visible = False
   
   'Indica que hubo cambios en valores
   mGridModified = True
   'Deshabilita impresión
   cmdAplicar.Enabled = True
End Sub

'Edita la celda
Private Sub grdGridEditable_DblClick()
   If CeldaEditable Then
      MSFlexGridEdit grdGridEditable, txtEdit, 32 ' Simulate a space.
   End If
End Sub

'Edita la celda
Private Sub grdGridEditable_KeyPress(KeyAscii As Integer)
   If CeldaEditable Then
      MSFlexGridEdit grdGridEditable, txtEdit, KeyAscii
   End If
End Sub


'Verifica si la celda es editable
Private Function CeldaEditable() As Boolean
 Dim lEdit As Boolean
   
   'Todas son editables (menos el header)
   lEdit = (grdGridEditable.Row > 0)
   
   'Regresa
   CeldaEditable = lEdit
End Function


'Actualiza la celda
Private Sub grdGridEditable_LeaveCell()
   FGCopyTxt grdGridEditable, txtEdit
End Sub

'Actualiza la celda
Private Sub grdGridEditable_GotFocus()
   FGCopyTxt grdGridEditable, txtEdit
End Sub

'Actualiza la celda
Private Sub grdGridEditable_Scroll()
   FGCopyTxt grdGridEditable, txtEdit
End Sub

'Actualiza la celda
Private Sub txtEdit_LostFocus()
   FGCopyTxt grdGridEditable, txtEdit
End Sub

Private Function Fgi(r As Integer, c As Integer) As Integer
   Fgi = c + grdGridEditable.Cols * r
End Function

Private Sub MSFlexGridEdit(MSFlexGrid As Control, Edt As Control, KeyAscii As Integer)
   
   ' Use the character that was typed.
   Select Case KeyAscii

   ' A space means edit the current text.
   Case 0 To 32
      Edt = MSFlexGrid
      Edt.SelStart = 1000

   ' Anything else means replace the current text.
   Case Else
      Edt = Chr(KeyAscii)
      Edt.SelStart = 1
   End Select

   ' Show Edt at the right place.
   Edt.Move MSFlexGrid.CellLeft + MSFlexGrid.Left, MSFlexGrid.CellTop + MSFlexGrid.Top, _
   MSFlexGrid.CellWidth, MSFlexGrid.CellHeight
   
   Edt.Visible = True

   ' And let it work.
   Edt.SetFocus
End Sub

Private Sub txtEdit_KeyDown(KeyCode As Integer, Shift As Integer)
   EditKeyCode grdGridEditable, txtEdit, KeyCode, Shift
End Sub

Private Sub txtEdit_KeyPress(KeyAscii As Integer)
   ' Delete returns to get rid of beep.
   If KeyAscii = Asc(vbCr) Then KeyAscii = 0
End Sub

Sub EditKeyCode(MSFlexGrid As Control, Edt As _
Control, KeyCode As Integer, Shift As Integer)

   ' Standard edit control processing.
   Select Case KeyCode

   Case 27  ' ESC: hide, return focus to MSFlexGrid.
      Edt.Visible = False
      MSFlexGrid.SetFocus

   Case 13  ' ENTER return focus to MSFlexGrid.
      MSFlexGrid.SetFocus

   Case 38     ' Up.
      MSFlexGrid.SetFocus
      DoEvents
      If MSFlexGrid.Row > MSFlexGrid.FixedRows Then
         MSFlexGrid.Row = MSFlexGrid.Row - 1
      End If

   Case 40     ' Down.
      MSFlexGrid.SetFocus
      DoEvents
      If MSFlexGrid.Row < MSFlexGrid.Rows - 1 Then
         MSFlexGrid.Row = MSFlexGrid.Row + 1
      End If
   End Select
End Sub

