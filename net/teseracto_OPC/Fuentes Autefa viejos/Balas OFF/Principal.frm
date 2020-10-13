VERSION 5.00
Begin VB.Form Principal 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "cd"
   ClientHeight    =   9330
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   12795
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   9330
   ScaleWidth      =   12795
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame Frame9 
      BackColor       =   &H80000009&
      BorderStyle     =   0  'None
      Height          =   1575
      Left            =   0
      TabIndex        =   65
      Top             =   120
      Width           =   2295
      Begin VB.PictureBox Picture3 
         BackColor       =   &H80000009&
         BorderStyle     =   0  'None
         Height          =   1095
         Left            =   120
         Picture         =   "Principal.frx":0000
         ScaleHeight     =   73
         ScaleMode       =   0  'User
         ScaleWidth      =   154.027
         TabIndex        =   66
         Top             =   360
         Width           =   2295
      End
   End
   Begin VB.CommandButton Command4 
      Caption         =   "&Finalizar Aplicacion"
      Height          =   555
      Left            =   7320
      TabIndex        =   64
      Top             =   8160
      Width           =   1695
   End
   Begin VB.CommandButton Command3 
      Caption         =   "C&ambio de Password"
      Height          =   555
      Left            =   5280
      TabIndex        =   63
      Top             =   8160
      Width           =   1695
   End
   Begin VB.CommandButton Command2 
      Caption         =   "&Contingencia"
      Height          =   555
      Left            =   3480
      TabIndex        =   62
      Top             =   8160
      Width           =   1455
   End
   Begin VB.CommandButton Command1 
      Caption         =   "&Mantenimiento"
      Height          =   555
      Left            =   1800
      TabIndex        =   61
      Top             =   8160
      Width           =   1455
   End
   Begin VB.PictureBox Picture2 
      Height          =   2535
      Left            =   240
      OLEDragMode     =   1  'Automatic
      OLEDropMode     =   2  'Automatic
      Picture         =   "Principal.frx":74CA
      ScaleHeight     =   2475
      ScaleWidth      =   795
      TabIndex        =   57
      Top             =   4080
      Width           =   855
   End
   Begin VB.PictureBox Picture1 
      Height          =   3495
      Left            =   11160
      Picture         =   "Principal.frx":7A54
      ScaleHeight     =   3435
      ScaleWidth      =   795
      TabIndex        =   56
      Top             =   1200
      Width           =   855
   End
   Begin VB.Frame Frame8 
      Height          =   1095
      Left            =   0
      TabIndex        =   52
      Top             =   2160
      Width           =   2295
      Begin VB.Label Label19 
         BorderStyle     =   1  'Fixed Single
         Caption         =   "611153"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   720
         TabIndex        =   55
         Top             =   480
         Width           =   735
      End
      Begin VB.Label Label18 
         Caption         =   "SUPPLIER ID"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   6.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   1200
         TabIndex        =   54
         Top             =   120
         Width           =   975
      End
      Begin VB.Label Label17 
         Caption         =   "PROVEEDOR"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   6.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   53
         Top             =   120
         Width           =   975
      End
   End
   Begin VB.Frame Frame7 
      Height          =   1095
      Left            =   2400
      TabIndex        =   48
      Top             =   0
      Width           =   9615
      Begin VB.Timer Timer2 
         Interval        =   1000
         Left            =   0
         Top             =   120
      End
      Begin VB.TextBox RSDSEGUNDO 
         Height          =   405
         Left            =   7680
         LinkItem        =   "S:23"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   51
         Text            =   "34"
         Top             =   600
         Width           =   375
      End
      Begin VB.Timer Timer1 
         Left            =   7680
         Top             =   120
      End
      Begin VB.Label lblhora 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   7800
         TabIndex        =   58
         Top             =   120
         Width           =   1575
      End
      Begin VB.Label Label16 
         BackColor       =   &H00808000&
         Caption         =   "POLYESTER STAPLE"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   2400
         TabIndex        =   50
         Top             =   720
         Width           =   2655
      End
      Begin VB.Label Label15 
         BackColor       =   &H00808000&
         BorderStyle     =   1  'Fixed Single
         Caption         =   "POLIESTER FIBRA CORTA"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   14.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   1800
         TabIndex        =   49
         Top             =   240
         Width           =   3855
      End
   End
   Begin VB.Frame Frame6 
      Height          =   1215
      Left            =   1440
      TabIndex        =   44
      Top             =   6600
      Width           =   9015
      Begin VB.TextBox RSDactiva 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   510
         Left            =   240
         LinkItem        =   "B15/66"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   59
         Text            =   "Server error [1]."
         Top             =   480
         Width           =   375
      End
      Begin VB.TextBox RSDBALA 
         Height          =   285
         Left            =   7920
         LinkItem        =   "N32:53,L5"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   47
         Text            =   $"Principal.frx":81AE
         Top             =   600
         Width           =   975
      End
      Begin VB.TextBox TXTBALA 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   18
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   735
         Left            =   1560
         TabIndex        =   46
         Top             =   120
         Width           =   5775
      End
      Begin VB.Label Label14 
         BackStyle       =   0  'Transparent
         Caption         =   "PACA No."
         Height          =   255
         Left            =   120
         TabIndex        =   45
         Top             =   120
         Width           =   855
      End
   End
   Begin VB.Frame Frame5 
      Height          =   975
      Left            =   1440
      TabIndex        =   28
      Top             =   5280
      Width           =   9015
      Begin VB.TextBox RSDNETWEIGHT 
         Height          =   195
         Left            =   7200
         LinkItem        =   "N32:50,L3"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   43
         Text            =   $"Principal.frx":81D5
         Top             =   720
         Width           =   1575
      End
      Begin VB.TextBox RSDWEIGHT 
         Height          =   195
         Left            =   5040
         LinkItem        =   "N32:23,L3"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   42
         Text            =   $"Principal.frx":81EE
         Top             =   720
         Width           =   1455
      End
      Begin VB.TextBox RSDLUSTRE 
         Height          =   195
         Left            =   3360
         LinkItem        =   "N32:12,L5"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   41
         Text            =   $"Principal.frx":8207
         Top             =   720
         Width           =   1095
      End
      Begin VB.TextBox RSDLENGHT 
         Height          =   195
         Left            =   1920
         LinkItem        =   "N32:33,L3"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   40
         Text            =   $"Principal.frx":822D
         Top             =   720
         Width           =   855
      End
      Begin VB.TextBox RSDDPF 
         Height          =   195
         Left            =   240
         LinkItem        =   "N32:30,L3"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   39
         Text            =   $"Principal.frx":8243
         Top             =   720
         Width           =   615
      End
      Begin VB.TextBox TXTNETWEIGHT 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   7080
         TabIndex        =   38
         Top             =   360
         Width           =   1815
      End
      Begin VB.TextBox TXTWEIGHT 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   5040
         TabIndex        =   37
         Top             =   360
         Width           =   1695
      End
      Begin VB.TextBox TXTLUSTRE 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   3360
         TabIndex        =   36
         Top             =   360
         Width           =   1335
      End
      Begin VB.TextBox TXTLENGHT 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   1920
         TabIndex        =   35
         Top             =   360
         Width           =   1095
      End
      Begin VB.TextBox TXTDPF 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   240
         TabIndex        =   34
         Top             =   360
         Width           =   855
      End
      Begin VB.Label Label13 
         BackStyle       =   0  'Transparent
         Caption         =   "NET WEIGHT Lbs."
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   7320
         TabIndex        =   33
         Top             =   120
         Width           =   1455
      End
      Begin VB.Label Label12 
         BackStyle       =   0  'Transparent
         Caption         =   "G. WEIGHT Lbs."
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   5160
         TabIndex        =   32
         Top             =   120
         Width           =   1335
      End
      Begin VB.Label Label11 
         BackStyle       =   0  'Transparent
         Caption         =   "LUSTRE"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   3600
         TabIndex        =   31
         Top             =   120
         Width           =   735
      End
      Begin VB.Label Label10 
         BackStyle       =   0  'Transparent
         Caption         =   "LENGHT in."
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   1920
         TabIndex        =   30
         Top             =   120
         Width           =   975
      End
      Begin VB.Label Label9 
         BackStyle       =   0  'Transparent
         Caption         =   "D.P.F."
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   240
         TabIndex        =   29
         Top             =   120
         Width           =   495
      End
      Begin VB.Line Line8 
         X1              =   6960
         X2              =   6960
         Y1              =   120
         Y2              =   960
      End
      Begin VB.Line Line7 
         X1              =   4800
         X2              =   4800
         Y1              =   120
         Y2              =   960
      End
      Begin VB.Line Line6 
         X1              =   3240
         X2              =   3240
         Y1              =   120
         Y2              =   960
      End
      Begin VB.Line Line5 
         X1              =   1560
         X2              =   1560
         Y1              =   120
         Y2              =   960
      End
   End
   Begin VB.Frame Frame4 
      Height          =   975
      Left            =   1440
      TabIndex        =   12
      Top             =   3960
      Width           =   9015
      Begin VB.TextBox RSDMASAN 
         Height          =   195
         Left            =   7080
         LinkItem        =   "N32:47,L3"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   27
         Text            =   $"Principal.frx":825C
         Top             =   720
         Width           =   1575
      End
      Begin VB.TextBox TXTMASAN 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   7080
         TabIndex        =   26
         Top             =   360
         Width           =   1815
      End
      Begin VB.TextBox RSDMASAB 
         Height          =   195
         Left            =   5040
         LinkItem        =   "N32:20,L3"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   24
         Text            =   $"Principal.frx":8275
         Top             =   720
         Width           =   1455
      End
      Begin VB.TextBox TXTMASAB 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   5040
         TabIndex        =   23
         Top             =   360
         Width           =   1695
      End
      Begin VB.TextBox RSDMSDS 
         Height          =   195
         Left            =   3360
         LinkItem        =   "N32:26,L4"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   21
         Text            =   $"Principal.frx":828E
         Top             =   720
         Width           =   1095
      End
      Begin VB.TextBox TXTMSDS 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   3360
         TabIndex        =   20
         Top             =   360
         Width           =   1335
      End
      Begin VB.TextBox rsdcorte 
         Height          =   195
         Left            =   1920
         LinkItem        =   "N32:39,L2"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   18
         Text            =   $"Principal.frx":82AD
         Top             =   720
         Width           =   855
      End
      Begin VB.TextBox txtcorte 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   1920
         TabIndex        =   17
         Top             =   360
         Width           =   1095
      End
      Begin VB.TextBox rsddtex 
         Height          =   195
         Left            =   240
         LinkItem        =   "N32:17,L3"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   15
         Text            =   $"Principal.frx":82BC
         Top             =   720
         Width           =   615
      End
      Begin VB.TextBox txtdtex 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   240
         TabIndex        =   14
         Top             =   360
         Width           =   855
      End
      Begin VB.Label Label8 
         BackStyle       =   0  'Transparent
         Caption         =   "MASA NETA Kg."
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   7320
         TabIndex        =   25
         Top             =   120
         Width           =   1335
      End
      Begin VB.Line Line4 
         X1              =   6960
         X2              =   6960
         Y1              =   120
         Y2              =   960
      End
      Begin VB.Label Label7 
         BackStyle       =   0  'Transparent
         Caption         =   "MASA BRUTA A  Kg."
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   5040
         TabIndex        =   22
         Top             =   120
         Width           =   1575
      End
      Begin VB.Line Line3 
         X1              =   4800
         X2              =   4800
         Y1              =   120
         Y2              =   960
      End
      Begin VB.Label Label6 
         BackStyle       =   0  'Transparent
         Caption         =   "M.S.D.S."
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   3360
         TabIndex        =   19
         Top             =   120
         Width           =   735
      End
      Begin VB.Line Line2 
         X1              =   3240
         X2              =   3240
         Y1              =   120
         Y2              =   960
      End
      Begin VB.Label Label5 
         BackStyle       =   0  'Transparent
         Caption         =   "CORTEmm"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   1920
         TabIndex        =   16
         Top             =   120
         Width           =   855
      End
      Begin VB.Line Line1 
         X1              =   1560
         X2              =   1560
         Y1              =   120
         Y2              =   960
      End
      Begin VB.Label Label4 
         BackStyle       =   0  'Transparent
         Caption         =   "dTEX"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   360
         TabIndex        =   13
         Top             =   120
         Width           =   495
      End
   End
   Begin VB.Frame Frame3 
      Height          =   615
      Left            =   2520
      TabIndex        =   8
      Top             =   3000
      Width           =   7935
      Begin VB.TextBox rsdtipo 
         Height          =   375
         Left            =   4080
         LinkItem        =   "N32:44,L3"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   11
         Text            =   $"Principal.frx":82D5
         Top             =   120
         Width           =   1215
      End
      Begin VB.TextBox txt_tipo 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   1080
         TabIndex        =   10
         Top             =   120
         Width           =   2655
      End
      Begin VB.Label Label3 
         BackStyle       =   0  'Transparent
         Caption         =   "Tipo"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   240
         Width           =   495
      End
   End
   Begin VB.Frame Frame2 
      Height          =   615
      Left            =   2520
      TabIndex        =   4
      Top             =   2280
      Width           =   7935
      Begin VB.TextBox rsdlote 
         Height          =   375
         Left            =   4080
         LinkItem        =   "N32:10,L2"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   6
         Text            =   $"Principal.frx":82ED
         Top             =   120
         Width           =   1215
      End
      Begin VB.TextBox txt_lote 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   1080
         TabIndex        =   5
         Top             =   120
         Width           =   2655
      End
      Begin VB.Label Label2 
         BackStyle       =   0  'Transparent
         Caption         =   "Lote"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   120
         Width           =   615
      End
   End
   Begin VB.Frame Frame1 
      Height          =   735
      Left            =   2520
      TabIndex        =   0
      Top             =   1440
      Width           =   7935
      Begin VB.TextBox RSDcod_pro 
         Height          =   375
         Left            =   4080
         LinkItem        =   "N32:1,l8"
         LinkTopic       =   "RSLINX|PLC_3"
         TabIndex        =   3
         Text            =   $"Principal.frx":82FF
         Top             =   240
         Width           =   1215
      End
      Begin VB.TextBox TXTcod_pro 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   390
         Left            =   1080
         TabIndex        =   1
         Top             =   240
         Width           =   2655
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "Clave Prod"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Width           =   1095
      End
   End
   Begin VB.Label lblmesc 
      BorderStyle     =   1  'Fixed Single
      Height          =   375
      Left            =   11040
      TabIndex        =   60
      Top             =   6240
      Width           =   1215
   End
   Begin VB.Shape Shape10 
      BackColor       =   &H00000000&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00000000&
      FillStyle       =   0  'Solid
      Height          =   975
      Left            =   11160
      Shape           =   3  'Circle
      Top             =   5160
      Width           =   975
   End
