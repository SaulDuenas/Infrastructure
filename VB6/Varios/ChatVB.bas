Attribute VB_Name = "ChatVB_bas"
' ChatVB.BAS - Teseracto (c) 2003
'              Ing. Miguel A. Torres-Orozco Bermeo.
Option Explicit

'---------------------------------------------------------------------------
'API's Windows
'---------------------------------------------------------------------------
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
'Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
'Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Private Declare Function GetActiveWindow Lib "user32" () As Long
Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function ShowWindow Lib "user32" (ByVal hWnd As Long, ByVal nCmdShow As Long) As Long
Private Declare Function SFocus Lib "user32" Alias "SetFocus" (ByVal hWnd As Long) As Long



'********** CONSTANTES GLOBALES *****
'Aplicación
Global Const APP_NAME = "e-HelpDesk"                'Nombre de la Aplicación en la barra de título
Global Const HKEY_PRINCIPAL = HKEY_LOCAL_MACHINE    'Llave del Registry
Global Const HKEY_APP = "Software\Teseracto\Chat"   'Llave del Registry

'Conexión con la base de datos usando ODBC
Global Const GKey% = 27                             'Llave para (des)encriptamiento del password
Global Const SEGUNDO As Date = 1# / 24# / 60# / 60# 'Un segundo

'********** VARIABLES GLOBALES *****
Global APP_URL As String
Global APP_ADMINPASS As String
Global APP_USER As String
Global APP_PASSWORD As String
'



' Programa Principal.
Sub Main()
 Dim lOK As Boolean
 Dim lhKey As Long
 Const lDelay As Date = (1 / 24 / 60 / 60) * 3.5   '3.5 segundos
 Dim lTime As Date


   'Inicializar Aplicación
   lOK = True
   If Not FNIniciar(APP_NAME, "") Then
      'MsgBox "No se pudo Iniciar la aplicación", vbCritical + vbOKOnly, "Error en FNIniciar"
      GoTo TerminaApp
   End If
   DBLogFile = "NULL"
   DBLogErrors = True
   
   'Presenta Splash
   frmSplash.Show
   frmSplash.Refresh
   lTime = Now + lDelay
   
   'Lee los datos del Registry
   lhKey = FNRegistroAbrir(HKEY_PRINCIPAL, HKEY_APP, False, True)
   If lhKey <> 0 Then
      APP_URL = FNRegistroLeer(lhKey, "URL", "")
      APP_ADMINPASS = FNDesEncripta(FNRegistroLeer(lhKey, "AdminPass", ""), GKey%)
      FNRegistroCerrar lhKey
   End If
   
   'Hace Login
   frmLogin.Show vbModal
   If Not frmLogin.OK Then
      'Fallo al iniciar la sesión, se sale de la aplicación
      End
   End If
   Unload frmLogin
   
                        
   'Quita el splash
   Do While lTime > Now: DoEvents: Loop
   Unload frmSplash
                        
                        
   'Muestra la forma no Modal
   frmMain.Show vbModeless
   
   Exit Sub

TerminaApp:
   'Quita el splash
   Unload frmSplash
   
   End
End Sub



' Objetivo:     Inicializa variables globales. Debe llamarse al inicio de la aplicación
' Autor:        Teseracto - JVO
' Fecha:        23-09-96
'
' Paráms:    psApp$ (IN) - Nombre de la aplicación.
'            psINIFileName$ (IN) - Archivo INI (Para leer y escribir parámetros)
'            pMultiInstance (IN) - Indica si la aplicación permite multiples instancias
' Salida:    TRUE  = Se inicializó por 1a vez
'            FALSE = La aplicación ya existía (se mandó el foco)
'
' Notas:     Para que la aplicación envíe el foco a la instancia anterior es necesario que
'            el nombre de la aplicación (psApp$) coincida con el título de la ventana principal
'

Function FNIniciar(psApp$, Optional psINIFileName$ = "", Optional pMultiInstance As Boolean = False)
Dim lOK As Boolean, lPath$, lhWnd&, lStr$, lTitle$
    'Inicio
    lOK = False
    
    
    '1. Nombre de la aplicación
    FNAppName = psApp$

    '3. Permite solo una instancia
    If (Not pMultiInstance) And App.PrevInstance Then
       On Error Resume Next
       AppActivate APP_NAME            'Activa ventana de la instancia anterior
       On Error GoTo 0
       
       'Obtiene el Hadle Window del registry (se grabó en el evento load de frmMain)
       lhWnd& = FNRegistroGetVal(HKEY_LOCAL_MACHINE, HKEY_APP, "hWnd", 0)   'Obtiene el handle
       'Le envía el foco a la ventana
       ShowWindow lhWnd&, 1          'Restaura la ventana (1=Normal, 9=Restore)
    Else
       lOK = True
    End If
    'Termina
    FNIniciar = lOK
End Function

'Corrige el "/" del URL
Function FixURL(pURL$) As String
 Dim lCad$
   'Tiene el \ final?
   If Right(pURL$, 1) = "/" Then
      lCad$ = pURL$             'Esta bien
   Else
      lCad$ = pURL$ & "/"       'Lo pone
   End If
   'Regresa
   FixURL = lCad$
End Function

