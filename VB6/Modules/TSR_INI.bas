Attribute VB_Name = "TSR_INI"
' TSR_INI - Teseracto (c) 1998
'          Ing. Miguel A. Torres-Orozco Bermeo.
' Funciones para el uso de archivos .INI
'
Option Explicit

'---------------------------------------------------------------------------
'API's Windows
'---------------------------------------------------------------------------
'Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
'Private Declare Function GetActiveWindow Lib "user32" () As Long
'Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function ShowWindow Lib "user32" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long
'Private Declare Function SFocus Lib "user32" Alias "SetFocus" (ByVal hwnd As Long) As Long


'---------------------------------------------------------------------------
' Variables de m�dulo
'---------------------------------------------------------------------------
Private mIniFileName$                      ' Archivo de inicializaci�n


' Objetivo:     Escribe un par�metro de un archivo *.INI. Requiere que
'               previamente haya sido llamada la funci�n FNIniciar
' Autor:        Teseracto - JVO
' Fecha:        09-04-96
'
' Par�ms:       psSeccion$  (IN) - Nombre de la [secci�n] en la que se encuentra
'                                  la variable.
'               psVariable$ (IN) - Variable a la que se le asignar� valor.
'               psValor$    (IN) - Valor de la variable
' Salida:       TRUE - Se asign� el valor a la variable
'
Function FNParametroEscribir(psSeccion$, psVariable$, psValor$, Optional pFullFileName$ = "") As Boolean
Dim szBuffer As String * 50

    'Utiliza el archivo INI de la aplicaci�n por default
    If pFullFileName$ = "" Then pFullFileName$ = mIniFileName$

    ' Escribir el par�metro
    FNParametroEscribir = CBool(WritePrivateProfileString(ByVal psSeccion$, ByVal psVariable$, ByVal psValor$, ByVal pFullFileName$))
    
End Function

' Objetivo:     Lee un par�metro de un archivo *.INI. Requiere que
'               previamente haya sido llamada la funci�n FNIniciar
' Autor:        Teseracto - JVO
' Fecha:        09-04-96
'
' Par�ms:       psSeccion$  (IN) - Nombre de la [secci�n] en la que se encuentra
'                                  la variable.
'               psVariable$ (IN) - Variable a la que se le leer� el valor.
'               psDefault$  (IN) - Valor default de la variable
' Salida:       Valor de la variable o psDefault$ si no existe o hubo un error
'
Function FNParametroLeer(psSeccion$, psVariable$, psDefault$, Optional pFullFileName$ = "") As String
Dim szBuffer As String * 80
Dim LnTmp&

    'Utiliza el archivo INI de la aplicaci�n por default
    If pFullFileName$ = "" Then pFullFileName$ = mIniFileName$

    ' Regresar el valor le�do
    LnTmp& = GetPrivateProfileString(ByVal psSeccion$, ByVal psVariable, ByVal psDefault$, ByVal szBuffer, Len(szBuffer), ByVal pFullFileName$)
    LnTmp& = InStr(szBuffer, Chr$(0))
    FNParametroLeer$ = Left$(szBuffer, LnTmp& - 1)

End Function




' Objetivo:     Inicializa variables globales. Debe llamarse al inicio de la aplicaci�n
' Autor:        Teseracto - JVO
' Fecha:        23-09-96
'
' Par�ms:    psApp$ (IN) - Nombre de la aplicaci�n.
'            psINIFileName$ (IN) - Archivo INI (Para leer y escribir par�metros)
'            pMultiInstance (IN) - Indica si la aplicaci�n permite multiples instancias
' Salida:    TRUE  = Se inicializ� por 1a vez
'            FALSE = La aplicaci�n ya exist�a (se mand� el foco)
'
' Notas:     Para que la aplicaci�n env�e el foco a la instancia anterior es necesario que
'            el nombre de la aplicaci�n (psApp$) coincida con el t�tulo de la ventana principal
'

Function FNIniciar(psApp$, Optional psINIFileName$ = "", Optional pMultiInstance As Boolean = False)
Dim lOk As Boolean, lPath$, lhWnd&, lStr$, lTitle$
    'Inicio
    lOk = False

    '1. Nombre de la aplicaci�n
    FNAppName = psApp$

    '2. Nombre del archivo *.INI
    mIniFileName$ = FNFixPath(App.Path) & psINIFileName$
        
    '3. Permite solo una instancia
    If (Not pMultiInstance) And App.PrevInstance Then
       On Error Resume Next
       AppActivate APP_NAME            'Activa ventana de la instancia anterior
       On Error GoTo 0
       
       'Obtiene el Hadle Window del registry (se grab� en el evento load de frmMain)
       lhWnd& = FNRegistroGetVal(HKEY_LOCAL_MACHINE, HKEY_APP, "hWnd", 0)   'Obtiene el handle
       'Le env�a el foco a la ventana
       ShowWindow lhWnd&, 1          'Restaura la ventana (1=Normal, 9=Restore)
    Else
       lOk = True
    End If
    'Termina
    FNIniciar = lOk
End Function