End
Attribute VB_Name = "Principal"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public linea As String
Public lote As String
Public bala As String
Public peso_bruto As String
Public peso_neto As String
Public msg As String
Public style As String
Public title As String
Public response As Integer
Public ban_error As Integer
Public ban_er As Integer
Public tiempo As String
Public bdtiempo As Date
Public reg_balaspc As String
Public dbltiempo As Double
Public fecha As String
Public ret_val As Integer
Public reg_balaspcOFF As String
Public lineaOFF As String
Public loteOFF As String
Public balaOFF As String
Public peso_brutoOFF As String
Public peso_netoOFF As String
Public fechaOFF As String
Public tiempoOFF As String

Private Sub Command1_Click()
    MANTTO_PASSWD.Show
End Sub

Private Sub Command2_Click()
    frm_contingencia.Show
End Sub

Private Sub Command3_Click()
    Cambio_password.Show
End Sub

Private Sub Command4_Click()
    Finaliza_app.Show
    
End Sub

Private Sub Form_Activate()
    'Timer1.Enabled = False
    ' reiniciando los valores del plc
    RSDcod_pro.Visible = False
    rsdlote.Visible = False
    rsdtipo.Visible = False
    rsddtex.Visible = False
    rsdcorte.Visible = False
    RSDMSDS.Visible = False
    RSDMASAB.Visible = False
    RSDMASAN.Visible = False
    RSDDPF.Visible = False
    RSDLENGHT.Visible = False
    RSDLUSTRE.Visible = False
    RSDWEIGHT.Visible = False
    RSDNETWEIGHT.Visible = False
    RSDBALA.Visible = False
    RSDSEGUNDO.Visible = False
    ' deshabilitando los botones de principal
    
    TXTcod_pro.Enabled = False
    txt_lote.Enabled = False
    txt_tipo.Enabled = False
    txtdtex.Enabled = False
    txtcorte.Enabled = False
    TXTMSDS.Enabled = False
    TXTMASAB.Enabled = False
    TXTMASAN.Enabled = False
    TXTDPF.Enabled = False
    TXTLENGHT.Enabled = False
    TXTLUSTRE.Enabled = False
    TXTWEIGHT.Enabled = False
    TXTNETWEIGHT.Enabled = False
    RSDactiva.Enabled = False
    TXTBALA.Enabled = False
    
