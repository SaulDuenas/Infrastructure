Attribute VB_Name = "TG_DBado"
' CST_DBado - Tecnog�nesis (c) 2001
'             Ing. Miguel A. Torres-Orozco Bermeo.
' Funciones de Base de Datos y Cursores para ADO
' con soporte para m�ltiples bases de datos
'
Option Explicit
''''********** TIPOS GLOBALES *****
'''Public Enum TTipoDB     'Tipo      Par�metros (ademas de User y Password)
'''   c_ConnString         'General   ConnString (Se especifica el Connection String Completo)
'''   c_SQLServer          'OLE DB    ServerName, DatabaseName
'''   c_SQLServerIP        'OLE DB    IPAddress, Port, DatabaseName
'''   c_ODBCdsn            'ODBC      DSN
'''   c_Access2000         'OLE DB    FileName
'''   c_Excel              'OLE DB    FileName, ConHeader
'''   c_MySQL              'OLE DB    -nada m�s-
''''   c_Texto
''''   c_Oracle
''''   c_Oracle_ms
''''   c_Sybase
''''   c_AS400_ibm
''''   c_AS400_ms
'''End Enum


Private Const DBDEFAULT = -1   'Significa usar la base de datos por default
                              'DEBE VALER -1 ***NO CAMBIAR***
'---------------------------------------------------------------------------
' CONSTANTE para el n�mero de bases de datos
'---------------------------------------------------------------------------
Private Const cMaxConn = 10     '10 conexiones (base uno)

'---------------------------------------------------------------------------
' VARIABLES DE M�DULO
'---------------------------------------------------------------------------

Dim MhConn(cMaxConn) As ADODB.Connection  ' Conexiones
Dim MhConnUsed(cMaxConn) As Boolean       ' Banderas de uso de Conexiones
Dim MhRS() As Recordset                 ' Cursores
Dim MhRSUsed%()                         ' Banderas de uso de cursor *** MTB ***
Dim MnPos() As Long                     ' Posici�n del cursor
Dim MnRSMax%, MnRSUsd%                  ' Contadores de los cursores
Dim MsMsj As String                     ' Para los mensajes de Error

Dim MhConnDef As Integer                ' Manejador de la base de datos 'default'

Dim mLogFile As String                  'Nombre del archivo Log
Dim mUnattended As Boolean              'Indica si es una aplicaci�n no atendida
                                        'por lo que debe utilizar archivos LOG
                                        'para reportar errores

'---------------------------------------------------------------------------
' CONSTANTES
'---------------------------------------------------------------------------
Private Const DB_BLOCK_DS = 3
Private Const LLAVE_SEP = 130           'Espacios de las Llaves


'---------------------------------------------------------------------------
' Objetivo:     Inicializar variables asociadas al manejo de bases de datos
'               Se debe de llamar una sola vez al inicio del programa
'               antes de usar cualquier funci�n DB
' Par�metros:
'    pLogFileName$ - (IN):  Prefijo del archivo LOG, si es cadena vac�a no genera Logs
'                           y env�a los errores a pantalla.
'                           Se le concatena la fecha y se pone extensi�n .Log
'                           Ej. si el par�metro vale "MiApp" genera archivos
'                               MiAppYYYYMMDD.Log
'
' Autor:        Tecnog�nesis - MTB,CRM
' Fecha:        11-Oct-2001
Sub DBIniciar(Optional pLogFileName$ = "")
 Dim i%
 
   'Inicia
   mUnattended = (pLogFileName$ <> "")
   'Si es modo no atendido crea directorio para
   'los archivos .log
   If mUnattended Then
      On Error Resume Next
      MkDir FNExePath & "Log"
      On Error GoTo 0
      mLogFile = FNExePath & "Log\" & pLogFileName$
   End If
   
   'Iniciar bases de datos
   For i% = 1 To cMaxConn
      MhConnUsed(i%) = False
   Next
 
   'Iniciar cursores
   ReDim MhRS(1 To DB_BLOCK_DS)
   ReDim MhRSUsed%(1 To DB_BLOCK_DS)
   ReDim MnPos(1 To DB_BLOCK_DS)
   For i% = 1 To DB_BLOCK_DS
      Set MhRS(i%) = Nothing
      MhRSUsed%(i%) = False
   Next
   MnRSMax% = DB_BLOCK_DS
   MnRSUsd% = 0
   
   'Iniciar base de datos por default
   MhConnDef = 1
   
End Sub


