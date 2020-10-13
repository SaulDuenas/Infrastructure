VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "FNMain"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
' TSR_FN - Teseracto (c) 1998
'          Ing. Carlos J. Rivero Moreno.
'          Ing. Miguel A. Torres-Orozco Bermeo.
' Funciones de uso general y
' Funciones para el uso del registro de windows
'
'Historia de versiones:
' 1.2.1 Se recompila SIN "Ejecución Desatendida y Retenido en memoria" porque si no,
'       no aparecen los mensajes de MsgBox
'
' 1.2.0 Se compila como "Ejecución Desatendida y Retenido en memoria"
'       para evitar errores de COM+
'
'       Como ha habido muchos problemas de compatibilidad de versiones, se decide iniciar
'       una nueva versión que rompe compatibilidades con las anteriores.
'       Solo habrá nuevas versiones cuando se distribuyan a clientes.
'       La compatibilidad Binaria se mantendrá a este release hasta que haya uno nuevo
'       (Compilar a TSR_FN.dll manteniendo compatibilidad binaria con TSR_FN_Ver120.dll)
'
' 1.0.1 Segunda version distribuida en IMSA
'
' 1.0.0 Primera version de TSR_FN como DLL
'

Option Explicit
'---------------------------------------------------------------------------
' CONSTANTES ENUM GLOBALES
'---------------------------------------------------------------------------
'Para FNValidarNumero
Public Enum vnTipoNum
    V_INTEGER = 2
    V_Long = 3
    V_Single = 4
    V_Double = 5
    V_Currency = 6
End Enum

'Para el uso del registro de windows
Public Enum RegHKEY
   HKEY_CLASSES_ROOT = &H80000000
   HKEY_CURRENT_USER = &H80000001
   HKEY_LOCAL_MACHINE = &H80000002
   HKEY_USERS = &H80000003
   HKEY_PERFORMANCE_DATA = &H80000004
   HKEY_CURRENT_CONFIG = &H80000005
   HKEY_DYN_DATA = &H80000006
End Enum


'---------------------------------------------------------------------------
' Variables de Módulo
'---------------------------------------------------------------------------
Private mLogErrors As Boolean       ' Indica si los errores de dirigen a un archivo LOG
Private mLogFile$                   ' Prefijo del Archivo de LOG con ruta

Private MsApp$                      ' Nombre descriptivo de la aplicación, el de la barra de título


'CONSTANTES LOCALES
'------------------
'Para el uso del registro de windows
Const KEY_ALL_ACCESS As Long = &HF003F
Const KEY_READ As Long = &H20019
Const KEY_WRITE As Long = &H20006
Const ERROR_NONE = 0
Const ERROR_SUCCESS = 0
Const ERROR_BADDB = 1
Const ERROR_BADKEY = 2
Const ERROR_CANTOPEN = 3
Const ERROR_CANTREAD = 4
Const ERROR_CANTWRITE = 5
Const ERROR_OUTOFMEMORY = 6
Const ERROR_INVALID_PARAMETER = 7
Const ERROR_ACCESS_DENIED = 8
Const ERROR_INVALID_PARAMETERS = 87
Const ERROR_NO_MORE_ITEMS = 259

'Tipos de datos del registro
Const REG_NONE As Long = 0                      ' Sin tipo de valor
Const REG_SZ As Long = 1                        ' Cadena Unicode terminada en valor nulo
Const REG_EXPAND_SZ As Long = 2                 ' Cadena Unicode terminada en valor nulo
Const REG_BINARY As Long = 3                    ' Binario de formato libre
Const REG_DWORD As Long = 4                     ' Número de 32 bits
Const REG_DWORD_LITTLE_ENDIAN As Long = 4       ' Número de 32 bits (el mismo que en REG_DWORD)
Const REG_DWORD_BIG_ENDIAN As Long = 5          ' Número de 32 bits
Const REG_LINK As Long = 6                      ' Vínculo simbólico (Unicode)
Const REG_MULTI_SZ As Long = 7                  ' Cadenas múltiples Unicode
'Forma de crear las llaves
Const REG_OPTION_NON_VOLATILE = 0               ' La clave se conserva al reiniciar el sistema


'Prototipos de la API del Registro
'Funciones básicas
Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Private Declare Function RegCreateKeyEx Lib "advapi32.dll" Alias "RegCreateKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal Reserved As Long, ByVal lpClass As String, ByVal dwOptions As Long, ByVal samDesired As Long, ByVal lpSecurityAttributes As Long, phkResult As Long, lpdwDisposition As Long) As Long
Private Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
Private Declare Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Any, lpcbData As Long) As Long
   'Note that if you declare the lpData parameter as String, you must pass it By Value.
   'Alias útiles:
   Private Declare Function RegQueryValueExString Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, ByVal lpData As String, lpcbData As Long) As Long
   Private Declare Function RegQueryValueExLong Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Long, lpcbData As Long) As Long
   Private Declare Function RegQueryValueExNULL Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, ByVal lpData As Long, lpcbData As Long) As Long
Private Declare Function RegSetValueEx Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpData As Any, ByVal cbData As Long) As Long
   'Note that if you declare the lpData parameter as String, you must pass it By Value.
   'Alias útiles:
   Private Declare Function RegSetValueExString Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, ByVal lpValue As String, ByVal cbData As Long) As Long
   Private Declare Function RegSetValueExLong Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpValue As Long, ByVal cbData As Long) As Long
Private Declare Function RegDeleteKey Lib "advapi32.dll" Alias "RegDeleteKeyA" (ByVal hKey As Long, ByVal lpSubKey As String) As Long
Private Declare Function RegDeleteValue Lib "advapi32.dll" Alias "RegDeleteValueA" (ByVal hKey As Long, ByVal lpValueName As String) As Long
Private Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerialNumber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long) As Long



'Inicialización de la clase
Private Sub Class_Initialize()
   'Inicializa
   mLogFile = ""
   
   'Los errores se muestran por default en pantalla
   mLogErrors = False
End Sub

'Establece el Nombre de la aplicación
Public Property Let FNAppName(ByVal AppName As String)
    MsApp$ = AppName