End Sub

Private Sub Form_Load()
    hay_error = False
    'Principal.Height = Screen.Height
    'Principal.Width = Screen.Width
    'Principal.Top = (Screen.Height / 2) - Principal.Height / 2
    'Principal.Left = (Screen.Width / 2) - Screen.Width / 2

    On Error GoTo SALTA
    If Dir("c:\cont", vbDirectory) <> "CONT" Then
        'MkDir "c:\cont"
    End If
    
    RSDSEGUNDO.LinkTopic = "RSLINX|PLC_3"
    ' EL ORIGINAL ES 22, EL 23 ES SOLO PARA PROBAR
    RSDSEGUNDO.LinkItem = "S:23"
    RSDSEGUNDO.LinkMode = 2
    
    'PONIENDO EL TIMER A 1.09 MINUTOS
    Timer1.Interval = 10000
' ACUTALIZANDO LOS BOXCES
RSDcod_pro.LinkMode = 1
rsdlote.LinkMode = 1
rsdtipo.LinkMode = 1
rsddtex.LinkMode = 1
rsdcorte.LinkMode = 1
RSDMSDS.LinkMode = 1
RSDMASAB.LinkMode = 1
RSDMASAN.LinkMode = 1

RSDDPF.LinkMode = 1
RSDLENGHT.LinkMode = 1
RSDLUSTRE.LinkMode = 1
RSDWEIGHT.LinkMode = 1
RSDNETWEIGHT.LinkMode = 1
RSDBALA.LinkMode = 1
RSDactiva.LinkMode = 1



