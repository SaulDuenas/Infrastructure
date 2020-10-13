VERSION 5.00
Begin VB.Form MANTENIMIENTO 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "MANTENIMIENTO"
   ClientHeight    =   4365
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7620
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   4365
   ScaleWidth      =   7620
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command2 
      Caption         =   "R&egistrar"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5160
      TabIndex        =   12
      Top             =   1440
      Width           =   2055
   End
   Begin VB.CommandButton Command1 
      Caption         =   "&Regresar"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5160
      TabIndex        =   11
      Top             =   720
      Width           =   2055
   End
   Begin VB.TextBox in_lote 
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   380
      Left            =   2400
      TabIndex        =   9
      Top             =   2880
      Width           =   1700
   End
   Begin VB.TextBox in_linea 
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   380
      Left            =   2400
      TabIndex        =   8
      Top             =   2280
      Width           =   1700
   End
   Begin VB.TextBox in_pn 
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   380
      Left            =   2400
      TabIndex        =   7
      Top             =   1680
      Width           =   1700
   End
   Begin VB.TextBox in_pb 
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   380
      Left            =   2400
      TabIndex        =   6
      Top             =   1080
      Width           =   1700
   End
   Begin VB.TextBox in_bala 
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   380
      Left            =   2400
      TabIndex        =   5
      Top             =   480
      Width           =   1700
   End
   Begin VB.Label LBLERM 
      BorderStyle     =   1  'Fixed Single
      Height          =   615
      Left            =   120
      TabIndex        =   10
      Top             =   3480
      Width           =   7335
   End
   Begin VB.Label Label5 
      BorderStyle     =   1  'Fixed Single
      Caption         =   "No. de LOTE"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   255
      TabIndex        =   4
      Top             =   2880
      Width           =   1695
   End
   Begin VB.Label Label4 
      BorderStyle     =   1  'Fixed Single
      Caption         =   "No. de LINEA"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   255
      TabIndex        =   3
      Top             =   2280
      Width           =   1695
   End
   Begin VB.Label Label3 
      BorderStyle     =   1  'Fixed Single
      Caption         =   "PESO NETO"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   255
      TabIndex        =   2
      Top             =   1680
      Width           =   1695
   End
   Begin VB.Label Label2 
      BorderStyle     =   1  'Fixed Single
      Caption         =   "PESO BRUTO"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   255
      TabIndex        =   1
      Top             =   1080
      Width           =   1695
   End
   Begin VB.Label Label1 
      BorderStyle     =   1  'Fixed Single
      Caption         =   "No. de BALA"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   380
      Left            =   250
      TabIndex        =   0
      Top             =   480
      Width           =   1700
   End
End
Attribute VB_Name = "MANTENIMIENTO"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public out_bala As String
Public out_pb As String
Public out_pn As String
Public out_linea As String
Public out_lote As String


Private Sub Command1_Click()
    Unload MANTENIMIENTO
    Unload MANTTO_PASSWD
    Principal.SetFocus
End Sub

Private Sub Command2_Click()

Dim man_tiempo As String
Dim man_balaspc As String
Dim man_fecha As String
Dim ret_man As String
Dim n_bala As Double
Dim n_pb As Single
Dim n_pn As Single
Dim n_linea As Integer
Dim n_lote As String
Dim querym As String

On Error GoTo no_base