'---------------------------------------------------------------------------
' Objetivo:     Conectarse a una base de datos
' Importante:   Si esta funci�n devuelve TRUE se DEBE cerrar la
'               base de datos con DBDesconectar()
' Autor:        Tecnog�nesis - MTB,CRM
' Fecha:        11-Oct-2001
Function DBConectar(phDB%, pDSN$, Optional pUsr$, Optional pPwd$, Optional pConnStr$ = "") As Boolean
'
'USO:
'   phDB%     (OUT)    Handle de la base de datos, o cero si no se pudo abrir
'   pDSN$     (IN)     ODBC: Data Source Name, como aparece en ODBC en Control Panel
'                       Jet: Nombre de la base de datos con ruta
'   pUsr$     (IN)     ODBC: Usuario, para firmarse en la base de datos
'                       Jet: Tipo de la base de datos externa (ejemplo: "DBase IV" , "Excel 5.0" , etc.)
'   pPwd$     (IN)     S�lo ODBC: Password,  para firmarse en la base de datos
'  pConnStr$  (IN)    Si es vac�o, se ignora, de lo contrario
'                     se utiliza como ConnectionString, ignorando el par�metro pDSN$
'SALIDA:
'   True                Si se pudo conectar a la base de datos
'
'EJEMPLO:
'   DBIniciar
'   if DBConectar(lhDB%,"TAE","tae","taebanpais",True) then
'       ' Procesar Datos
'       DBDesconectar lhDB%     ' SIEMPRE cerrar la base de datos
'   else
'       FNErrorBox "No se pudo conectar a la base de datos"
'   endif
'   DBTerminar
'
 Dim lOK As Boolean, i%
 Dim lConn$
 Dim lErrDB As ADODB.Error

   ' INICIAR
   On Error GoTo DBConectar_ERR:
   lOK = False
      
   'Busca si hay conexi�n libre
   For i% = 1 To cMaxConn
      If Not MhConnUsed(i%) Then
         lOK = True
         Exit For
      End If
   Next
   
   'Si hay conexi�n libre, se conecta
   If lOK Then
      'Arma la cadena de conexi�n
      If pConnStr = "" Then
         lConn$ = "DSN=" & pDSN$ & "" & _
                  ";UID=" & pUsr$ & _
                  ";PWD=" & pPwd$
      Else
         lConn$ = pConnStr$
      End If
      
      'Abre la conexi�n
      Set MhConn(i%) = New ADODB.Connection
      MhConn(i%).Open lConn$, pUsr$, pPwd$
      MhConnUsed(i%) = True
      phDB% = i%
   Else
      'No hay conexi�n disponible
      FNErrorBox "No hay espacio para abrir otra conexi�n de base de datos"
   End If
   
   ' TERMINAR
DBConectar_END:
   If Not lOK Then phDB% = 0
   
   DBConectar = lOK
   Exit Function
   
   ' ERROR
DBConectar_ERR:
   MsMsj = "Ocurri� un error al intentar abrir la base de datos: " & vbCrLf
   For Each lErrDB In MhConn(i%).Errors
      MsMsj = MsMsj & "Descrip: " & lErrDB.Description & vbCrLf
      MsMsj = MsMsj & "N�mero: " & lErrDB.Number & " (" & Hex$(lErrDB.Number) & ")" & vbCrLf
      MsMsj = MsMsj & "ProvidErr: " & lErrDB.SQLState & vbCrLf
   Next
   DBReportaError MsMsj
   lOK = False
   Resume DBConectar_END:
End Function

'*** Funciones de Conexi�n a Bases de datos Espec�ficas
'Funcionan de manera id�ntica a DBConectar (llaman a DBConectar)

' SQL Server
Function DBConectar_SQLServer(phDB%, pServerName$, pDBName$, pUsr$, pPwd$) As Boolean
 Dim lConnStr As String
   'Arma Cadena de Conexi�n
   lConnStr = "Provider=sqloledb;" & _
           "Data Source=" & pServerName$ & ";" & _
       "Initial Catalog=" & pDBName & ";" & _
               "User ID=" & pUsr$ & ";" & _
              "Password=" & pPwd$ & ";"
   
   'Se conecta
   DBConectar_SQLServer = DBConectar(phDB%, "", pConnStr:=lConnStr)
End Function

' SQL Server remoto v�a TCP/IP (lento)
Function DBConectar_SQLServerIP(phDB%, pIPAddr$, pDBName$, pUsr$, pPwd$, Optional pPort$ = "1433") As Boolean
 Dim lConnStr As String
   'Arma Cadena de Conexi�n
   lConnStr = "Provider=sqloledb;" & _
       "Network Library=DBMSSOCN;" & _
           "Data Source=" & pServerName$ & ";" & _
       "Initial Catalog=" & pDBName & ";" & _
               "User ID=" & pUsr$ & ";" & _
              "Password=" & pPwd$ & ";"
   
   'Se conecta
   DBConectar_SQLServerIP = DBConectar(phDB%, "", pConnStr:=lConnStr)
End Function
'
' A�adir mas conexiones aqu� conforme se vayan necesitando
'***

' Objetivo:     Desconectarse de la base de datos que haya sido
'               abierta con DBConectar
' Autor:        Tecnog�nesis - MTB,CRM
' Fecha:        24-11-98
Sub DBDesconectar(Optional phDB% = DBDEFAULT)
'
'USO:
'   phDB%      (IN)     Handle de la base de datos
'SALIDA:
'   No hay
'
'EJEMPLO:
'   DBIniciar
'   if DBConectar%(lhDB%,"TAE","tae","taebanpais",True) then
'       ' Procesar Datos
'       DBDesconectar lhDB%     ' SIEMPRE cerrar la base de datos
'   else
'       FNErrorBox "No se pudo conectar a la base de datos"
'   endif
'   DBTerminar
'
 Dim lMsg$
 Dim lErrDB As ADODB.Error
    ' INICIAR
    On Error GoTo DBDesconectar_ERR:

    'Toma la base de datos por default
    If phDB% = DBDEFAULT Then phDB% = MhConnDef
    
    ' Intentar cerrar la base de datos
    MhConn(phDB%).Close
    MhConnUsed(phDB%) = False
    phDB% = 0

    ' TERMINAR
DBDesconectar_END:
    Exit Sub

    ' ERROR
DBDesconectar_ERR:
   lMsg = "Ocurri� un error al intentar cerrar la base de datos: " & vbCrLf
   For Each lErrDB In MhConn(phDB%).Errors
      lMsg = lMsg & "Descrip: " & lErrDB.Description & vbCrLf
      lMsg = lMsg & "N�mero: " & lErrDB.Number & " (" & Hex$(lErrDB.Number) & ")" & vbCrLf
      lMsg = lMsg & "ProvidErr: " & lErrDB.SQLState & vbCrLf
   Next
   DBReportaError lMsg
   Resume DBDesconectar_END:
    
End Sub

