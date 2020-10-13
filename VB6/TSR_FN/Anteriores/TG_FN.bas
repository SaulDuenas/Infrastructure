Attribute VB_Name = "TG_FN"
' CST_FN - Teseracto (c) 1998
'          Ing. Carlos J. Rivero Moreno.
'          Ing. Miguel A. Torres-Orozco Bermeo.
' Funciones de uso general
'
Option Explicit
'---------------------------------------------------------------------------
'  Constantes para los tipos
'---------------------------------------------------------------------------
Global Const V_INTEGER = 2   ' Integer
Global Const V_LONG = 3      ' Long
Global Const V_SINGLE = 4    ' Single
Global Const V_DOUBLE = 5    ' Double
Global Const V_CURRENCY = 6  ' Currency


'---------------------------------------------------------------------------
' Variables globales
'---------------------------------------------------------------------------
Dim MsINIFileName$                      ' Archivo de inicialización
Dim MsApp$                              ' Nombre descriptivo de la aplicación
Dim MhAvance As Control                 ' Para una barra de avance
Dim MhStatus As Control                 ' Para una barra de estatus

'---------------------------------------------------------------------------
'Constantes Globales para los MessageBox (MsgBox)
'---------------------------------------------------------------------------
Global Const IDCANCEL = 2 'Al presionar Cancel en el MsgBox
Global Const IDYES = 6 'Al presionar SI en el MsgBox
Global Const IDNO = 7 'Al presionar NO en el MsgBox
Global Const MYesNoCuestion = 36  'Botones de YES,No e icono Cuestion
Global Const MYesNoCancel = 51 'Botones de YES,No, Cancel e icono Asterisk
Global Const MIconExclamation = 48  'Exclamacion y OK

'---------------------------------------------------------------------------
'API's Windows
'---------------------------------------------------------------------------
#If Win32 Then 'Windows de 32 bits
   Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
   Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
   Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
   Declare Function GetActiveWindow Lib "user32" () As Long
   Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
   Declare Function ShowWindow Lib "user32" (ByVal hWnd As Long, ByVal nCmdShow As Long) As Long
   Declare Function SFocus Lib "user32" Alias "SetFocus" (ByVal hWnd As Long) As Long
#Else 'Windows de 16 bits
'   Declare Function SendMessage Lib "user" (ByVal hWnd As Integer, ByVal wMsg As Integer, ByVal wParam As Integer, lParam As Any) As Long
'   Declare Function GetPrivateProfileString Lib "kernel" (ByVal lpApplicationName As String, lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Integer, ByVal lpFileName As String) As Integer
'   Declare Function WritePrivateProfileString Lib "kernel" (ByVal lpApplicationName As String, lpKeyName As Any, lpString As Any, ByVal lpFileName As String) As Integer
'   Declare Function GetActiveWindow Lib "user" () As Integer
'   Declare Function FindWindow% Lib "user" (ByVal lpClassName As Any, ByVal lpCaption As Any)
'   Declare Function ShowWindow% Lib "user" (ByVal Handle As Integer, ByVal Cmd As Integer)
'   Declare Function SFocus% Lib "user" Alias "SetFocus" (ByVal Handle As Integer)
#End If

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
Function FNIniciar(psApp$, psINIFileName$, Optional pMultiInstance As Boolean = False)
Dim lOK%, lPath$, lhWnd&, lStr$, lTitle$
    'Inicio
    lOK% = False
    
    'Inicializando la aplicacion
    
    '0. Obtiene el path de la aplicacion
    lPath = FNExePath()
    
    '1. Nombre de la aplicación
    MsApp$ = psApp$

    '2. Nombre del archivo *.INI
    MsINIFileName$ = lPath & psINIFileName$
   
    If (Not pMultiInstance) And App.PrevInstance Then
       On Error Resume Next
       lTitle$ = FNParametroLeer("HWND", "Title", MsApp$)  'Obtiene el título de la ventana
       AppActivate lTitle$                       'Activa ventana de la instancia anterior
       On Error GoTo 0

       'lhWnd& = GetActiveWindow()               'Obtiene el handle
       'Alternativa:
       'Guardar en el evento load de la ventana principal su HandleWindow
       lhWnd& = CLng(FNParametroLeer("HWND", "hWnd", "0"))    'Obtiene el handle
       ShowWindow lhWnd&, 1         'Restaura la ventana (1=Normal, 9=Restore)
    Else
       lOK% = True
    End If
    'Termina
    FNIniciar = lOK%
End Function


