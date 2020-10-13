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
Public filenum As Integer

Public cnn1 As ADODB.Connection
Public acont As String
Public rs As ADODB.Recordset

Sub main()
Dim i As Integer
Dim cartem As Variant
Dim leepas As String * 8

ant_seg = "99"
pri_eve = 0
Principal.Show
act = 1
b_tiem = 0

filenum = 8
Open "c:\procelm\cveacce.pwd" For Random As filenum Len = 9
Get #filenum, 1, leepas
For i = 1 To Len(leepas)
    If Asc(Mid(leepas, i, 1)) <> 32 Then
        cartem = cartem + Chr(Asc(Mid(leepas, i, 1)) - 1)
    End If
Next i
pasw_us = cartem

Get #filenum, 2, leepas
cartem = ""
For i = 1 To Len(leepas)
    If Asc(Mid(leepas, i, 1)) <> 32 Then
        cartem = cartem + Chr(Asc(Mid(leepas, i, 1)) - 1)
    End If
Next i
pasw_ma = cartem

End Sub

Sub conecta()
    ' Abre una conexión sin usar un Data Source Name (DSN).
   Set cnn1 = New ADODB.Connection
    cnn1.ConnectionString = "driver={SQL Server};" & _
        "server=MXQROSSQL001;uid=;pwd=;database=SAPPP"
        
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