' Objetivo:     Probar una conexi�n
' Autor:        Tecnog�nesis - MTB
' Fecha:        8-Nov-2001
' Notas:        Realiza una consulta para verificar si la conexi�n funciona
'               Esto es �til solo en conexiones RDS en donde DBConectar no regresa errores
Function DBPruebaConexion(Optional phDB% = DBDEFAULT) As Boolean
 Dim lOK As Boolean
 Dim lRst As ADODB.Recordset
 
   'Inicia
   lOK = True
   
   'Toma la base de datos por default
   If phDB% = DBDEFAULT Then phDB% = MhConnDef
   
   'Intenta hacer un acceso
   Set lRst = New ADODB.Recordset
   On Error GoTo Err_Test
   lRst.Open "SELECT 1", MhConn(phDB%), adOpenStatic
   
   'Cierra el recordset
   On Error Resume Next
   lRst.Close
   Set lRst = Nothing

   'Termina
   DBPruebaConexion = lOK
   Exit Function
   
Err_Test:
   lOK = False
   Resume Next
End Function



' Objetivo:     Abre un Cursor
' Importante:
'               Si esta funci�n devuelve TRUE se DEBE cerrar el
'               cursor phCursor% con DBCursorTerminar()
' Autor:        Tecnog�nesis - MTB,CRM
' Fecha:        24-11-98
Function DBCursorIniciar%(phCursor%, pQuery$, Optional phDB% = DBDEFAULT)
'
'USO:
'   phCursor%  (OUT)    Cursor que fu� abierto, � 0 si no se pudo
'   pQuery$    (IN)     Instrucci�n SQL o SP que genera el cursor
'   phDB%      (IN)     Handle de la base de datos
'SALIDA:
'   True                Si se pudo abrir el cursor
'
'EJEMPLO:
'   if DBCursorIniciar%(lCursor%, "Select NomEdo from Estados", lhDB%)
'       While DBCursorSiguiente(lCursor%)   ' Traer cada uno de los registros
'           ' Procesar con DBCursorDato()
'       Wend
'       DBCursorTerminar lCursor%    ' Cerrar siempre que DBCursorIniciar = True
'   else
'       FNErrorBox "No se pudo consultar el cat�logo de Estados"
'   endif
'
 Dim lOK As Boolean, i%
 Dim lErrDB As ADODB.Error

    ' INICIAR
    On Error GoTo DBCursorIniciar_ERR:
    lOK = True

    'Toma la base de datos por default
    If phDB% = DBDEFAULT Then phDB% = MhConnDef

    ' 1. Buscar un lugar para el cursor
        phCursor% = 0
        ' 1.1. �Hay alguno vac�o?
        If MnRSMax% > MnRSUsd% Then
            ' SI => Buscarlo
            i% = 0
            On Error Resume Next
            While ((i% + 1) <= MnRSMax%) And (phCursor% = 0)
                i% = i% + 1
                If Not MhRSUsed%(i%) Then   '*** Modificaci�n MTB
                   phCursor% = i%
                End If
            Wend
            On Error GoTo DBCursorIniciar_ERR:
        End If

        ' 1.2. �No Hubo vac�os?
        If (phCursor% = 0) Then
            ' No=> Generar mas espacio
            ReDim Preserve MhRS(1 To DB_BLOCK_DS + MnRSMax%)
            ReDim Preserve MhRSUsed(1 To DB_BLOCK_DS + MnRSMax%)
            ReDim Preserve MnPos(1 To DB_BLOCK_DS + MnRSMax%)
            MnRSUsd% = MnRSMax%
            phCursor% = MnRSMax% + 1
            MnRSMax% = DB_BLOCK_DS + MnRSMax%
            For i% = phCursor% To MnRSMax: MhRSUsed(i%) = False: Next
        End If

        ' 1.3. Reajustar variables
        MnRSUsd% = MnRSUsd% + 1

    ' 2. Intentar abrir el cursor
        ' 2.1. Crear dynaset
        Set MhRS(phCursor%) = New ADODB.Recordset
        MhRS(phCursor%).Open pQuery$, MhConn(phDB%), adOpenStatic
        MhRSUsed(phCursor%) = True
        
        ' 2.2. Intentar moverse (Puede estar vac�o)
        On Error Resume Next
        MhRS(phCursor%).MoveFirst
        MhRS(phCursor%).MovePrevious
        MnPos(phCursor%) = -1

    ' TERMINAR
DBCursorIniciar_END:
    DBCursorIniciar = lOK
    Exit Function

    ' ERROR
DBCursorIniciar_ERR:
   MsMsj = "Ocurri� un error al intentar ejecutar una instrucci�n de SQL: "
   MsMsj = MsMsj & vbCrLf & "La instrucci�n de SQL fu� :"
   MsMsj = MsMsj & vbCrLf & "[ " & pQuery$ & " ]" & vbCrLf
    
   For Each lErrDB In MhConn(phDB%).Errors
      MsMsj = MsMsj & "Descrip: " & lErrDB.Description & vbCrLf
      MsMsj = MsMsj & "N�mero: " & lErrDB.Number & " (" & Hex$(lErrDB.Number) & ")" & vbCrLf
      MsMsj = MsMsj & "ProvidErr: " & lErrDB.SQLState & vbCrLf
   Next
   DBReportaError MsMsj
   lOK = False
   DBCursorTerminar phCursor%
   Resume DBCursorIniciar_END
End Function