End Property
'Devuelve el Nombre de la aplicación
Public Property Get FNAppName() As String
    FNAppName = MsApp$
End Property

'Indica si la aplicacion registra los errores en archivo
Public Property Get FNLogErrors() As Boolean
   FNLogErrors = mLogErrors
End Property
Public Property Let FNLogErrors(pLog As Boolean)
   'Desean Log en archivo?
   If pLog Then
      'Si, Ya se estableció el archivo?
      If mLogFile <> "" Then
         'OK
         mLogErrors = True
      Else
         MsgBox "Primero debe de establecer la propiedad FNLogFile " & _
                "con un nombre de archivo con ruta (prefijo)", vbExclamation + vbOKOnly, _
                "Error en TSR_FN"
      End If
   Else
      'No, Se desactiva
      mLogErrors = False
   End If
End Property

Public Property Let FNLogFile(ByVal Prefijo As String)
   
   'Acepta el parámetro
   mLogFile = Prefijo
   
   'Es Cadena vacía?
   If mLogFile = "" Then
      'Desactiva Registro de Errores en archivo
      mLogErrors = False
   End If
End Property
'Indica La ruta y prefijo de los archivos .Log
Public Property Get FNLogFile() As String
   FNLogFile = mLogFile
End Property



'------------------------------------------------------
'Objetivo: Centrar una forma en la pantalla
'
'Parametros:
'       pCentForm   Nombre de la forma a centrar
'
'Fecha: 14-NOV-96
'------------------------------------------------------
Sub FNCentrar(pCentForm As Object)
'Sub FNCentrar(pCentForm As Form)
 Dim rtop As Integer
 Dim rLeft As Integer
 
 '1.- Calculo de datos
 rtop = (Screen.Height - pCentForm.Height) / 2
 rLeft = (Screen.Width - pCentForm.Width) / 2
 
 '2.- Colocar la forma centrada

 pCentForm.Move rLeft, rtop


End Sub

' Objetivo:     Buscar un dato en un combo
' Autor:        Teseracto - JVO, MTB
' Fecha:        10-04-96
Sub FNComboSeleccionar(phCombo As Object, psDato$)
'Sub FNComboSeleccionar(phCombo As Control, psDato$)
Dim i%, lLen%

   'Des-seleccionar
   phCombo.ListIndex = -1

   '1. ¿Nos envían datos?
   If psDato$ <> "" Then
      lLen = Len(psDato$)
      'SI => Buscarlo
      For i% = 0 To phCombo.ListCount - 1
          If Left$(phCombo.List(i%), lLen) = psDato$ Then
             'Ya lo encontramos
             phCombo.ListIndex = i%
             Exit For
          End If
      Next
   End If
End Sub

'--------------------------------------------------------
' Objetivo:     Copiar un combo
' Parametros:   Combo2 es origen
'               Combo1 es destino
' Autor:        Teseracto - MTB
' Fecha:        10-04-96
'--------------------------------------------------------
Sub FNCopiarCombo(phCmbOrig As Object, phCmbDest As Object, Optional pSync As Boolean = False)
'Sub FNCopiarCombo(phCmbOrig As Control, phCmbDest As Control, Optional pSync As Boolean = False)
 Dim i%
   
   'Limpia el combo destino
   phCmbDest.Clear
   
   '¿El combo origen tiene datos?
   If phCmbOrig.ListCount > 0 Then
      'Copialos
      For i% = 0 To phCmbOrig.ListCount - 1
         phCmbDest.AddItem phCmbOrig.List(i%)
      Next
      
      'Se va a sincronizar?
      If pSync Then
         'Selecciona el mismo
         phCmbDest.ListIndex = phCmbOrig.ListIndex
      Else
         'No selecciona nada
         phCmbDest.ListIndex = -1
      End If
   End If
End Sub

'Objetivo:  Desencriptar un string con una llave
'           Devuelve la cadena original
'           (si la llave es la misma del encriptamiento)
'
'Nota:      pLlave debe estar en el rango [1..93]
'
'Autor:     Teseracto - MTB,  Miguel A. Torres-Orozco B.
'Fecha:     4-12-96
Function FNDesEncripta(pDato$, pLlave%) As String
   Dim lStr$, i%, lAsc%, lChar$, lNum%

   'Inicializa
   lStr$ = ""

   'Barre la cadena letra por letra
   For i% = 1 To Len(pDato$)
      lChar$ = Mid(pDato$, i%, 1)  'Obtengo la letra
      lAsc% = Asc(lChar$)         'y su ASCII
      Select Case lAsc%

         Case 0 To 32, 127 To 160, 255
         'Caracteres de control: No cambian
         lStr$ = lStr$ + lChar$

         Case 33 To 126
         'Alfabeto normal: se enrollan en este rango
         lNum% = ((lAsc% - 33 + 94 - pLlave%) Mod 94) + 33
         lStr$ = lStr$ + Chr$(lNum%)

         Case 161 To 254
         'Caracteres acentuados: se enrollan en este rango
         lNum% = ((lAsc% - 161 + 94 - pLlave%) Mod 94) + 161
         lStr$ = lStr$ + Chr$(lNum%)

      End Select
   Next

   FNDesEncripta = lStr$
End Function

'Objetivo:  Encriptar un string con una llave
'           Devuelve la cadena encriptada
'Nota:      pLlave debe estar en el rango [1..93]
'
'Autor:     Teseracto - MTB,  Miguel A. Torres-Orozco B.
'Fecha:     4-12-96
Function FNEncripta(pDato$, pLlave%) As String
   Dim lStr$, i%, lAsc%, lChar$, lNum%

   'Inicializa
   lStr$ = ""

   'Barre la cadena letra por letra
   For i% = 1 To Len(pDato$)
      lChar$ = Mid(pDato$, i%, 1)  'Obtengo la letra
      lAsc% = Asc(lChar$)         'y su ASCII
      Select Case lAsc%

         Case 0 To 32, 127 To 160, 255
         'Caracteres de control: No cambian
         lStr$ = lStr$ + lChar$

         Case 33 To 126
         'Alfabeto normal: se enrollan en este rango
         lNum% = ((lAsc% - 33 + pLlave%) Mod 94) + 33
         lStr$ = lStr$ + Chr$(lNum%)

         Case 161 To 254
         'Caracteres acentuados: se enrollan en este rango
         lNum% = ((lAsc% - 161 + pLlave%) Mod 94) + 161
         lStr$ = lStr$ + Chr$(lNum%)

      End Select
   Next

   FNEncripta = lStr$