'------------------------------------------------------
'Objetivo: Centrar una forma en la pantalla
'
'Parametros:
'       pCentForm   Nombre de la forma a centrar
'
'Fecha: 14-NOV-96
'------------------------------------------------------
Sub FNCentrar(pCentForm As Form)
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
Sub FNComboSeleccionar(phCombo As Control, psDato$)
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
Sub FNCopiarCombo(phCmbOrig As Control, phCmbDest As Control, _
                  Optional pSync As Boolean = False)
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

'Objetivo: Regresar el path correcto de la aplicacion
'Autor NOM Teseracto
'9_Dic-96
Function FNExePath() As String
 Dim LnOk As String
  LnOk = ""
  If Right(App.Path, 1) = "\" Then
     LnOk = App.Path
  Else
    LnOk = App.Path & "\"
  End If

 FNExePath = LnOk

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

' Objetivo:     Escribe un parámetro de un archivo *.INI. Requiere que
'               previamente haya sido llamada la función FNIniciar
' Autor:        Teseracto - JVO
' Fecha:        09-04-96
'
' Paráms:       psSeccion$  (IN) - Nombre de la [sección] en la que se encuentra
'                                  la variable.
'               psVariable$ (IN) - Variable a la que se le asignará valor.
'               psValor$    (IN) - Valor de la variable
' Salida:       TRUE - Se asignó el valor a la variable
'
Function FNParametroEscribir(psSeccion$, psVariable$, psValor$, Optional pFullFileName$ = "") As Boolean
Dim szBuffer As String * 50

    'Utiliza el archivo INI de la aplicación por default
    If pFullFileName$ = "" Then pFullFileName$ = MsINIFileName$

    ' Escribir el parámetro
    FNParametroEscribir = CBool(WritePrivateProfileString(ByVal psSeccion$, ByVal psVariable$, ByVal psValor$, ByVal pFullFileName$))
    
End Function

' Objetivo:     Lee un parámetro de un archivo *.INI. Requiere que
'               previamente haya sido llamada la función FNIniciar
' Autor:        Teseracto - JVO
' Fecha:        09-04-96
'
' Paráms:       psSeccion$  (IN) - Nombre de la [sección] en la que se encuentra
'                                  la variable.
'               psVariable$ (IN) - Variable a la que se le leerá el valor.
'               psDefault$  (IN) - Valor default de la variable
' Salida:       Valor de la variable o psDefault$ si no existe o hubo un error
'
Function FNParametroLeer(psSeccion$, psVariable$, psDefault$, Optional pFullFileName$ = "") As String
Dim szBuffer As String * 80
Dim LnTmp&

    'Utiliza el archivo INI de la aplicación por default
    If pFullFileName$ = "" Then pFullFileName$ = MsINIFileName$

    ' Regresar el valor leído
    LnTmp& = GetPrivateProfileString(ByVal psSeccion$, ByVal psVariable, ByVal psDefault$, ByVal szBuffer, Len(szBuffer), ByVal pFullFileName$)
    LnTmp& = InStr(szBuffer, Chr$(0))
    FNParametroLeer$ = Left$(szBuffer, LnTmp& - 1)

End Function

' Objetivo:     Selecciona el contenido de un TextBox
' Autor:        Teseracto - JVO
' Fecha:        15-04-96
'
' Paráms:       phTxt (IN)- Control que tenga las propiedades SelStart, SelLength (Ej. TextBox)
' Salida:       No hay.
'
Sub FNResaltar(phTxt As Control)
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
Function FNValidarNumero(phControl As Control, pnTipo%, Optional pnMin, Optional pnMax) As Boolean
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
            Case V_LONG:
                LsTipo$ = "Número Entero."
                lValor = CLng(lValor)
            Case V_SINGLE:
                LsTipo$ = "Número real."
                lValor = CSng(lValor)
            Case V_DOUBLE:
                LsTipo$ = "Número real."
                lValor = CDbl(lValor)
            Case V_CURRENCY:
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
Sub FNFormSybase(phForm As Form)
 Dim lCtl As Control
   'Barre los controles
   For Each lCtl In phForm.Controls
       'Si es un TextBox lo formatea
       If TypeOf lCtl Is TextBox Then lCtl.Text = FNTxtSybase(lCtl.Text)
   Next
End Sub

'(Des)Habilita un Frame y los controles que están dentro
Sub FNHabilitaFrame(phFrame As Frame, pEnable As Boolean)
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
Sub FNHabilita(phCtl As Control, pEnable As Boolean)
 
   'A los siguientes controles no les hace nada
   If TypeOf phCtl Is Label Then Exit Sub
    
   If pEnable Then 'HABILITAR
      'TextBoxes
      If TypeOf phCtl Is TextBox Then
         phCtl.Locked = False
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