If RSDcod_pro.Text <> "" Then Call convierte(TXTcod_pro, RSDcod_pro)

If rsdlote.Text <> "" Then Call convierte(txt_lote, rsdlote)

If rsdtipo.Text <> "" Then Call convierte(txt_tipo, rsdtipo)

If rsddtex.Text <> "" Then Call convierte(txtdtex, rsddtex)

If rsdcorte.Text <> "" Then Call convierte(txtcorte, rsdcorte)

If RSDMSDS.Text <> "" Then Call convierte(TXTMSDS, RSDMSDS)

If RSDMASAB.Text <> "" Then Call convierte(TXTMASAB, RSDMASAB)

If RSDMASAN.Text <> "" Then Call convierte(TXTMASAN, RSDMASAN)

If RSDDPF.Text <> "" Then Call convierte(TXTDPF, RSDDPF)

If RSDLENGHT.Text <> "" Then Call convierte(TXTLENGHT, RSDLENGHT)

If RSDLUSTRE.Text <> "" Then Call convierte(TXTLUSTRE, RSDLUSTRE)

If RSDWEIGHT.Text <> "" Then Call convierte(TXTWEIGHT, RSDWEIGHT)

If RSDNETWEIGHT.Text <> "" Then Call convierte(TXTNETWEIGHT, RSDNETWEIGHT)