' Objetivo:     Posicionarse en el sig. registro, error si no pudo
'               Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar
' Autor:        Tecnog�nesis - JVO
' Fecha:        03-04-96
Function DBCursorSiguiente%(phCursor%)
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'SALIDA:
'   True                Si se pudo avanzar el cursor
'
'EJEMPLO:
'   While DBCursorSiguiente(lCursor%)   ' Traer cada uno de los registros
'       ' Procesar con DBCursorDato()
'   Wend
'
Dim lOK As Integer

   ' INICIAR
   On Error GoTo ErrSiguiente
   lOK = True

   '*** Modificaci�n MTB ***
   'MTB: Evita que se salte el primer rengl�n en un recordset tipo Forward-Only
   If (MhRS(phCursor%).CursorType = adOpenForwardOnly) And _
      (MnPos(phCursor%) = -1) Then
      'No hace Nada, ya est� en el primer rengl�n
   Else
      'Avanza
      MhRS(phCursor%).MoveNext
   End If

   'Validar que no sea fin de datos
   lOK = Not MhRS(phCursor%).EOF
   MnPos(phCursor%) = MnPos(phCursor%) + 1
    
Salida:
   ' TERMINAR
   DBCursorSiguiente = lOK
   Exit Function

ErrSiguiente:
   lOK = False
   Resume Salida

End Function

' Objetivo:     Cerrar el cursor que haya sido abierto con DBCursorIniciar
'               Se debe llamar esta
' Autor:        Tecnog�nesis - JVO
' Fecha:        03-04-96
Sub DBCursorTerminar(phCursor%)
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'SALIDA:
'   No hay
'
'EJEMPLO:
'   if DBCursorIniciar%(lCursor%, "Select NomEdo from Estados")
'       ' Procesar Datos
'       DBCursorTerminar lCursor%    ' Cerrar siempre que DBCursorIniciar = True
'   else
'       FNErrorBox "No se pudo consultar el cat�logo de Estados"
'   endif
'

    ' INICIAR
    On Error Resume Next

    ' 1. Intentar cerrar el cursor
    MhRS(phCursor%).Close

    ' 2. Ajustar variables
    Set MhRS(phCursor%) = Nothing
    MhRSUsed(phCursor%) = False
    MnRSUsd% = MnRSUsd% - 1
    phCursor% = 0

End Sub

' Objetivo:     Fija la base de datos por default
'               Esta base de datos es la utilizada en el par�metro
'               opcional phDB: DBCursorIniciar(), DBComboLLenar(), etc.
'
' Autor:        Tecnog�nesis - MTB
' Fecha:        24-11-98
Sub DBSetAsDefault(phDB%)
'
'USO:
'   phDB%      (IN)     Handle de la base de datos a fijar por default
'SALIDA:
'   No hay
'
   MhConnDef = phDB%
End Sub

' Objetivo:     Llenar un combo (o lista) con los resultados de un query.
'               La primer columna del query debe ser la clave y la
'               segunda la descripci�n
'
' Autor:        Tecnog�nesis - JVO
' Fecha:        03-04-96
' Modif:        JVO - 06/Dic/96     Devolver false si falla el cursor
Function DBComboLlenar(phCombo As Control, pQuery$, Optional phDB% = DBDEFAULT) As Boolean
'
'USO:
'   phCombo    (IN)     Combo Por llenar
'   pQuery$    (IN)     Query con los datos: 1er col. es la clave, 2da col es la Descripci�n
'   phDB%      (IN)     Handle de la base de datos
'SALIDA:
'   True                Se llen� correctamente el combo
'
'EJEMPLO:
'   lOK% = DBComboLlenar%(frmDatos.cmbEdos, "Select NumEdo, Nombre From Estados")
'
Dim lOK As Boolean, lhCur%

    ' INICIAR
    On Error GoTo DBComboLlenar_ERR:
    lOK = True

    'Toma la base de datos por default
    If phDB% = DBDEFAULT Then phDB% = MhConnDef

    ' 1. Limpiar el control
    phCombo.Clear

    ' 2. Abrir el Cursor con los datos
    If DBCursorIniciar(lhCur%, pQuery$, phDB%) Then
        ' 2.1. Barrer los datos
        While DBCursorSiguiente(lhCur%)
            ' Agregar dato
            phCombo.AddItem DBLlaveArmar$(DBCursorDato(lhCur%, 0), DBCursorDato(lhCur%, 1))
        Wend
        ' 2.2. Cerrar el query
        DBCursorTerminar lhCur%
    Else
        ' 2.3 Debe regresar false
        lOK = False
    End If

    ' TERMINAR
DBComboLlenar_END:
    DBComboLlenar = lOK
    Exit Function

    ' ERROR
DBComboLlenar_ERR:
    MsMsj = "Ocurri� un error al intentar llenar un combo: "
    MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]"
    DBReportaError MsMsj
    lOK = False
    Resume DBComboLlenar_END

End Function

' Objetivo:     Regresa la clave seleccionada en un combo
' Autor:        Tecnog�nesis - JVO
' Fecha:        10-04-96
Function DBComboSeleccion$(phCombo As Control)
'
'USO:
'   phCombo    (IN)     Combo con la selecci�n
'SALIDA:
'   String              Clave seleccionada. "" si no hay elemento seleccionado
'
'EJEMPLO:
'   lCve$ = DBComboSeleccion$(frmDatos.cmbEdos)
'
Dim LsClave$, LsDescr$

    ' �Hay algo seleccionado?
    If phCombo.ListIndex = -1 Then
        ' NO
        LsClave$ = ""
    Else
        ' SI => Desarmar la llave seleccionada
        DBLlaveDesarmar (phCombo.Text), LsClave$, LsDescr$
    End If

    ' TERMINAR
    DBComboSeleccion$ = LsClave$

End Function

