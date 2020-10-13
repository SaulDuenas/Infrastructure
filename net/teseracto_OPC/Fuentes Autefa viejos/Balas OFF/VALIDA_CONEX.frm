VERSION 5.00
Begin VB.Form VALIDA_CONEX 
   Caption         =   "VALIDA CONEXION"
   ClientHeight    =   2790
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   13245
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   2790
   ScaleWidth      =   13245
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   10000
      Left            =   7200
      Top             =   1080
   End
   Begin VB.Label lblmsgc 
      Height          =   375
      Left            =   360
      TabIndex        =   3
      Top             =   2400
      Width           =   12135
   End
   Begin VB.Label Label2 
      Height          =   255
      Left            =   360
      TabIndex        =   2
      Top             =   1920
      Width           =   11895
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   735
      Left            =   360
      TabIndex        =   1
      Top             =   360
      Width           =   11895
   End
   Begin VB.Label Label3 
      Caption         =   "C:\cont\balas.off"
      Height          =   255
      Left            =   480
      TabIndex        =   0
      Top             =   1440
      Width           =   4095
   End
End
Attribute VB_Name = "VALIDA_CONEX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
    Label1.Caption = "PREPARANDO ENVIO DE BALAS.OFF A SERVIDOR..."
    Timer1.Enabled = False

 Call Open_balasOFF
End Sub

Public Sub Open_balasOFF()
Dim i As Integer
Dim j As Integer
Dim cartem(1 To 100) As Variant
Dim leepas(1 To 100) As String * 53
Dim k(1 To 100, 1 To 100) As Integer
Dim m As Integer
Dim balaOFF(1 To 100) As String
Dim fechaOFF(1 To 100) As String
Dim peso_brutoOFF(1 To 100) As String
Dim peso_netoOFF(1 To 100) As String
Dim tiempoOFF(1 To 100) As String
Dim lineaOFF(1 To 100) As String
Dim loteOFF(1 To 100) As String
Dim reg_balaspcOFF(1 To 100) As String
Dim n(1 To 100)  As Integer
Dim o As Integer
Dim p As Integer


Dim ban_activa As Integer
Dim gra_lin As Integer
Dim query As String
Dim hora_produccion As Date
Dim nomarch As String

o = 1
m = 1
p = 0


nomarch = ""
nomarch = Dir("c:\cont\balas.off")
If nomarch <> "balas.off" Then
 Label1.Caption = "No existen Balas a R E C U P E R A R "
    Timer1.Enabled = True
    Else
    
  For o = 1 To 100
n(o) = 0
Next o


For m = 1 To 100 ' capacidad de leer 100 renglones
Open "c:\cont\balas.off" For Random As m Len = 53
Get m, m, leepas(m)
Close m
Next m


For m = 1 To 100  'Renglones
j = 0
For i = 1 To Len(leepas(m)) 'Columnas
    cartem(m) = Asc(Mid(leepas(m), i, 1))
    If cartem(m) = 44 Then
    j = j + 1
    k(m, j) = i ' Apuntador No. de renglon y no. columna
    n(m) = j
    End If
Next i
   If n(m) = 8 Then
    p = p + 1 'No. de renglones balas
    End If
Next m



For m = 1 To p

If n(m) = 8 Then

balaOFF(m) = Mid(leepas(m), 1, (k(m, 1) - 1))
fechaOFF(m) = Mid(leepas(m), (k(m, 1) + 1), ((k(m, 2) - k(m, 1)) - 1))
peso_brutoOFF(m) = Mid(leepas(m), (k(m, 2) + 1), ((k(m, 3) - k(m, 2)) - 1))
peso_netoOFF(m) = Mid(leepas(m), (k(m, 3) + 1), ((k(m, 4) - k(m, 3)) - 1))
tiempoOFF(m) = Mid(leepas(m), (k(m, 4) + 1), ((k(m, 5) - k(m, 4)) - 1))
lineaOFF(m) = Mid(leepas(m), (k(m, 6) + 1), ((k(m, 7) - k(m, 6)) - 1))
loteOFF(m) = Mid(leepas(m), (k(m, 7) + 1), ((k(m, 8) - k(m, 7)) - 1))



reg_balaspcOFF(m) = balaOFF(m) + "," + fechaOFF(m) + "," + peso_brutoOFF(m) + "," + peso_netoOFF(m) + "," + tiempoOFF(m) + ",1," + lineaOFF(m) + "," + loteOFF(m) + ",1"
    
Label2.Caption = reg_balaspcOFF(m)