If RSDBALA.Text <> "" Then Call convierte(TXTBALA, RSDBALA)
hay_error = False
    Exit Sub
    
SALTA:
    If Timer1.Interval = 0 Then Timer1.Interval = 10000
    Principal.BackColor = &H80FFFF
    hay_error = True
    Call RSDactiva_LinkError(Err.Number)
End Sub





Private Sub RSDactiva_Change()

Dim ban_activa As Integer
Dim gra_lin As Integer
Dim query As String
Dim hora_produccion As Date
Err.Clear
On Error GoTo sigue
RSDactiva.LinkMode = 1
If pri_eve <> 0 Then
    ban_activa = CInt(RSDactiva.Text)
    If ban_activa = 1 Then
        Shape10.FillColor = &HFFFF&
        ban_error = 0
        bala = TXTBALA.Text
        If ant_bala <> bala Then
            linea = Mid(bala, 3, 1)
            peso_bruto = TXTMASAB.Text
            peso_neto = TXTMASAN.Text
            lote = txt_lote.Text
            If Not IsNumeric(bala) Then
                fr_err = "Bala: Dato no valido, debe ser Numerico"
                ban_error = 1
                Error_formato.Show
            End If
            
            If Not IsNumeric(peso_bruto) Then
                fr_err = "peso bruto: Dato no valido, debe ser Numerico"
                ban_error = 1
                Error_formato.Show
            End If
            
            If Not IsNumeric(peso_neto) Then
                fr_err = "peso neto: Dato no valido, debe ser Numerico"
                ban_error = 1
                Error_formato.Show
            End If
            
            If Not IsNumeric(linea) Or linea > "9" Then
                fr_err = "linea: Dato no valido, debe ser Numerico"
                ban_error = 1
                Error_formato.Show
            Else
                If linea = "3" Then linea = "4"
                gra_lin = CInt(linea)
            End If
            
            fecha = Format(Now, "dd-mmm-yy")
            tiempo = Format(Now, "hh:mm:ss")
            
            reg_balaspc = bala + "," + fecha + "," + peso_bruto + "," + peso_neto + "," + tiempo + ",1," + linea + "," + lote + ",1"
            
            If ban_error = 1 Then
                Open "c:\cont\balas.err" For Append Access _
                Write Shared As #5
                    Print #5, reg_balaspc
                Close #5
            Else
                ' grabando en base de datos
                Err.Clear
                On Error GoTo outsub
                Call conecta
                query = "Select * from bala where numero = " + bala
                ' aqui mando la estructura de escritura sobre recordset
                Set rs = CreateObject("ADODB.Recordset")
                rs.CursorType = adOpenKeyset
                rs.LockType = adLockOptimistic
                rs.Open query, cnn1
                lblmesc.Caption = "Escribiendo"
                ' abriendo un nuevo registro en la tabla
                Shape10.FillColor = &HFF00&
                rs.AddNew
                rs("numero") = bala
                rs("FECHAPRODUCCION") = fecha
                rs("MASABRUTA") = peso_bruto
                rs("MASANETA") = peso_neto
                bdtiempo = tiempo
                hora_produccion = Format(CDate("01/01/01 " + bdtiempo), "dd-mmm-yy hh:mm:ss")
                rs("HORAPRODUCCION") = hora_produccion
                rs("CVEESTADOBALA") = 1
                rs("NUMLINEA") = gra_lin
                rs("CVELOTE") = lote
                rs("CVEPLANTAORIGEN") = 1
                rs.Update
                rs.Close
                Call desconecta
                Open "c:\cont\balas.sav" For Append Access _
                    Write Shared As #1
                        Print #1, reg_balaspc
                Close #1
                lblmesc.Caption = ""
                If act = 0 Then
                    Principal.BackColor = &H8000000F
                    'boton de mantenimiento = enabled
                    act = 1
                End If
            End If
            GoTo SALTA