' Objetivo:     Regresa el nombre seleccionado en un combo
' Autor:        Tecnog�nesis - JVO, MTB
' Fecha:        10-04-96
Function DBComboSeleccionN$(phCombo As Control)
'
'USO:
'   phCombo    (IN)     Combo con la selecci�n
'SALIDA:
'   String              Clave seleccionada. "" si no hay elemento seleccionado
'
'EJEMPLO:
'   lCve$ = DBComboSeleccion$(frmDatos.cmbEdos)
'
Dim LsClave$, LsDescr$

    ' �Hay algo seleccionado?
    If phCombo.ListIndex = -1 Then
        ' NO
        LsDescr$ = ""
    Else
        ' SI => Desarmar la llave seleccionada
        DBLlaveDesarmar (phCombo.Text), LsClave$, LsDescr$
    End If

    ' TERMINAR
    DBComboSeleccionN$ = LsDescr$

End Function

' Objetivo:     Seleccionar una clave o descripci�n en un combo
' Autor:        Tecnog�nesis - JVO
' Fecha:        10-04-96
Sub DBComboSeleccionar(phCombo As Control, PsClave$, PsDescr$)
'
'USO:
'   phCombo    (IN)     Combo con la selecci�n
'   psClave$   (IN)     Clave por buscar. (Puede ser vac�o si se env�a psDescr$)
'   psDescr$   (IN)     Descripci�n por buscar. (Puede ser vac�o si se env�a psClave$)
'SALIDA:
'   No hay              Si encuentra un elemento en el combo que conincida en
'                       la clave o descripcion, se selecciona.
'
'EJEMPLO:
'   DBComboSeleccionar frmDatos.cmbEdos, "", "Hidalgo"
'
Dim LsClave$, LsDescr$, i%

    ' 1. Deseleccionar
    phCombo.ListIndex = -1
    
    ' 2. �Nos env�an datos?
    If PsClave$ <> "" Or PsDescr$ <> "" Then
        ' SI => Buscarlo
        For i% = 0 To phCombo.ListCount - 1

            ' 3. Obtener datos del combo
            DBLlaveDesarmar (phCombo.List(i%)), LsClave$, LsDescr$
            If LsClave$ = PsClave$ Or LsDescr$ = PsDescr$ Then
                ' Ya lo encontramos
                phCombo.ListIndex = i%
                Exit For
            End If
        Next
    End If

End Sub

' Objetivo:     Obtiene n�mero de columnas del cursor.
'               Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar
' Autor:        Tecnog�nesis - JVO
' Fecha:        03-04-96
Function DBCursorCols%(phCursor%)
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'SALIDA:
'   Integer             N�mero de columnas que puede devolver el cursor
'
'EJEMPLO:
'   lNumCols% = DBCursorCols%(lCursor%)
'
    DBCursorCols% = MhRS(phCursor).Fields.Count
End Function

' Objetivo:     Obtiene n�mero de registros del cursor.
'               Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar
' Autor:        Tecnog�nesis - JVO
' Fecha:        03-04-96
Function DBCursorCuenta&(phCursor%)
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'SALIDA:
'   Integer             N�mero de registros que tiene el cursor.
'
'EJEMPLO:
'   lNumCols% = DBCursorCols%(lCursor%)
'
'IMPORTANTE:
'   Esta rutina se mueve al �ltimo registro para poder determinar
'   cu�ntos registros hay, por lo que puede ser muy lenta si el
'   cursor tiene muchos datos.
'
Dim LnMark As Variant

    On Error Resume Next
    LnMark = MhRS(phCursor).Bookmark
    MhRS(phCursor).MoveLast
    DBCursorCuenta& = MhRS(phCursor).RecordCount
    If IsEmpty(LnMark) Then
        ' Lo ponemos al principio
        MhRS(phCursor).MoveFirst
        MhRS(phCursor).MovePrevious
    Else
        ' Hay cursor
        MhRS(phCursor).Bookmark = LnMark
    End If
End Function

' Objetivo:     Obtiene un dato de un cursor
'               Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar y que haya sido movido a un
'               registro v�lido con DBCursorSiguiente o DBCursorGoto
' Autor:        Tecnog�nesis - JVO
' Fecha:        03-04-96
Function DBCursorDato(phCursor%, PColumna As Variant) As Variant
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'   PColumna   (IN)     Columna de la cual se desea conocer su valor,
'                       puede ser el n�mero de columna (de 0 a Columnas -1)
'                       o puede ser el nombre de la columna
'SALIDA:
'   Variant             Valor de la columna en el registro actual
'
'EJEMPLO:
'   lClave = DBCursorDato(lCursor%, 0)
'   lNombre = DBCursorDato(lCursor%, "NomEdo")
'
Dim lDato As Variant
Dim LEmpty As Variant

    ' INICIAR
    On Error GoTo DBCursorDato_ERR:
    lDato = MhRS(phCursor).Fields(PColumna).Value      ' & "" :MTB le quit� esto para que devuelva variants
    'Convierte los nulos en cadena vac�a
    lDato = IIf(IsNull(lDato), "", lDato)

    ' TERMINAR
DBCursorDato_END:
    DBCursorDato = lDato
    Exit Function

    ' ERROR
DBCursorDato_ERR:
    lDato = LEmpty
    Resume DBCursorDato_END:
End Function

