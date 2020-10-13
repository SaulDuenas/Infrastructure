Attribute VB_Name = "Module1"

Option Explicit

Public fr_err As String
Public fr_err1 As String
Public man_msg As String
Public ant_seg As String
Public ant_bala As String
Public pasw_ma As String
Public pasw_us As String
Public pasw_gr As String
Public password As String
Public hay_error As Boolean


Public pri_eve As Integer
Public act As Integer
Public b_tiem As Integer
Public Filenum As Integer

Public cnn1 As ADODB.Connection
Public acont As String
Public rs As ADODB.Recordset


Sub conecta()
    ' Abre una conexión sin usar un Data Source Name (DSN).
    '"server=MXQROSSQL001;uid=;pwd=;database=SAPPP"
   Set cnn1 = New ADODB.Connection
    cnn1.ConnectionString = "driver={SQL Server};" & _
        "server=QROSAPP01;uid=;pwd=;database=SAPPP"
        
    cnn1.ConnectionTimeout = 1
    cnn1.Open
    'aqui ya tengo la base de datos abierta
    'aqui ya tengo la base de datos abierta
End Sub


Sub desconecta()
    ' Abre una conexión sin usar un Data Source Name (DSN).
    cnn1.Close
    'aqui ya tengo la base de datos abierta
End Sub