outsub:
        Principal.BackColor = &HFFFF&
        ' BOTON DE MANTENIMIENTO SE APAGA EL ENABLED
        Open "C:\cont\balas.off" For Append Access _
            Write Shared As #2
                Print #2, reg_balaspc
            Close #2
            act = 0
SALTA:
        End If
        Else
        Shape10.FillColor = &H80000008
        End If
        Else
            pri_eve = 1
        End If
        ant_bala = bala
    Exit Sub
sigue:
    Open "C:\cont\balas.off" For Append Access _
            Write Shared As #2
                Print #2, "Se Genero un error conexion de datos con PLC " + Format(Now, "hh:mm:ss")
            Close #2
End Sub

Private Sub RSDactiva_LinkError(LinkErr As Integer)
    fr_err1 = ""
    ban_er = 0
    Select Case LinkErr
    Case 2
        ban_er = 1
        fr_err = "ERROR: INVALID LINK"
    Case 3
        ban_er = 1
        fr_err = "ERROR: CONECT FAILED"
    Case 4
        ban_er = 1
        fr_err = "ERROR: LINX STOP RUNING"
        fr_err1 = "CORRA LA OPCION DE REINICIO PARA REANUDAR"
    Case 6
        ban_er = 1
        fr_err = "ERROR: REQUEST FAILED"
    Case 7
        ban_er = 1
        fr_err = " ERROR: UNADVISE FAILED"
    Case 8
        ban_er = 1
        fr_err = "ERROR: OUT OF MEMORY"
    Case 10
        ban_er = 1
        fr_err = "ERROR: CRITICAL ERROR"
    Case 11
        ban_er = 1
        fr_err = "ERROR:CRITICAL ERROR"
    End Select
    ban_er = 1
    fr_err = Err.Description
    
    If ban_er = 1 Then
        hay_error = True
        Error_Comunicacion.Show
        Error_Comunicacion.SetFocus
    End If
    
    If pri_eve <> 0 And ban_error = 1 Then
        fecha = Format(Now, "DD-MM-YY")
        tiempo = Format(Now, "HH:MM:SS")
        reg_balaspc = bala + "," + fecha + "," + peso_bruto + "," + peso_neto + "," + tiempo + ",1," + linea + "," + lote + ",1"
        
        Open "c:\cont\balas.err" For Append Access _
            Write Shared As #5
                Print #5, reg_balaspc
            Close #5
        
    End If
        