End Function

'Objetivo: Regresar un path correcto con el terminador "\"
'Autor NOM Teseracto
'9_Dic-96
Function FNFixPath(pPath$) As String
 Dim lPath As String
   lPath = ""
   If Right(pPath$, 1) = "\" Then
      lPath = pPath$
   Else
     lPath = pPath$ & "\"
   End If
   
   FNFixPath = lPath
End Function


'---------------------------------------------------------------------------
' Objetivo:     Despliega un mensaje de error, de esta manera los mensajes
'               de error tienen una apariencia uniforme. Requiere que
'               previamente haya sido llamada la función FNIniciar.
' Autor:        Teseracto - JVO
' Fecha:        08-04-96
'
' Paráms:       psMsj (IN)- Mensaje a desplegar.
' Salida:       No hay
'
Sub FNErrorBox(psMsj$)
 Dim lMouse%
    'Recuerda el aspecto del mouse
    lMouse = Screen.MousePointer
    'Pone el apuntador normal
    Screen.MousePointer = 0   'Default
    'Presenta el mensaje
    MsgBox psMsj$, 16, MsApp$
    'Reestablece el mouse
    Screen.MousePointer = lMouse
End Sub

'---------------------------------------------------------------------------
' Objetivo:     Envuelve la funcion MsgBox conservando aspecto del mouse
' Autor:        Teseracto - MTB
' Fecha:        08-04-96
'
' Paráms:       psMsj (IN)- Mensaje a desplegar.
' Salida:       No hay
'
Function FNMsgBox(Mensaje, Optional Buttons As VbMsgBoxStyle = vbOKOnly, _
                  Optional Title = "", Optional HelpFile, Optional Context) As VbMsgBoxResult
 Dim lMouse%, lBtn As VbMsgBoxResult
 Dim lTitle
 
    'Recuerda el aspecto del mouse
    lMouse = Screen.MousePointer
    
    'Pone el apuntador normal
    Screen.MousePointer = 0   'Default
    
    'Ajusta título
    If Title = "" Then Title = MsApp$
    
    'Presenta el mensaje
    lBtn = MsgBox(Mensaje, Buttons, Title, HelpFile, Context)
    
    'Reestablece el mouse
    Screen.MousePointer = lMouse
    
    'Regresa
    FNMsgBox = lBtn
End Function



' Objetivo:     Despliega un mensaje de error, de esta manera los mensajes
'               de error tienen una apariencia uniforme. Requiere que
'               previamente haya sido llamada la función FNIniciar.
' Autor:        Teseracto - JVO
' Fecha:        08-04-96
'
' Paráms:       psMsj (IN)- Mensaje a desplegar.
' Salida:       No hay
'
Sub FNExclamBox(psMsj$)
 Dim lMouse%
    'Recuerda el aspecto del mouse
    lMouse = Screen.MousePointer
    'Pone el apuntador normal
    Screen.MousePointer = 0   'Default
    'Presenta el mensaje
    MsgBox psMsj$, 48, MsApp$
    'Reestablece el mouse
    Screen.MousePointer = lMouse
End Sub

' Objetivo:     Despliega un mensaje de información, de esta manera los mensajes
'               de información tienen una apariencia uniforme. Requiere que
'               previamente haya sido llamada la función FNIniciar.
' Autor:        Teseracto - JVO
' Fecha:        08-04-96
'
' Paráms:       psMsj (IN)- Mensaje a desplegar.
' Salida:       No hay
'
Sub FNInfoBox(psMsj$)
 Dim lMouse%
    'Recuerda el aspecto del mouse
    lMouse = Screen.MousePointer
    'Pone el apuntador normal
    Screen.MousePointer = 0   'Default
    'Presenta el mensaje
    MsgBox psMsj$, 64, MsApp$
    'Reestablece el mouse
    Screen.MousePointer = lMouse
End Sub


'Reporta Errores al usuario o a un archivo LOG
Public Sub FNReportaError(pMsg$, Optional pEsWarning = False)
 Dim fp As Integer
 Dim lFileName$, lCad$
 
   'Los errores van a pantalla?
   If Not mLogErrors Then
      If pEsWarning Then
         FNExclamBox pMsg$
      Else
         FNErrorBox pMsg$
      End If
      Exit Sub
   End If
   
   'Modo Sin Atención
   If mLogFile <> "NULL" Then
      'Crea el Archivo log
      lFileName$ = mLogFile$ & Format(Date, "YYYYMMDD") & ".Log"
      On Error GoTo FileError
      fp = FreeFile
      Open lFileName$ For Append As #fp
      
      'Arma el error
      lCad$ = "****" & vbCrLf & _
              "Hora: " & Time & vbCrLf & pMsg$ & vbCrLf & vbCrLf & vbCrLf
      
      'Escribe el error en el archivo
      Print #fp, lCad$
   
      'Cierra el archivo
      Close #fp
      On Error GoTo 0
   End If
   
Salida:
   Exit Sub
   
FileError:
   lCad$ = "No se pudo generar el archivo " & lFileName$ & vbCr & _
            Err.Description & vbCr & _
           "El Error a reportar fué:" & vbCr & pMsg$
   FNExclamBox lCad$
   Resume Salida
End Sub