man_msg = ""

    If Not IsNumeric(in_bala.Text) Then
        LBLERM.Caption = "BALA: Debe ser un Dato Numerico Entero"
        in_bala.SetFocus
        in_bala.SelStart = 0
    Else
        n_bala = CDbl(in_bala.Text)
        If n_bala < 500000000 Or n_bala > 599999999# Then
            LBLERM.Caption = "Bala Error : Rango -> [500000000 - 599999999]"
            in_bala.SetFocus
            in_bala.SelStart = 0
        Else
            out_bala = CStr(n_bala)
            If Not IsNumeric(in_pb.Text) Then
                LBLERM.Caption = "Peso Bruto: Debe ser un dato Numérico Decimal"
                in_pb.SetFocus
                in_pb.SelStart = 0
            Else
                n_pb = CSng(in_pb.Text)
                If n_pb = 0 Then
                    LBLERM.Caption = "Peso Bruto: Debe ser Mayor a Cero"
                    in_pb.SetFocus
                    in_pb.SelStart = 0
                Else
                    out_pb = CStr(n_pb)
                    If Not IsNumeric(in_pn.Text) Then
                        LBLERM.Caption = "Peso Neto: Debe ser Dato Numerico Decimal"
                        in_pn.SetFocus
                        in_pn.SelStart = 0
                    Else
                        n_pn = CSng(in_pn.Text)
                        If n_pn = 0 Then
                            LBLERM.Caption = "Peso Neto Debe ser MAyor a Cero"
                            in_pn.SetFocus
                            in_pn.SelStart = 0
                        Else
                            out_pn = CStr(n_pn)
                            If Not IsNumeric(in_linea.Text) Then
                                LBLERM.Caption = "Linea: Debe ser un Dato Numerico"
                                in_linea.SetFocus
                                in_linea.SelStart = 0
                            Else
                                n_linea = CInt(in_linea.Text)
                                If n_linea < 1 Or n_linea > 9 Then
                                    LBLERM.Caption = "Linea Error: Rango -> [1-9]"
                                    in_linea.SetFocus
                                    in_linea.SelStart = 0
                                Else
                                    out_linea = CStr(in_linea.Text)
                                    
                                    n_lote = CStr(in_lote.Text)
                                    If n_lote = "0" Then
                                        LBLERM.Caption = "Lote: Debe ser Mayor a Cero"
                                        in_lote.SetFocus
                                        in_lote.SelStart = 0
                                    Else
                                        out_lote = CStr(n_lote)
                                        man_fecha = Format(Now, "dd-mmm-yy")
                                        man_tiempo = Format(Now, "hh:mm:ss")
                                        man_balaspc = out_bala + "," + man_fecha + "," + out_pb + "," + out_pn + "," + man_tiempo + ",1," + out_linea + "," + out_lote + ",1"
                                        
                                        ' grava en servidor SQL
                                        Call conecta
                                        query = "Select * from bala where numero = " + out_bala
                                        ' aqui mando la estructura de escritura sobre recordset
                                        Set rs = CreateObject("ADODB.Recordset")
                                        rs.CursorType = adOpenKeyset
                                        rs.LockType = adLockOptimistic
                                        rs.Open query, cnn1
                                        ' abriendo un nuevo registro en la tabla
                                        rs.AddNew
                                        rs("numero") = out_bala
                                        rs("FECHAPRODUCCION") = man_fecha
                                        rs("MASABRUTA") = out_pb
                                        rs("MASANETA") = out_pn
                                        hora_produccion = Format(CDate("01/01/00 " + man_tiempo), "dd-mmm-yy hh:mm:ss")
                                        rs("HORAPRODUCCION") = hora_produccion
                                        rs("CVEESTADOBALA") = 1
                                        rs("NUMLINEA") = out_linea
                                        rs("CVELOTE") = out_lote
                                        rs("CVEPLANTAORIGEN") = 1
                                        rs.Update
                                        rs.Close
                                        Call desconecta
                                        Open "c:\cont\balas.sav" For Append Access _
                                            Write Shared As #6
                                                Print #6, man_balaspc
                                            Close #6
                                        in_bala.Text = 0
                                        in_pb.Text = "0.0"
                                        in_pn.Text = "0.0"
                                        in_linea.Text = 0
                                        in_lote.Text = 0
                                        LBLERM.Caption = "Se Inserto El Registro de la Bala Correctamente"
                                    End If
                                End If
                            End If
                        End If
                    End If
                End If
            End If
        End If
    End If
    Exit Sub
    
no_base:
    MANTENIMIENTO.BackColor = &HFFFF&
End Sub

Private Sub Form_Load()
'    MANTENIMIENTO.Height = Screen.Height
'    MANTENIMIENTO.Width = Screen.Width
'    MANTENIMIENTO.Top = (Screen.Height / 2) - MANTENIMIENTO.Height / 2
 '   MANTENIMIENTO.Left = (Screen.Width / 2) - Screen.Width / 2
End Sub