End Sub

Private Sub RSDBALA_Change()
    Call convierte(TXTBALA, RSDBALA)
End Sub

Private Sub RSDcod_pro_Change()
    Call convierte(TXTcod_pro, RSDcod_pro)
End Sub

Private Sub rsdcorte_Change()
    Call convierte(txtcorte, rsdcorte)
End Sub

Private Sub RSDDPF_Change()
    Call convierte(TXTDPF, RSDDPF)
End Sub

Private Sub rsddtex_Change()
    Call convierte(txtdtex, rsddtex)
End Sub

Private Sub RSDLENGHT_Change()
    Call convierte(TXTLENGHT, RSDLENGHT)
End Sub

Private Sub rsdlote_Change()
    Call convierte(txt_lote, rsdlote)
End Sub

Private Sub RSDLUSTRE_Change()
    Call convierte(TXTLUSTRE, RSDLUSTRE)
End Sub

Private Sub RSDMASAB_Change()
    Call convierte(TXTMASAB, RSDMASAB)
End Sub

Private Sub RSDMASAN_Change()
    Call convierte(TXTMASAN, RSDMASAN)
End Sub

Private Sub RSDMSDS_Change()
    Call convierte(TXTMSDS, RSDMSDS)
End Sub

Private Sub RSDNETWEIGHT_Change()
    Call convierte(TXTNETWEIGHT, RSDNETWEIGHT)