' Objetivo:     Cambia el MousePointer. Permite anidar las llamadas de espera.
' Autor:        Teseracto - JVO
' Fecha:        08-04-96
'
' Paráms:       PnReloj% (IN)- True  = Activa una llamada al cursor de reloj.
'                              False = Cancela una llamada al cursor de reloj.
'                                  Si ya se cancelaron todas las llamadas, el cursor
'                                  recupera su forma original.
' Salida:       No Hay
'
Sub FNMouseEspera(pReloj As Boolean)
Static LnRelojes%

    ' ¿Se activa el reloj?
    If pReloj Then
        ' SI => Agregar uno
        LnRelojes% = LnRelojes% + 1
        Screen.MousePointer = 11        ' HourGlass
    Else
        ' NO => Quitar uno
        LnRelojes% = LnRelojes% - 1
        If LnRelojes% <= 0 Then
            Screen.MousePointer = 0     ' Default
            LnRelojes% = 0
        End If
    End If

End Sub


' Objetivo:     Selecciona el contenido de un TextBox
' Autor:        Teseracto - JVO
' Fecha:        15-04-96
'
' Paráms:       phTxt (IN)- Control que tenga las propiedades SelStart, SelLength (Ej. TextBox)
' Salida:       No hay.
'
Sub FNResaltar(phTxt As Object)
'Sub FNResaltar(phTxt As Control)
    phTxt.SelStart = 0
    phTxt.SelLength = Len(phTxt)
End Sub


' Objetivo:     Valida que un control tenga un número válido.
'               Si no es así avisa y lo hace activo.
'               Si pnMin = NULL => No tiene límite inferior
'               Si pnMax = NULL => No tiene límite superior
' Autor:        Teseracto - JVO, MTB
' Fecha:        25-04-96
'
' Paráms:       phControl (IN)- Control que contiene la información por validar
'               pnTipo%   (IN)- Tipo de valor que debe haber en el control
'                           Puede ser: V_INTEGER, V_LONG, V_SINGLE, V_DOUBLE, V_CURRENCY
' Salida:       TRUE=el número es válido
'
Function FNValidarNumero(phControl As Object, pnTipo%, Optional pnMin, Optional pnMax) As Boolean
'Function FNValidarNumero(phControl As Control, pnTipo%, Optional pnMin, Optional pnMax) As Boolean
Dim lValor
Dim LsError$, LsTipo$, lOK%

    ' Obtener valor (para no estar leyendo)
    lValor = phControl
    LsError$ = ""
    lOK% = True
    
    '*** Modificación CRM : Se queda con el valor numérico ignorando caracteres posteriores
'    If Val(phControl) = 0 Then
'       lOk% = IsNumeric(Left$(LTrim$(lValor), 1))
'    Else
'       lOk% = True
'    End If
'    lValor = Val(phControl)
    '**************************
    
    ' Si está vacío es un valor válido
    ' If LValor = "" Then Exit Function  '*** Modificación MTB

    ' Validar si es número
    If Not (IsNumeric(lValor) And lOK%) Then   'Modificación CRM, Antes: If Not IsNumeric(LValor) Then
        LsError$ = "Debe capturar un valor numérico."
    Else
        ' Validar que sea del tipo especificado
        On Error Resume Next
        Select Case pnTipo%
            Case V_INTEGER:
                LsTipo$ = "Número Entero."
                lValor = CInt(lValor)
            Case V_Long:
                LsTipo$ = "Número Entero."
                lValor = CLng(lValor)
            Case V_Single:
                LsTipo$ = "Número real."
                lValor = CSng(lValor)
            Case V_Double:
                LsTipo$ = "Número real."
                lValor = CDbl(lValor)
            Case V_Currency:
                LsTipo$ = "Número que pueda ser interpretado como Moneda."
                lValor = CCur(lValor)
        End Select

        ' ¿Hubo error?
        If Err = 6 Then         ' Overflow
            LsError$ = "Debe capturar un " & LsTipo$
        Else
            ' ¿Hay límite inferior?
            If Not IsNull(pnMin) Then
                ' Validar Límite
                If (lValor < pnMin) Then
                    LsError$ = "Debe capturar un valor mayor o igual a " & pnMin
                End If
            End If
            ' ¿Hay límite superior?
            If (LsError$ = "") And (Not IsNull(pnMax)) Then
                ' Validar Límite
                If (lValor > pnMax) Then
                    LsError$ = "Debe capturar un valor menor o igual a " & pnMax
                End If
            End If
        End If
    End If

    ' Si fué incorrecto => Avisar
    If LsError$ <> "" Then
        lOK% = False
        MsgBox LsError$, 48, "Dato no válido"
        phControl.SelStart = 0
        phControl.SelLength = Len(phControl)
        On Error Resume Next
        phControl.SetFocus
        On Error GoTo 0
    Else
        lOK% = True
        phControl = lValor
    End If
    
    'Regresa
    FNValidarNumero = lOK%
End Function

' Objetivo:  Formatea una cadena de modo que
'            si incluye apóstrofes Sybase los reconozca.
' Autor:     Teseracto - JVO, MTB
' Fecha:     9-12-96
Function FNTxtSybase(pStr$) As String
   Dim lCad$, Pos As Long

   'Inicia
   lCad$ = pStr$
   Pos = InStr(lCad$, "'")

   'Busca mas apóstrofes
   While Pos > 0
      lCad$ = Left$(lCad$, Pos) + "'" + Mid$(lCad$, Pos + 1)
      Pos = InStr(Pos + 2, lCad$, "'")
   Wend
   
   'Devuelve el resultado
   FNTxtSybase = lCad$
End Function

