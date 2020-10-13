VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TabCtl32.Ocx"
Object = "{D27CDB6B-AE6D-11CF-96B8-444553540000}#1.0#0"; "Flash10d.ocx"
Begin VB.Form frmPICTest 
   Caption         =   "Form1"
   ClientHeight    =   9645
   ClientLeft      =   4020
   ClientTop       =   3165
   ClientWidth     =   10980
   LinkTopic       =   "Form1"
   ScaleHeight     =   9645
   ScaleWidth      =   10980
   Begin TabDlg.SSTab SSTab1 
      Height          =   4815
      Left            =   180
      TabIndex        =   8
      Top             =   4740
      Width           =   4875
      _ExtentX        =   8599
      _ExtentY        =   8493
      _Version        =   393216
      Tab             =   1
      TabHeight       =   520
      TabCaption(0)   =   "Tab 0"
      TabPicture(0)   =   "frmPICTest.frx":0000
      Tab(0).ControlEnabled=   0   'False
      Tab(0).ControlCount=   0
      TabCaption(1)   =   "Tab 1"
      TabPicture(1)   =   "frmPICTest.frx":001C
      Tab(1).ControlEnabled=   -1  'True
      Tab(1).Control(0)=   "ShockwaveFlash1"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).ControlCount=   1
      TabCaption(2)   =   "Tab 2"
      TabPicture(2)   =   "frmPICTest.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).ControlCount=   0
      Begin ShockwaveFlashObjectsCtl.ShockwaveFlash ShockwaveFlash1 
         Height          =   2475
         Left            =   300
         TabIndex        =   9
         Top             =   900
         Width           =   3675
         _cx             =   6482
         _cy             =   4366
         FlashVars       =   ""
         Movie           =   "C:\Documents and Settings\MTB\Escritorio\Flash.swf"
         Src             =   "C:\Documents and Settings\MTB\Escritorio\Flash.swf"
         WMode           =   "Window"
         Play            =   "-1"
         Loop            =   "-1"
         Quality         =   "High"
         SAlign          =   ""
         Menu            =   "-1"
         Base            =   ""
         AllowScriptAccess=   ""
         Scale           =   "ShowAll"
         DeviceFont      =   "0"
         EmbedMovie      =   "-1"
         BGColor         =   ""
         SWRemote        =   ""
         MovieData       =   ""
         SeamlessTabbing =   "1"
         Profile         =   "0"
         ProfileAddress  =   ""
         ProfilePort     =   "0"
         AllowNetworking =   "all"
         AllowFullScreen =   "false"
      End
   End
   Begin VB.CommandButton Command7 
      Caption         =   "Command7"
      Height          =   555
      Left            =   2220
      TabIndex        =   7
      Top             =   300
      Width           =   735
   End
   Begin VB.PictureBox Picture1 
      Height          =   4155
      Left            =   5340
      ScaleHeight     =   4095
      ScaleWidth      =   5175
      TabIndex        =   6
      Top             =   240
      Width           =   5235
   End
   Begin VB.CommandButton Command6 
      Caption         =   "Command6"
      Height          =   555
      Left            =   300
      TabIndex        =   5
      Top             =   3840
      Width           =   1755
   End
   Begin VB.CommandButton Command5 
      Caption         =   "Command5"
      Height          =   555
      Left            =   300
      TabIndex        =   4
      Top             =   3120
      Width           =   1755
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Command4"
      Height          =   555
      Left            =   300
      TabIndex        =   3
      Top             =   2400
      Width           =   1755
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Command3"
      Height          =   555
      Left            =   300
      TabIndex        =   2
      Top             =   1680
      Width           =   1755
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Command2"
      Height          =   555
      Left            =   300
      TabIndex        =   1
      Top             =   960
      Width           =   1755
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   555
      Left            =   300
      TabIndex        =   0
      Top             =   240
      Width           =   1755
   End
End
Attribute VB_Name = "frmPICTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------
' Capture the entire screen.

Private Sub Command1_Click()
   Set Picture1.Picture = CaptureScreen()
End Sub

' Capture the entire form including title and border.
Private Sub Command2_Click()
   Set Picture1.Picture = CaptureForm(Me)
End Sub

' Capture the client area of the form.
Private Sub Command3_Click()
   Set Picture1.Picture = CaptureClient(Me)
   
End Sub

' Capture the active window after two seconds.
Private Sub Command4_Click()
   MsgBox "Two seconds after you close this dialog " & _
      "the active window will be captured."

   ' Wait for two seconds.
   Dim EndTime As Date
   EndTime = DateAdd("s", 2, Now)
   Do Until Now > EndTime
      DoEvents
   Loop

   Set Picture1.Picture = CaptureActiveWindow()

   ' Set focus back to form.
   Me.SetFocus
End Sub

' Print the current contents of the picture box.
Private Sub Command5_Click()
   PrintPictureToFitPage Printer, Picture1.Picture
   Printer.EndDoc
End Sub

' Clear out the picture box.
Private Sub Command6_Click()
   Set Picture1.Picture = Nothing
End Sub

Private Sub Command7_Click()
   Set Picture1.Picture = CaptureWindow(Me.hWnd, True, _
      Me.ScaleX(ShockwaveFlash1.Left + SSTab1.Left, Me.ScaleMode, vbPixels), _
      Me.ScaleY(ShockwaveFlash1.Top + SSTab1.Top, Me.ScaleMode, vbPixels), _
      Me.ScaleX(ShockwaveFlash1.Width, Me.ScaleMode, vbPixels), _
      Me.ScaleY(ShockwaveFlash1.Height, Me.ScaleMode, vbPixels))

End Sub

' Initialize the form and controls.
Private Sub Form_Load()
   Me.Caption = "Capture and Print Example"
   Command1.Caption = "&Screen"
   Command2.Caption = "&Form"
   Command3.Caption = "&Client"
   Command4.Caption = "&Active"
   Command5.Caption = "&Print"
   Command6.Caption = "C&lear"
   Picture1.AutoSize = True
End Sub
'--------------------------------------------------------------------

         