End Sub

Private Sub rsdtipo_Change()
    Call convierte(txt_tipo, rsdtipo)
End Sub

Private Sub RSDWEIGHT_Change()
    Call convierte(TXTWEIGHT, RSDWEIGHT)
End Sub

Sub convierte(cuadro_texto As Object, rsd_texto As Object)
Dim i As Integer
Dim asci1 As Integer
Dim asci2 As Integer
Dim nume As Integer
Dim carac As String
Dim AUX As String
Dim pox(8) As Integer
Dim longitud_total As Integer
Dim elemento As Integer

On Error Resume Next
AUX = rsd_texto.Text
longitud_total = Len(AUX)
elemento = 0
For i = 1 To longitud_total
    If Left(AUX, 1) <> Chr(13) Then
        pox(elemento) = pox(elemento) & Left(AUX, 1)
        AUX = Right(AUX, longitud_total - i)
    Else
        elemento = elemento + 1
        i = i + 1
        AUX = Right(AUX, longitud_total - i)
    End If
Next i

For i = 0 To elemento - 1
    nume = CInt(pox(i))
    asci1 = Int(nume / 256)
    If asci1 <> 13 And asci1 <> 0 Then
        carac = carac + Chr$(asci1)
    End If
    asci2 = Int(((nume / 256) - Int(nume / 256)) * 256)
    If asci2 <> 13 And asci2 <> 0 Then
        carac = carac + Chr$(asci2)
    End If
Next i
'pro(1) = RSDcod_pro
'TXTcod_pro.Text = ""
cuadro_texto.Text = carac

End Sub

Private Sub Timer1_Timer()
On Error GoTo LLEVA_ERROR
Err.Clear
    If b_tiem = 0 Then
        ant_bala = TXTBALA.Text
        b_tiem = 1
    End If
    RSDSEGUNDO.LinkMode = 2
    RSDSEGUNDO.LinkRequest
        'reiniciando todos los bits
        RSDcod_pro.LinkMode = 1
        rsdlote.LinkMode = 1
        rsdtipo.LinkMode = 1
        rsddtex.LinkMode = 1
        rsdcorte.LinkMode = 1
        RSDMSDS.LinkMode = 1
        RSDMASAB.LinkMode = 1
        RSDMASAN.LinkMode = 1
        
        RSDDPF.LinkMode = 1
        RSDLENGHT.LinkMode = 1
        RSDLUSTRE.LinkMode = 1
        RSDWEIGHT.LinkMode = 1
        RSDNETWEIGHT.LinkMode = 1
        RSDBALA.LinkMode = 1
        RSDactiva.LinkMode = 1
    If ant_seg = RSDSEGUNDO.Text Then
        Beep
        Beep
        Beep
        Beep
        fr_err = "LINX PERDIO COMUNICACION CON EL PLC"
        fr_err1 = "Revise el PLC o la Conexion con la PLC"
        hay_error = True
        Error_Comunicacion.Show
    End If
    ant_seg = RSDSEGUNDO.Text
    Exit Sub
LLEVA_ERROR:
    Call RSDactiva_LinkError(Err.Number)
End Sub

Private Sub Timer2_Timer()
    lblhora.Caption = Format(Now, "Long Time")
    If hay_error Then Error_Comunicacion.SetFocus
    
End Sub