' Objetivo:  Verifica si una fecha es válida con el formato dado.
'            Regresa la fecha en formato del panel de control si es válida,
'            con / como separador, si no regresa cadena vacía.
' Autor:     Teseracto - CRM, MTB
' Fecha:     15-10-98
'
' Notas:     - La coma no se puede utilizar como separador en el formato
'              ni letras
'
Function FNValidaFecha(pFecha$, pFormato$) As String
 Dim lDay$, lMonth$, lYear$  'Valores dentro de la fecha
 Dim lPosD%, lPosM%, lPosY%  'Valor de la posición para el formato
 Dim lPos$(3)                'Orden de la posición dentro del formato ('D','M','Y')
 Dim lSep$                   'Separador dentro del formato
 Dim lFormat$, lOK%, i%
 Dim lCad$, lPos1%, lPos2%
 Dim lFecha$, lYearN%

 
   On Error GoTo ExitFNValidaFecha
 
   'Inicia
   lOK% = True
   
   'Memoriza formato en mayúsculas
   lFormat$ = UCase(pFormato$)
   'Memoriza fecha sin espacios laterales
   lFecha$ = Trim$(pFecha$)
   
   'Obtiene el orden del día, mes, año
   lPosD% = InStr(lFormat$, "D")
   lPosM% = InStr(lFormat$, "M")
   lPosY% = InStr(lFormat$, "Y")
   
   If (lPosD% < lPosM%) And (lPosD% < lPosY%) Then
      'Dxx
      lPos$(0) = "D"
      If (lPosM% < lPosY%) Then
         'DMY
         lPos$(1) = "M"
         lPos$(2) = "Y"
      Else
         'DYM
         lPos$(1) = "Y"
         lPos$(2) = "M"
      End If
   ElseIf (lPosM% < lPosD%) And (lPosM% < lPosY%) Then
      'Mxx
      lPos$(0) = "M"
      If (lPosD% < lPosY%) Then
         'MDY
         lPos$(1) = "D"
         lPos$(2) = "Y"
      Else
         'MYD
         lPos$(1) = "Y"
         lPos$(2) = "D"
      End If
   ElseIf (lPosY% < lPosD%) And (lPosY% < lPosM%) Then
      'Yxx
      lPos$(0) = "Y"
      If (lPosD% < lPosM%) Then
         'YDM
         lPos$(1) = "D"
         lPos$(2) = "M"
      Else
         'YMD
         lPos$(1) = "M"
         lPos$(2) = "D"
      End If
   Else
      'Error en el formato
      lOK% = False
      FNErrorBox "Error de formato en la llamada a FNValidaFecha()"
      GoTo SalidaFNValidaFecha
   End If
   
   'Extrae la cadena con el separador dentro del formato
   lPos1% = InStr(lFormat$, lPos$(0))
   lPos2% = InStr(lFormat$, lPos$(1))
   lCad$ = Mid$(lFormat$, lPos1%, lPos2% - lPos1%)
   
   i% = 1
   Do While Mid(lCad$, i%, 1) = lPos$(0)
      i% = i% + 1
   Loop
   lCad$ = Mid(lCad$, i%)
   
   'No hay separadores, el mes viene con número
   If lCad$ = "" Then
      'El separador es Null
      lSep$ = ""
   Else 'Busca el separador dentro del formato
      'Busca que no sea espacio ni coma
      For i% = 1 To Len(lCad$)
         If Not ((Mid(lCad$, i%, 1) = " ") Or (Mid(lCad$, i%, 1) = ",")) Then Exit For
      Next
      'Si no se encontró, usa el espacio como separador
      If i% > Len(lCad$) Then
         lSep$ = " "
      Else
         lSep$ = Mid(lCad$, i%, 1)
      End If
   End If
   
   'Si existen separadores
   If lSep <> "" Then
      'Busca separadores en la fecha
      lPos1% = InStr(1, pFecha$, lSep$)
      lPos2% = InStr(lPos1% + 1, pFecha$, lSep$)
      
      'Extrae las tres partes de la fecha
      Select Case lPos$(0)
         Case "D"
            lDay$ = Trim$(Left$(pFecha$, lPos1% - 1))
            If lPos$(1) = "M" Then 'DMY
               lMonth$ = Trim$(Mid$(pFecha$, lPos1% + 1, lPos2% - lPos1% - 1))
               lYear$ = Trim$(Mid$(pFecha$, lPos2% + 1))
            Else                   'DYM
               lYear$ = Trim$(Mid$(pFecha$, lPos1% + 1, lPos2% - lPos1% - 1))
               lMonth$ = Trim$(Mid$(pFecha$, lPos2% + 1))
            End If
         Case "M"
            lMonth$ = Trim$(Left$(pFecha$, lPos1% - 1))
            If lPos$(1) = "D" Then 'MDY
               lDay$ = Trim$(Mid$(pFecha$, lPos1% + 1, lPos2% - lPos1% - 1))
               lYear$ = Trim$(Mid$(pFecha$, lPos2% + 1))
            Else                   'MYD
               lYear$ = Trim$(Mid$(pFecha$, lPos1% + 1, lPos2% - lPos1% - 1))
               lDay$ = Trim$(Mid$(pFecha$, lPos2% + 1))
            End If
         Case "Y"
            lYear$ = Trim$(Left$(pFecha$, lPos1% - 1))
            If lPos$(1) = "D" Then 'YDM
               lDay$ = Trim$(Mid$(pFecha$, lPos1% + 1, lPos2% - lPos1% - 1))
               lMonth$ = Trim$(Mid$(pFecha$, lPos2% + 1))
            Else                   'YMD
               lMonth$ = Trim$(Mid$(pFecha$, lPos1% + 1, lPos2% - lPos1% - 1))
               lDay$ = Trim$(Mid$(pFecha$, lPos2% + 1))
            End If
      End Select
   Else
      'No hay separador, el mes viene como número
      'y son dos números para mes y día (ej.: ddmmyy ó ddmmyyyy)
      'El formato debe coincidir con la fecha en tamaño y sin espacios
      If Len(lFecha$) <> Len(pFormato$) Then GoTo ExitFNValidaFecha
      
      'Extrae las tres partes de la fecha
      Select Case lPos$(0)
         Case "D"
            lDay$ = Left$(lFecha$, 2)
            If lPos$(1) = "M" Then 'DMY
               lMonth$ = Mid$(lFecha$, 3, 2)
               lYear$ = Mid$(lFecha$, 5)
            Else                   'DYM
               If Len(pFormato$) > 6 Then
                  'yyyy
                  lYear$ = Mid$(lFecha$, 3, 4)
               Else
                  'yy
                  lYear$ = Mid$(lFecha$, 3, 2)
               End If
               lMonth$ = Right$(lFecha$, 2)
            End If
         Case "M"
            lMonth$ = Left$(lFecha$, 2)
            If lPos$(1) = "D" Then 'MDY
               lDay$ = Mid$(lFecha$, 3, 2)
               lYear$ = Mid$(lFecha$, 5)
            Else                   'MYD
               If Len(pFormato$) > 6 Then
                  'yyyy
                  lYear$ = Mid$(lFecha$, 3, 4)
               Else
                  'yy
                  lYear$ = Mid$(lFecha$, 3, 2)
               End If
               lDay$ = Right$(lFecha$, 2)
            End If
         Case "Y"
            If Len(pFormato$) > 6 Then
               'yyyy
               lYear$ = Mid$(lFecha$, 1, 4)
               
               If lPos$(1) = "D" Then 'YDM
                  lDay$ = Mid$(lFecha$, 5, 2)
                  lMonth$ = Right$(lFecha$, 2)
               Else                   'YMD
                  lMonth$ = Mid$(lFecha$, 5, 2)
                  lDay$ = Right$(lFecha$, 2)
               End If
               
            Else
               'yy
               lYear$ = Mid$(lFecha$, 1, 2)
               
               If lPos$(1) = "D" Then 'YDM
                  lDay$ = Mid$(lFecha$, 3, 2)
                  lMonth$ = Right$(lFecha$, 2)
               Else                   'YMD
                  lMonth$ = Mid$(lFecha$, 3, 2)
                  lDay$ = Right$(lFecha$, 2)
               End If
               
            End If
      End Select
   End If
        
   'Fuerza cuatro dígitos en el año
   If Len(lYear$) < 3 Then
      lYearN% = CInt(lYear$)
      If (lYearN% >= 0) And (lYearN% < 30) Then
         lYear$ = CStr(lYearN% + 2000)
      Else
         lYear$ = CStr(lYearN% + 1900)
      End If
   End If
  
   'Arma fecha de acuerdo al control panel
   If Month("1/2/2000") = 1 Then
      'MDY
      lCad$ = lMonth$ & "/" & lDay$ & "/" & lYear$
   Else
      'DMY
      lCad$ = lDay$ & "/" & lMonth$ & "/" & lYear$
   End If
   
   'Valida la fecha
   lOK% = IsDate(lCad$)
    