Err.Clear
On Error GoTo sigue

            If Not IsNumeric(balaOFF(m)) Then
                fr_err = "Bala: Dato no valido, debe ser Numerico"
                ban_error = 1
                Error_formato.Show
            End If
            
            If Not IsNumeric(peso_brutoOFF(m)) Then
                fr_err = "peso bruto: Dato no valido, debe ser Numerico"
                ban_error = 1
                Error_formato.Show
            End If
            
            If Not IsNumeric(peso_netoOFF(m)) Then
                fr_err = "peso neto: Dato no valido, debe ser Numerico"
                ban_error = 1
                Error_formato.Show
            End If
            
            If Not IsNumeric(lineaOFF(m)) Or lineaOFF(m) > "9" Then
                fr_err = "linea: Dato no valido, debe ser Numerico"
                ban_error = 1
                Error_formato.Show
            Else
                If lineaOFF(m) = "3" Then lineaOFF(m) = "4"
                gra_lin = CInt(lineaOFF(m))
            End If
            
            fecha = Format(fechaOFF(m), "dd-mmm-yy")
            tiempo = Format(tiempoOFF(m), "hh:mm:ss")
            
            
            If ban_error = 1 Then
            
               Label1.Caption = fr_err
               
            Else
                ' grabando en base de datos
                Err.Clear
                On Error GoTo outsub
                VALIDA_CONEX.BackColor = &H8000000F
                Call conecta
                query = "Select * from bala where numero = " + balaOFF(m)
                ' aqui mando la estructura de escritura sobre recordset
                Set rs = CreateObject("ADODB.Recordset")
                rs.CursorType = adOpenKeyset
                rs.LockType = adLockOptimistic
                rs.Open query, cnn1
                Label1.Caption = "Escribiendo"
                ' abriendo un nuevo registro en la tabla
                VALIDA_CONEX.FillColor = &HFF00&
                rs.AddNew
                rs("numero") = balaOFF(m)
                rs("FECHAPRODUCCION") = fecha
                rs("MASABRUTA") = peso_brutoOFF(m)
                rs("MASANETA") = peso_netoOFF(m)
                bdtiempo = tiempo
                hora_produccion = Format(CDate("01/01/01 " + bdtiempo), "dd-mmm-yy hh:mm:ss")
                rs("HORAPRODUCCION") = hora_produccion
                rs("CVEESTADOBALA") = 1
                rs("NUMLINEA") = gra_lin
                rs("CVELOTE") = loteOFF(m)
                rs("CVEPLANTAORIGEN") = 1
                rs.Update
                rs.Close
                Call desconecta
                
                Label1.Caption = "Se Inserto El Registro de la Bala Correctamente"
                                
            End If
            
            
            GoTo SALTA
outsub:
        Label1.Caption = "NO SE PUDO insertar bala en base de datos"
        VALIDA_CONEX.BackColor = &HFFFF&
        ' BOTON DE MANTENIMIENTO SE APAGA EL ENABLED
      'Timer1.Enabled = True
    
        
            
        'Exit Sub
       
        
SALTA:


    
        
    'Exit Sub
    
sigue:
    
Else

Call CopyFile

              
End If

Next m

    Call CopyFile
    
    
    End If

Timer1.Enabled = True


End Sub


Private Sub CopyFile()
Dim nomarch As String

   nomarch = ""
    nomarch = Dir("c:\cont\balas.off")
    If nomarch <> "balas.off" Then
        lblmsgc.Caption = "No existen Balas a R E C U P E R A R "
       
    Else
        On Error GoTo falla_c
        FileCopy "c:\cont\balas.off", "c:\cont\ba" + CStr(Format$(Now, "hhmmss")) + ".off"
        FileCopy "c:\cont\balas.off", "d:\BALASCON\balas_ok.off"
        nomarch = Dir("c:\cont\balas.off")
        If nomarch = "balas.off" Then
            Kill "c:\cont\balas.off"
            lblmsgc.Caption = "Copia Efectuada E X I T O S A M E N T E"
        End If
    End If

Exit Sub

falla_c:
   
    Select Case Err.Number
        Case 57
            lblmsgc.Caption = "Transferencia INCOMPLETA, Device I/O ERROR "
        Case 61
            lblmsgc.Caption = "Transferencia INCOMPLETA, Disk d:\> Full "
        Case 68
            lblmsgc.Caption = "Transferencia INCOMPLETA, Device Unavilable "
        Case 70
            lblmsgc.Caption = "Transferencia INCOMPLETA, Disk d:\> is Write Protected "
        Case 71
            lblmsgc.Caption = "Transferencia INCOMPLETA, Disk d:\> Not Ready "
        Case 72
            lblmsgc.Caption = "Transferencia INCOMPLETA, Disk Media Error "
        Case Else
            lblmsgc.Caption = "Transferencia INCOMPLETA, Error no Definido, Consulte al Operador "
        End Select

Timer1.Enabled = True
End Sub





Private Sub Timer1_Timer()
 Err.Clear
   Unload VALIDA_CONEX
    Close
    End
End Sub