' Objetivo:     Posicionar el cursor en cierto registro.
' Nota:         Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar
' Nota:         Si se usa TrueGrid se debe responder al evento
'               Fetch con esta funci�n o con DBTrueGridFetch.
' Nota:         Los registros est�n numerados con base en cero
'               (0=1er.Reg, 1=2o.Reg, ...)
' Autor:        Tecnog�nesis - Miguel Torres (MTB)
' Fecha:        30-10-96
Function DBCursorGoto%(phCursor%, pRecNo&)
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'   pRecNo&    (IN)     N�mero de registro al que se debe mover
'SALIDA:
'   True                Si se pudo colocar en ese registro.
'
'EJEMPLO:
'   lOK% = DBCursorGoto%(lCursor%, 86)
'
Dim LnMark As Variant
Dim lOK%
Dim i%

    ' INICIAR
    On Error GoTo DBCursorGoto_ERR:
    lOK% = True
       
    ' 1. Determinar posici�n en la que estamos
    If MnPos(phCursor%) > pRecNo& Then

        ' 1.1 Nos debemos regresar
        While MnPos(phCursor%) > pRecNo&
            ' Regresar un registro
            MhRS(phCursor).MovePrevious
            MnPos(phCursor%) = MnPos(phCursor%) - 1
        Wend
        lOK% = Not MhRS(phCursor%).BOF

    ElseIf MnPos(phCursor%) < pRecNo& Then

        ' 1.2 Debemos Avanzar
        While MnPos(phCursor%) < pRecNo&
            ' Avanzar un registro
            MhRS(phCursor).MoveNext
            MnPos(phCursor%) = MnPos(phCursor%) + 1
        Wend
        lOK% = Not MhRS(phCursor%).EOF
    End If

    ' TERMINAR
DBCursorGoto_FIN:
    DBCursorGoto = lOK%
    Exit Function

    ' ERROR
DBCursorGoto_ERR:
    lOK% = False
    Resume DBCursorGoto_FIN:

End Function


' Objetivo:     Ejecutar un query en la base de datos
' Autor:        Tecnog�nesis - JVO
' Fecha:        03-04-96
Function DBEjecutar(pQuery$, Optional phDB% = DBDEFAULT) As Boolean
'
'USO:
'   pQuery$    (IN)     Query que se desea ejecutar
'   phDB%      (IN)     Handle de la base de datos
'SALIDA:
'   True                Si se pudo ejecutar
'
'EJEMPLO:
'   lOK% = DBEjecutar%("exec SP_EjecutaProceso")
'
 Dim lOK As Boolean
 Dim lErrDB As ADODB.Error

   'INICIAR
   On Error GoTo DBEjecutar_ERR:
   lOK = True
   
   'Toma la base de datos por default
   If phDB% = DBDEFAULT Then phDB% = MhConnDef
   
   'Intenta ejecutar el query
   MhConn(phDB%).Execute pQuery$, , adCmdText + adExecuteNoRecords

   'TERMINAR
DBEjecutar_END:
   DBEjecutar = lOK
   Exit Function

   'ERROR
DBEjecutar_ERR:
   
   MsMsj = "Ocurri� un error al intentar ejecutar una instrucci�n de SQL: " & vbCrLf & _
           pQuery$ & vbCrLf
   For Each lErrDB In MhConn(phDB%).Errors
      MsMsj = MsMsj & "Descrip: " & lErrDB.Description & vbCrLf
      MsMsj = MsMsj & "N�mero: " & lErrDB.Number & " (" & Hex$(lErrDB.Number) & ")" & vbCrLf
      MsMsj = MsMsj & "ProvidErr: " & lErrDB.SQLState & vbCrLf
   Next
   DBReportaError MsMsj
   lOK = False
   
   Resume DBEjecutar_END
End Function

' Objetivo:     Armar un string con una clave y una descripci�n
' Autor:        Tecnog�nesis - JVO
' Fecha:        10-04-96
Function DBLlaveArmar$(PsClave$, PsDescr$)
    DBLlaveArmar$ = PsDescr$ & Space(LLAVE_SEP) & Chr$(124) & PsClave$
End Function

' Objetivo:     Obtiene la clave y la descripci�n de una llave
' Autor:        Tecnog�nesis - JVO
' Fecha:        10-04-96
Sub DBLlaveDesarmar(psLlave$, PsClave$, PsDescr$)
Dim LnStart%, LnPos%
    
    ' 1. Buscar donde empieza la clave
    LnStart% = LLAVE_SEP   ' Se agregan espacios al armar antes de chr$(124)
    While LnStart% > 0
        LnPos% = LnStart%
        LnStart% = InStr(LnStart% + 1, psLlave$, Chr$(124))
    Wend

    ' 2. Regresar los valores
    PsClave$ = Trim$(Mid$(psLlave$, LnPos% + 1))
    PsDescr$ = Trim$(Left$(psLlave$, LnPos% - 1))

End Sub

'Establece la hora de la PC igual a la del Servidor
Function DBSincronizaReloj(Optional phDB% = DBDEFAULT) As Boolean
 Dim lQry$, lhCur%, lOK As Boolean
 
   'Inicia
   lOK = False
   
   'Toma base de datos por default
   If phDB% = DBDEFAULT Then phDB% = MhConnDef

   'Pide Hora a Sybase
   lQry$ = "Select 'fecha'=convert(char(10),getdate(),105)," & _
               " 'hora'=convert(char(10),getdate(),8)"
               
   If DBCursorIniciar(lhCur%, lQry, phDB%) Then
      If DBCursorSiguiente(lhCur%) Then
         Date = FNValidaFecha(DBCursorDato(lhCur%, 0), "dd-mm-yyyy")
         Time = DBCursorDato(lhCur%, 1)
         lOK = True
      End If
      DBCursorTerminar lhCur%
   End If
   
   'Termina
   DBSincronizaReloj = lOK
End Function