SalidaFNValidaFecha:
   If Not lOK% Then
      'FNErrorBox "La fecha no es válida"
      FNValidaFecha = ""
   Else
      FNValidaFecha = lCad$
   End If
   Exit Function
      
ExitFNValidaFecha:
   lOK% = False
   Resume SalidaFNValidaFecha
   
End Function

'Formatea con FNTxtSybase todos los campos text de una forma
Sub FNFormSybase(phForm As Object)
'Sub FNFormSybase(phForm As Form)
 Dim lCtl As Control
   'Barre los controles
   For Each lCtl In phForm.Controls
       'Si es un TextBox lo formatea
       If TypeOf lCtl Is TextBox Then lCtl.Text = FNTxtSybase(lCtl.Text)
   Next
End Sub

'(Des)Habilita un Frame y los controles que están dentro
Sub FNHabilitaFrame(phFrame As Object, pEnable As Boolean)
'Sub FNHabilitaFrame(phFrame As Frame, pEnable As Boolean)
 Dim lCtl As Control, lFrm As Object
   
   'Inicia
   Set lFrm = phFrame
   'Obtiene la Forma que contiene al Frame
   Do While Not (TypeOf lFrm Is Form)
      Set lFrm = lFrm.Container
   Loop
   
   'Barre los Controles del Frame
   For Each lCtl In lFrm.Controls
      On Error GoTo Err_NextControl
      If lCtl.Container Is phFrame Then
         'Los (des)habilita
         FNHabilita lCtl, pEnable
      End If
NextControl:
   Next
   
   '(Des)habilita el frame
   phFrame.Enabled = pEnable
   
   Exit Sub
   
Err_NextControl:
   Resume NextControl
End Sub







'(Des)Habilita un Control
Sub FNHabilita(phCtl As Object, pEnable As Boolean)
'Sub FNHabilita(phCtl As Control, pEnable As Boolean)
 
   'A los siguientes controles no les hace nada
   If TypeOf phCtl Is Label Then Exit Sub
    
   If pEnable Then 'HABILITAR
      'TextBoxes
      If TypeOf phCtl Is TextBox Then
         phCtl.Locked = False
         phCtl.BackColor = vbWindowBackground
      
      'ComboBoxes
      ElseIf TypeOf phCtl Is ComboBox Then
         phCtl.Enabled = True
         phCtl.BackColor = vbWindowBackground
      
      'Otros Controles
      Else
         On Error Resume Next
         phCtl.Enabled = True
         'phCtl.BackColor = vbWindowBackground
         On Error GoTo 0
      End If
   Else 'DESHABILITAR
      'TextBoxes
      If TypeOf phCtl Is TextBox Then
         phCtl.Locked = True
         phCtl.BackColor = vbButtonFace
      
      'ComboBoxes
      ElseIf TypeOf phCtl Is ComboBox Then
         phCtl.Enabled = False
         phCtl.BackColor = vbButtonFace
      
      'Otros Controles
      Else
         On Error Resume Next
         phCtl.Enabled = False
         'phCtl.BackColor = vbButtonFace
         On Error GoTo 0
      End If
   End If
End Sub


'Convierte un dato tipo Date a una cadena reconocible por Sybase
Function FNDateSybase(pDate As Date) As String
   'Arma la cadena
   FNDateSybase = "convert(datetime,'" & _
                  Format(pDate, "DD-MM-YYYY HH:MM:SS") & "',105)"
End Function



'--------------------------------------------------------
' Objetivo:     Leer el VolumeLabel y el Num de serie de un disco
' Parametros:   psPath$     (IN)  : Ruta que contiene el drive a probar
'               psVolLabel$ (OUT) : Regresa la etiqueta o vacio si hubo error
'               pSerialNum  (OUT) : Regresa el NumSerie o cero si hubo error
' Autor:        Teseracto - MTB
' Fecha:        2-08-2000
'
' Notas:       -psPath debe apuntar a una ruta válida (la que sea) como
'               "C:\" o "C:\Mis documentos"
'               No usar solo la letra de la unidad como "C" o "C:"
'              -Si se pide "A:\" y no hay un disco, devuelve "", 0
'--------------------------------------------------------
Sub FNGetDiskInfo(psDrive$, psVolLabel$, pSerialNum As Long)
 Dim lSerial As Long, lLabel$, lLen As Long, lRet As Long
  
   'Inicia
   lLen = 20
   lLabel$ = String(lLen, 0)
   'Pide Info
   lRet = GetVolumeInformation(psDrive$, lLabel$, lLen, lSerial, 0&, 0&, vbNullString, 0&)
   'Hubo Error?
   If lRet = 0 Then
      'Regresa error
      psVolLabel$ = ""
      pSerialNum = 0
   Else
      'Ajusta la cadena (quita los nulos del final)
      lLabel$ = Left(lLabel$, InStr(lLabel$, Chr$(0)) - 1)
      'Regresa valores
      
      psVolLabel$ = lLabel$
      pSerialNum = lSerial
   End If
End Sub















'****************************************************************
'****************************************************************
'*** Funciones para el Registro de Windows
'****************************************************************
'****************************************************************




'--------------------------------------------------------
' Objetivo:     Abrir una llave del registro de windows para lectura o escritura
' Parametros:   phMainKey: Handle de la llave principal del registro (KEY_*)
'               psSubKey: Cadena con la subllave (Ruta)
'               pCreateKey: True - Crea la llave
'                           False - Solo la abre (si no existe devuelve error)
' Salida:       Devuelve el Handle de la llave abierta
'               o 0 si hubo error
' Autor:        Teseracto - MTB
' Fecha:        2-08-2000
'
' Notas:        Siempre se debe de cerrar el registro si se abrió con exito
' Ejemplo:
'     lhKey = FNRegistroAbrir(HKEY_CURRENT_CONFIG, "System\CurrentControlSet\Control\Print\Printers")
'     lDefaultPrinter$ = FNRegistroLeer(lhKey, "Default")
'     FNRegistroCerrar (lhKey)
'--------------------------------------------------------
Function FNRegistroAbrir(phMainKey As Long, psSubKey$, Optional pCreateKey As Boolean = False, _
                         Optional pReadOnly As Boolean = False) As Long
 Dim lRet As Long, lhKey As Long, lDisp As Long
 Dim lAcceso As Long

   'Se desea crear la llave?
   If pCreateKey Then
      'Crea/Abre la llave y obtiene un handle
      lRet = RegCreateKeyEx(phMainKey, psSubKey$, 0&, vbNullString, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, 0&, lhKey, lDisp)
   Else
      'Abre la llave y obtiene un handle
      lAcceso = IIf(pReadOnly, KEY_READ, KEY_ALL_ACCESS)
      lRet = RegOpenKeyEx(phMainKey, psSubKey$, 0, lAcceso, lhKey)
   End If

   'Si hubo error el handle vale cero
   If lRet <> ERROR_SUCCESS Then lhKey = 0

   'Regresa
   FNRegistroAbrir = lhKey
End Function

'--------------------------------------------------------
' Objetivo:     Cerrar una llave del registro de windows abierta previamente con
'               FNRegistroAbrir
' Parametros:   phKey: Handle de la llave a cerrar
' Autor:        Teseracto - MTB
' Fecha:        2-08-2000
'
' Notas:        Siempre se debe de cerrar el registro si se abrió con exito
' Ejemplo:
'     lhKey = FNRegistroAbrir(HKEY_CURRENT_CONFIG, "System\CurrentControlSet\Control\Print\Printers")
'     lDefaultPrinter$ = FNRegistroLeer(lhKey, "Default")
'     FNRegistroCerrar (lhKey)
'--------------------------------------------------------
Sub FNRegistroCerrar(phKey As Long)
 Dim lRet As Long
   'Cierra la llave, si está abierta
   If phKey <> 0 Then lRet = RegCloseKey(phKey)
End Sub



'--------------------------------------------------------
' Objetivo:     Leer una variable dentro de una llave del registro de windows
' Parametros:   phKey: Handle de la llave (abierta)
'               psVariable: Nombre de la variable
'               Salida: El valor de la variable o Empty si hubo error
' Autor:        Teseracto - MTB
' Fecha:        2-08-2000
'
' Notas:        La llave se debe abrir antes con FNRegistroAbrir
'               Solo se pueden leer variables de tipo string o long (dword)
' Ejemplo:
'     'Obtener el nombre de la impresora actual
'     lhKey = FNRegistroAbrir(HKEY_CURRENT_CONFIG, "System\CurrentControlSet\Control\Print\Printers")
'     lDefaultPrinter$ = FNRegistroLeer(lhKey, "Default")
'     FNRegistroCerrar (lhKey)
'--------------------------------------------------------
Function FNRegistroLeer(phKey As Long, psVariable$, Optional pDefault As Variant) As Variant
 Dim lType As Long, lRet As Long, lBufSize As Long
 Dim lCadena$, lNum As Long
 Dim RetVal As Variant

   'Inicia
   RetVal = Empty

   'Determinamos el tipo y longitud del dato
   lRet = RegQueryValueExNULL(phKey, psVariable$, 0&, lType, 0&, lBufSize)

   'Si hubo error sale inmediatamente
   If lRet <> ERROR_SUCCESS Then GoTo FNRegLeer_Salida

   'Procesa segun el tipo de dato
   Select Case lType
      Case REG_SZ: 'Cadena
         'Prepara un buffer del tamaño adecuado
         lCadena$ = String(lBufSize, 0)
         'Lee el valor
         lRet = RegQueryValueExString(phKey, psVariable$, 0&, lType, lCadena, lBufSize)

         'Si no hubo error ajusta la cadena y la devuelve
         If lRet = ERROR_NONE Then RetVal = Left$(lCadena, lBufSize - 1)

      Case REG_DWORD:
         'Lee el valor
         lRet = RegQueryValueExLong(phKey, psVariable$, 0&, lType, lNum, lBufSize)

         'Si no hubo error lo devuelve
         If lRet = ERROR_NONE Then RetVal = lNum
      Case Else
         'No se soportan otros tipos (por ahora)
         FNErrorBox "La variable en el registro '" & psVariable & "' es de un tipo no soportado"
   End Select