' Objetivo:      Llenar un ListView con los resultados de un query.
'                La primer columna del query debe ser la clave y la
'                segunda la descripci�n, la 3a el �ndice del icono,
'                el resto los detalles
'
' Observaciones: El ListView a llenar, debe de teener el numero correcto de columnas
'                antes de llamar a �sta funci�n
'
' Autor:        Tecnog�nesis - MTB
' Fecha:        07-06-99
Function DBListViewLlenar%(phList As ListView, pQuery$, Optional phDB% = DBDEFAULT)
'
'USO:
'   phList     (IN)     ListView Por llenar
'   pQuery$    (IN)     Query con los datos: 1er col. es la clave, 2da col es la Descripci�n
'   phDB%      (IN)     Handle de la base de datos
'SALIDA:
'   True                Se llen� correctamente el combo
'
'EJEMPLO:
'   'El control lvwEdos debe tener dos columnas: Nombre y poblaci�n (Forzosamente)
'   lOK% = DBListViewLlenar%(frmDatos.lvwEdos, "Select NumEdo, Nombre, 'Icono'=1, Poblacion From Estados")
'
 Dim lOK As Integer, lhCur%, lItem As ListItem
 Dim lCols%, i%

    ' INICIAR
    On Error GoTo DBListViewLlenar_ERR:
    lOK = True

    'Toma la base de datos por default
    If phDB% = DBDEFAULT Then phDB% = MhConnDef

    ' 1. Limpiar el control
    phList.ListItems.Clear

    ' 2. Abrir el Cursor con los datos
    If DBCursorIniciar(lhCur%, pQuery$, phDB%) Then
        'Obtiene el n�mero de columnas-detalle
        lCols% = DBCursorCols(lhCur%) - 3
        ' 2.1. Barrer los datos
        While DBCursorSiguiente(lhCur%)
            ' Agregar dato
            Set lItem = phList.ListItems.Add()
            lItem.Key = DBCursorDato(lhCur%, 0)
            lItem.Text = DBCursorDato(lhCur%, 1)
            lItem.Icon = DBCursorDato(lhCur%, 2)
            lItem.SmallIcon = DBCursorDato(lhCur%, 2)
            'Detalles
            For i% = 1 To lCols%
               lItem.SubItems(i%) = DBCursorDato(lhCur%, (2 + i%))
            Next
        Wend
        ' 2.2. Cerrar el query
        DBCursorTerminar lhCur%
    Else
        ' 2.3 Debe regresar false
        lOK = False
    End If

    ' TERMINAR
DBListViewLlenar_END:
    DBListViewLlenar = lOK
    Exit Function

    ' ERROR
DBListViewLlenar_ERR:
    MsMsj = "Ocurri� un error al intentar llenar un listview: "
    MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]"
    DBReportaError MsMsj
    lOK = False
    Resume DBListViewLlenar_END

End Function

'Ejecuta un query, en la base de datos deseada, que devuelve un rengl�n
'y una columna. (un solo dato)
'PAR�METROS:
'   pQry$      (IN)     Instrucci�n SQL o SP que genera el cursor
'   pOK%       (OUT)    True=OK, False=Hubo error
'   phDB%      (IN)     Handle de la base de datos (por omisi�n la de default)
'SALIDA:
'   Dato                Resultado del query

Function DBQueryDato(pQry$, Optional ByRef pOk As Boolean, Optional phDB% = DBDEFAULT) As Variant
 Dim lhCur%, lDato As Variant, lOK As Boolean
 
   'Inicia
   lOK = True
   If DBCursorIniciar(lhCur%, pQry$, phDB%) Then
      If DBCursorSiguiente(lhCur%) Then
         lDato = DBCursorDato(lhCur%, 0)
      Else
         lOK = False
      End If
      DBCursorTerminar lhCur%
   Else
      lOK = False
   End If
   
   'Regresa
   pOk = lOK
   DBQueryDato = lDato
End Function


'Ejecuta un query, en la base de datos deseada, que devuelve un rengl�n
'y Varias columnas (varios datos de un solo registro)
'PAR�METROS:
'   pQry$      (IN)     Instrucci�n SQL o SP que genera el cursor
'   phDB%      (IN)     Handle de la base de datos
'SALIDA:
'                       True=OK, False= Hubo error

Function DBQueryDatos(pQry$, phDB%, ParamArray pVar()) As Boolean
 Dim lhCur%, lDato As Variant, lOK As Boolean, i%, j%
 
   'Inicia
   lOK = True
   If DBCursorIniciar(lhCur%, pQry$, phDB%) Then
      If DBCursorSiguiente(lhCur%) Then
         'Asigna cada dato a la lista de variables
         i% = 0
         For j% = LBound(pVar) To UBound(pVar)
            On Error GoTo Err_Datos
            pVar(j%) = DBCursorDato(lhCur%, i%)
            On Error GoTo 0
            i% = i% + 1
         Next
      Else
         lOK = False
      End If
      DBCursorTerminar lhCur%
   Else
      lOK = False
   End If
   
   'Regresa
Salida:
   DBQueryDatos = lOK
   Exit Function
   
Err_Datos:
   lOK = False
   Resume Salida
End Function



'Inicia una transacci�n, ya sea en el espacio Jet (default)
' o en el espacio ODBC
Sub DBBeginTran(Optional pWrkODBC As Boolean = False)
 
   MsgBox "Falta traducir a ADO"
    
'   'Inicia
'   On Error GoTo Err_Begin
'
'   'Inicia la transacci�n
'   If pWrkODBC Then
'      mWrkODBC.BeginTrans
'   Else
'      mWrkJet.BeginTrans
'   End If
'
'Salida:
'   Exit Sub
'
'Err_Begin:
'   MsMsj = "Ocurri� un error al iniciar una transacci�n: "
'   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
'   DBReportaError MsMsj
'   Resume Salida
End Sub

'Termina una transacci�n, ya sea en el espacio Jet (default)
' o en el espacio ODBC
Sub DBCommitTran(Optional pWrkODBC As Boolean = False)
 
   MsgBox "Falta traducir a ADO"