FNRegLeer_Salida:
   If IsEmpty(RetVal) Then RetVal = pDefault
   FNRegistroLeer = RetVal
End Function


'--------------------------------------------------------
' Objetivo:     Escribir una variable dentro de una llave del registro de windows
' Parametros:   phKey: Handle de la llave (abierta)
' Autor:        Teseracto - MTB
'               psVariable: Nombre de la variable
' Fecha:        2-08-2000
'
' Notas:        La llave se debe abrir antes con FNRegistroAbrir
'               Solo se pueden leer variables de tipo string o long (dword)
' Ejemplo:
'--------------------------------------------------------
Sub FNRegistroEscribir(phKey As Long, psVariable$, ByVal pValor As Variant)
    Dim lNum As Long, lCad$
    Dim lRet As Long

    'Inicia
    lRet = ERROR_SUCCESS

    'Es una Cadena?
    If VarType(pValor) = vbString Then
       'La ajusta como asciiz
       lCad$ = pValor & Chr$(0)
       'Escribe el valor
       lRet = RegSetValueExString(phKey, psVariable$, 0&, REG_SZ, lCad$, Len(lCad$))
    Else
       'El valor se puede convertir en un long?
       On Error GoTo FNRegEscr_Err
       lNum = CLng(pValor)
       On Error GoTo 0
       'Escribe el valor
       lRet = RegSetValueExLong(phKey, psVariable$, 0&, REG_DWORD, lNum, 4)
    End If

FNRegEscr_Salida:
   If lRet <> ERROR_SUCCESS Then FNErrorBox ("No se pudo guardar el valor en el registro de windows")
   Exit Sub

FNRegEscr_Err:
   FNErrorBox "FNRegistroEscribir: El valor a almacenar debe ser una cadena o un long"
   Resume FNRegEscr_Salida
End Sub

'--------------------------------------------------------
' Objetivo:     Borrar una variable dentro de una llave del registro de windows
' Parametros:   phKey: Handle de la llave (abierta)
'               psVariable: Nombre de la variable
' Salida:       True  - La llave se borró con exito
'               False - Hubo algun error
' Autor:        Teseracto - MTB
' Fecha:        2-08-2000
'
' Notas:        La llave se debe abrir antes con FNRegistroAbrir
'--------------------------------------------------------
Function FNRegistroBorrar(phKey As Long, psVariable$) As Boolean
   FNRegistroBorrar = (RegDeleteValue(phKey, psVariable$) = ERROR_SUCCESS)
End Function

'--------------------------------------------------------
' Objetivo:     Borrar una llave del registro de windows
' Parametros:   phMainKey: Handle de la llave principal del registro (KEY_*)
'               psSubKey: Cadena con la subllave (Ruta)
' Salida:       True  - La llave se borró con exito
'               False - Hubo algun error
' Autor:        Teseracto - MTB
' Fecha:        2-08-2000
'
' Notas:        En Win95/98 se borra la subllave y todas las sub-subllaves
'               En WinNT la subllave no puede tener sub-subllaves
'--------------------------------------------------------
Function FNRegistroBorrarLlave(phMainKey As Long, psSubKey$)
   FNRegistroBorrarLlave = (RegDeleteKey(phMainKey, psSubKey$) = ERROR_SUCCESS)
End Function


'--------------------------------------------------------
' Objetivo:     Leer RÁPIDAMENTE una variable dentro de una llave del registro de windows
' Parametros:   phMainKey: Handle de la llave principal del registro (KEY_*)
'               psSubKey: Cadena con la subllave (Ruta)
'               psVariable: Nombre de la variable
'               Salida: El valor de la variable o Empty si hubo error
' Autor:        Teseracto - MTB
' Fecha:        2-08-2000
'
' Notas:       -Esta funcion NO SE RECOMIENDA si se van a leer
'               varias variables dentro de la misma llave,
'               para ello usar mejor FNRegistroLeer
'              -Solo se pueden leer variables de tipo string o long (dword)
'--------------------------------------------------------
Function FNRegistroGetVal(phMainKey As Long, psSubKey$, psVariable$, Optional pDefault As Variant) As Variant
 Dim lhKey As Long, RetVal As Variant
   'Abre la llave
   lhKey = FNRegistroAbrir(phMainKey, psSubKey$, , True)
   RetVal = FNRegistroLeer(lhKey, psVariable$, pDefault)
   FNRegistroCerrar (lhKey)
   'Regresa
   FNRegistroGetVal = RetVal
End Function


'--------------------------------------------------------
' Objetivo:     Escribir RÁPIDAMENTE una variable dentro de una llave del registro de windows
' Parametros:   phMainKey: Handle de la llave principal del registro (KEY_*)
'               psSubKey: Cadena con la subllave (Ruta)
'               psVariable: Nombre de la variable
'               pValor: Valor de la variable
' Autor:        Teseracto - MTB
' Fecha:        2-08-2000
'
' Notas:       -Esta funcion NO SE RECOMIENDA si se van a escribir
'               varias variables dentro de la misma llave,
'               para ello usar mejor FNRegistroEscribir
'              -Solo se pueden leer variables de tipo string o long (dword)
'--------------------------------------------------------
Sub FNRegistroSetVal(phMainKey As Long, psSubKey$, psVariable$, pValor As Variant)
 Dim lhKey As Long
   'Abre la llave
   lhKey = FNRegistroAbrir(phMainKey, psSubKey$, True)
   'Escribe la variable
   FNRegistroEscribir lhKey, psVariable$, pValor
   'Cierra la llave
   FNRegistroCerrar (lhKey)
End Sub