'   'Inicia
'   On Error GoTo Err_Commit
'
'   'Termina la transacci�n
'   If pWrkODBC Then
'      mWrkODBC.CommitTrans
'   Else
'      mWrkJet.CommitTrans dbForceOSFlush
'   End If
'
'Salida:
'   Exit Sub
'
'Err_Commit:
'   MsMsj = "Ocurri� un error al terminar una transacci�n: "
'   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
'   DBReportaError MsMsj
'   Resume Salida
End Sub

'Revierte una transacci�n, ya sea en el espacio Jet (default)
' o en el espacio ODBC
Sub DBRollBack(Optional pWrkODBC As Boolean = False)

   MsgBox "Falta traducir a ADO"
   
'   'Inicia
'   On Error GoTo Err_RollBack
'
'   'Termina la transacci�n
'   If pWrkODBC Then
'      mWrkODBC.Rollback
'   Else
'      mWrkJet.Rollback
'   End If
'
'Salida:
'   Exit Sub
'
'Err_RollBack:
'   MsMsj = "Ocurri� un error al revertir una transacci�n: "
'   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
'   DBReportaError MsMsj
'   Resume Salida
End Sub

'Liga una tabla externa a una base jet abierta
Function DBLigaTablaExt(phDB%, psTableName1$, psDSN$, psTableName2$, Optional psUsr$, Optional psPwd$, Optional pODBC As Boolean = False) As Boolean
'
'USO:
'   phDB%         (IN)   Handle de la base de datos a la que se va a anexar la tabla
'   psTableName1$ (IN)   Nombre que tendr� la tabla ligada (dentro de phDB%)
'   psDSN$        (IN)   ODBC: Data Source Name, como aparece en ODBC en Control Panel
'                        Jet: Nombre de la base de datos con ruta
'   psTableName2$ (IN)   Nombre original de la tabla en la base de datos externa
'   psUsr$        (IN)   ODBC: Usuario, para firmarse en la base de datos
'                        Jet: Tipo de la base de datos externa (ejemplo: "DBase IV" , "Excel 5.0" , etc.)
'   psPwd$        (IN)   S�lo ODBC: Password,  para firmarse en la base de datos
'   pODBC         (IN)   Tipo de conexi�n para la tabla externa. TRUE: ODBC, FALSE: Jet
'SALIDA:
'   True                Si se pudo conectar a la base de datos
'
 
 
   MsgBox "Falta traducir a ADO"
 
'
' Dim lTabla As TableDef, lOK As Boolean, lConn$, lOpt As Long
'
'   'Inicia
'   On Error GoTo Err_Liga
'   lOK = True
'
'   'Toma la base de datos por default
'   If phDB% = DBDEFAULT Then phDB% = MhConnDef
'
'   'Crea un Tabledef para la tabla externa
'   Set lTabla = MhConn(phDB%).CreateTableDef(psTableName1$)
'
'   'Fija los par�metros de conexi�n al TableDef
'   If pODBC Then
'      lConn$ = "ODBC;DSN=" & psDSN$ & "" & _
'                 ";UID=" & psUsr$ & _
'                 ";PWD=" & psPwd$
'      lOpt = dbAttachedODBC
'   Else
'      lConn$ = IIf(psUsr$ = "", ";DATABASE=", psUsr$ & ";")
'      lConn$ = lConn$ & psDSN$
'      lOpt = dbAttachedTable
'   End If
'
'   'Fija los par�metros
'   lTabla.Connect = lConn$
'   'lTabla.Attributes = lOpt   'Quien sabe por que truena aqu� (MTB)
'   lTabla.SourceTableName = psTableName2$
'
'   'A�ade el TableDef a la base de datos
'   MhConn(phDB%).TableDefs.Append lTabla
'
'Salida:
'   DBLigaTablaExt = lOK
'   Exit Function
'
'Err_Liga:
'   'El Objeto ya existe?
'   If Err = 3012 Then
'      'Es una tabla ligada?
'      If MhConn(phDB%).TableDefs(psTableName1$).Attributes And lOpt Then
'         'No hay problema, usa esa tabla
'         lOK = True
'         Resume Salida
'      End If
'   End If
'   lOK = False
'   MsMsj = "Ocurri� un error al intentar ligar la tabla externa:"
'   MsMsj = MsMsj & Chr$(10) & "Conn= " & lConn$ & Chr$(10)
'   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
'   DBReportaError MsMsj
'   Resume Salida
'
End Function

'Quita la liga a la tabla externa
Sub DBDesLigaTablaExt(psTableName1$, Optional phDB% = DBDEFAULT)
 
   MsgBox "Falta traducir a ADO"
 
' Dim lOK As Boolean
'
'   'Toma la base de datos por default
'   If phDB% = DBDEFAULT Then phDB% = MhConnDef
'
'   On Error GoTo Err_Desliga
'   'Borra la Tabla Ligada
'   MhConn(phDB%).TableDefs.Delete psTableName1$
'
'Salida:
'   Exit Sub
'
'Err_Desliga:
'   lOK = False
'   MsMsj = "Ocurri� un error al intentar desligar una tabla externa:"
'   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
'   DBReportaError MsMsj
'   Resume Salida
'
End Sub

'Reporta Errores al usuario o a un archivo LOG
Sub DBReportaError(pMsg$)
 Dim fp As Integer
 Dim lFileName$, lCad$
 
   'Modo Atendido -> MessageBox
   If Not mUnattended Then
      FNErrorBox pMsg$
      Exit Sub
   End If
   
   'Modo Sin Atenci�n
   
   'Crea el Archivo log
   lFileName$ = mLogFile & Format(Date, "YYYYMMDD") & ".Log"
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
   
Salida:
   Exit Sub
   
FileError:
   FNExclamBox "No se pudo generar el archivo " & lFileName$ & vbCr & _
                Err.Description & vbCr & _
                "El Error a reportar fu�:" & vbCr & pMsg$
   Resume Salida
End Sub
