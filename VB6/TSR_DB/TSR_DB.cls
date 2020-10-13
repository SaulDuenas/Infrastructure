VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DBmain"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
' TSR_DB - Teseracto (c) 2002
'         Ing. Miguel A. Torres-Orozco Bermeo.
' Funciones de Base de Datos y Cursores para ADO
'
'Historia de versiones:
' 1.2.2 Se Agrega la función DBEjecutarSP con soporte a parámetros de salida.
'       Ya no está compilado como "Ejecución Desatendida y Retenido en memoria" ya que
'       no se notó ningún beneficio
' 1.2.1 No se hizo nada mas que subir el número para coincidir con TSR_FN
' 1.2.0 Se agregó soporte a Chunks y se compila como "Ejecución Desatendida y Retenido en memoria"
'       para evitar errores de COM+
'
'       Como ha habido muchos problemas de compatibilidad de versiones, se decide iniciar
'       una nueva versión que rompe compatibilidades con las anteriores.
'       Solo habrá nuevas versiones cuando se distribuyan a clientes.
'       La compatibilidad Binaria se mantendrá a este release hasta que haya uno nuevo
'       (Compilar a TSR_DB.dll manteniendo compatibilidad binaria con TSR_DB_Ver120.dll)
'
' 1.0.1 Segunda version distribuida en IMSA
'
' 1.0.0 Primera version de TSR_DB como DLL
'
'
Option Explicit

'---------------------------------------------------------------------------
' VARIABLES DE MÓDULO
'---------------------------------------------------------------------------

Private MhRS() As Recordset                 ' Cursores
Private MhRSUsed%()                         ' Banderas de uso de cursor *** MTB ***
Private MnPos() As Long                     ' Posición del cursor
Private MnRSMax%, MnRSUsd%                  ' Contadores de los cursores
Private MsMsj As String                     ' Para los mensajes de Error

Private MhConnDef As ADODB.Connection       ' Manejador de la base de datos 'default'
Private MhRSDef As ADODB.Recordset          ' Cursor o recordset 'default'
Private mLogErrors As Boolean               'Indica si los errores de dirigen a un archivo LOG
Private mLogFile As String


'---------------------------------------------------------------------------
' CONSTANTES
'---------------------------------------------------------------------------
Private Const DB_BLOCK_DS = 3
Private Const LLAVE_SEP = 130           'Espacios de las Llaves


'Inicialización de la clase
Private Sub Class_Initialize()
   'Inicializa la base de datos
   Call DBIniciar
   
   'Los errores se muestran por default en pantalla
   mLogErrors = False
   mLogFile = ""
End Sub

'Terminar la clase
Private Sub Class_Terminate()
   If Not (MhConnDef Is Nothing) Then
      DBDesconectar
   End If
End Sub

'Indica si la aplicacion registra los errores en archivo
Public Property Get DBLogErrors() As Boolean
Attribute DBLogErrors.VB_Description = "Indica si los mensajes de error deben dirigirse a un archivo Log (para operación desatendida)\r\nFalse=a pantalla (default), True=a archivo LOG especificado por DBLogFile"
   DBLogErrors = mLogErrors
End Property
Public Property Let DBLogErrors(pLog As Boolean)
   'Desean Log en archivo?
   If pLog Then
      'Si, Ya se estableció el archivo?
      If mLogFile <> "" Then
         'OK
         mLogErrors = True
      Else
         MsgBox "Primero debe de establecer la propiedad DBLogFile " & _
                "con un nombre de archivo con ruta (prefijo)", vbExclamation + vbOKOnly, _
                "Error en TSR_DB"
      End If
   Else
      'No, Se desactiva
      mLogErrors = False
   End If
End Property

Public Property Let DBLogFile(Prefijo As String)
Attribute DBLogFile.VB_Description = "Prefijo para el nombre de archivo LOG (Ruta y Nombre) Se concatena YYYYMMDD.LOG.\r\nSolo aplica si DBLogErrors=True.\r\nSi se establece a ""NULL"" no se reporta nada (Cuidado!)\r\n"
   
   'Acepta el parámetro
   mLogFile = Prefijo
   
   'Es Cadena vacía?
   If mLogFile = "" Then
      'Desactiva Registro de Errores en archivo
      mLogErrors = False
   End If
End Property
'Indica La ruta y prefijo de los archivos .Log
Public Property Get DBLogFile() As String
   DBLogFile = mLogFile
End Property


'---------------------------------------------------------------------------
' Objetivo:     Inicializar variables asociadas al manejo de bases de datos
'               antes de usar cualquier función DB
' Autor:        Teseracto - MTB,CRM
' Fecha:        2-Jul-2002
Private Sub DBIniciar()
 Dim i%
 
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
   Set MhConnDef = Nothing
End Sub


'---------------------------------------------------------------------------
' Objetivo:     Conectarse a una base de datos
' Importante:   Si esta función devuelve TRUE se DEBE cerrar la
'               base de datos con DBDesconectar()
' Autor:        Teseracto - MTB,CRM
' Fecha:        11-Oct-2001
Function DBConectar(Optional pDSN$, Optional pUsr$, Optional pPwd$, Optional pConnStr$ = "", _
                    Optional pConnection As ADODB.Connection) As Boolean
Attribute DBConectar.VB_Description = "Se conecta a una base de datos. Usar los paráms pDSN, pUsr y pPwd para usar un DSN de ODBC, o bien, usar un ConnectionString completo (con usr y pwd) en el parám pConnStr. Regresa un objeto Connection en el parám pConnection. Regresa False si hubo error"
'USO:
'   pDSN$      (IN)    Data Source Name, como aparece en ODBC en Control Panel
'   pUsr$      (IN)    Usuario, para firmarse en la base de datos
'   pPwd$      (IN)    Password,  para firmarse en la base de datos
'  pConnStr$   (IN)    Si es vacío, se ignora, de lo contrario
'                      se utiliza como ConnectionString, ignorando el parámetro pDSN$
'  pConnection (OUT)   Objeto Connection Creado, o Nothing si no se pudo abrir
'
'SALIDA:
'   True                Si se pudo conectar a la base de datos
'
'EJEMPLO:
'   DBIniciar
'   if DBConectar("TAE","tae","taebanpais") then
'       ' Procesar Datos
'       DBDesconectar     ' SIEMPRE cerrar la base de datos
'   else
'       FNErrorBox "No se pudo conectar a la base de datos"
'   endif
'
 Dim lOK As Boolean, i%
 Dim lConnStr$
 Dim lhConn As ADODB.Connection
 Dim lErrDB As ADODB.Error

   ' INICIAR
   On Error GoTo DBConectar_ERR:
   lOK = True
      
   'Arma la cadena de conexión
   If pConnStr = "" Then
      lConnStr$ = "DSN=" & pDSN$ & "" & _
               ";UID=" & pUsr$ & _
               ";PWD=" & pPwd$
   Else
      lConnStr$ = pConnStr$
   End If
   
   'Abre la conexión
   Set lhConn = New ADODB.Connection
   lhConn.Open lConnStr$
   
   'La asigna a la conexión default de ser necesario
   If MhConnDef Is Nothing Then Set MhConnDef = lhConn
   
   
   ' TERMINAR
DBConectar_END:
   On Error Resume Next
   If lOK Then
      Set pConnection = lhConn
   Else
      Set pConnection = Nothing
   End If
   
   DBConectar = lOK
   Exit Function
   
   ' ERROR
DBConectar_ERR:
   MsMsj = "Ocurrió un error al intentar abrir la base de datos: " & vbCrLf
   MsMsj = MsMsj & "Descrip: " & Err.Description & vbCrLf
   MsMsj = MsMsj & "Número: " & Err.Number & " (" & Hex$(Err.Number) & ")" & vbCrLf
   DBReportaError MsMsj
   lOK = False
   Resume DBConectar_END:
End Function

'*** Funciones de Conexión a Bases de datos Específicas
'Funcionan de manera idéntica a DBConectar (llaman a DBConectar)

' SQL Server  [OLEDB Provider]
Function DBConectar_SQLServer(pServerName$, pDBName$, pUsr$, pPwd$, Optional pConnection As ADODB.Connection) As Boolean
Attribute DBConectar_SQLServer.VB_Description = "Se conecta a SQLServer por nombre de servidor/instancia. (en una LAN se puede usar dirección IP para pServerName)"
 Dim lConnStr As String
   'Arma Cadena de Conexión
   lConnStr = "Provider=sqloledb;" & _
           "Data Source=" & pServerName$ & ";" & _
       "Initial Catalog=" & pDBName & ";" & _
               "User ID=" & pUsr$ & ";" & _
              "Password=" & pPwd$ & ";"
   
   'Se conecta
   DBConectar_SQLServer = DBConectar(pConnStr:=lConnStr, pConnection:=pConnection)
End Function

' SQL Server remoto vía TCP/IP (lento) [OLEDB Provider]
Function DBConectar_SQLServerIP(pIPAddr$, pDBName$, pUsr$, pPwd$, _
          Optional pPort$ = "1433", Optional pConnection As ADODB.Connection) As Boolean
Attribute DBConectar_SQLServerIP.VB_Description = "Se conecta a una base de datos SQLServer remota usando la Network Library DBMSSOCN (es un poco lenta)"
 Dim lConnStr As String
   'Arma Cadena de Conexión
   lConnStr = "Provider=sqloledb;" & _
       "Network Library=DBMSSOCN;" & _
           "Data Source=" & pIPAddr & "," & pPort & ";" & _
       "Initial Catalog=" & pDBName & ";" & _
               "User ID=" & pUsr$ & ";" & _
              "Password=" & pPwd$ & ";"
   
   'Se conecta
   DBConectar_SQLServerIP = DBConectar(pConnStr:=lConnStr, pConnection:=pConnection)
End Function

' MDB Access  [OLEDB Provider]
Function DBConectar_Access(pFileName$, Optional pUsr$ = "", Optional pPwd$ = "", _
                  Optional pJetVersion$ = "4.0", Optional pConnection As ADODB.Connection) As Boolean
Attribute DBConectar_Access.VB_Description = "Se conecta a una base de datos de Access 98, 2000, XP. Para anteriores, especificar pJetVersion=""3.5"". Devuelve Falso su hubo error."
 Dim lConnStr As String
 
   'Arma Cadena de Conexión
   lConnStr = "Provider=Microsoft.Jet.OLEDB." & pJetVersion & ";" & _
           "Data Source=" & pFileName$ & ";"
   If pUsr$ <> "" Then
      lConnStr = lConnStr & _
               "User ID=" & pUsr$ & ";" & _
              "Password=" & pPwd$ & ";"
   End If
   
   'Se conecta
   DBConectar_Access = DBConectar(pConnStr:=lConnStr, pConnection:=pConnection)
End Function

' Archivos DBF  [ODBC Driver]
' pDirName$ es el folder donde se encuentran los archivos DBF
' Especificar el nombre de archivo en el query:
'   "SELECT * FROM MiTabla.dbf"
'NOTAS:
' Solo soporta nombres de archivo en formato 8.3
' Solo se pueden hacer operaciones de lectura
Function DBConectar_DBF(pDirName$, Optional pConnection As ADODB.Connection) As Boolean
Attribute DBConectar_DBF.VB_Description = "Se conecta a archivos DBF (DBase, Clipper, Fox) que están en el folder especificado por pDirName."
 Dim lConnStr As String
   'Arma Cadena de Conexión
   lConnStr = "Driver={Microsoft dBASE Driver (*.dbf)};" & _
              "DriverID=277;" & _
              "Dbq=" & pDirName$
   
   'Se conecta
   DBConectar_DBF = DBConectar(pConnStr:=lConnStr, pConnection:=pConnection)
End Function


'
'**********
'*** Añadir mas conexiones aquí conforme se vayan necesitando
'**********


' Objetivo:     Desconectarse de la base de datos que haya sido
'               abierta con DBConectar
' Autor:        Teseracto - MTB,CRM
' Fecha:        2-Jul-2002
'
'USO:
'   pConnection  (IN)     Objeto Connection a Cerrar, si no se alimenta nada
'                         se cierra la conexión por default
'SALIDA:
'   No hay
'
'EJEMPLO:
'   DBIniciar
'   if DBConectar("TAE","tae","taebanpais") then
'       ' Procesar Datos
'       DBDesconectar   ' SIEMPRE cerrar la base de datos
'   else
'       FNErrorBox "No se pudo conectar a la base de datos"
'   endif
'
Sub DBDesconectar(Optional pConnection As ADODB.Connection = Nothing)
Attribute DBDesconectar.VB_Description = "Se desconecta de una base de datos. Si se omite pConnection o es nothing entonces cierra la base de datos Default"
 Dim lMsg$
 Dim lErrDB As ADODB.Error
 
   ' INICIAR
   'On Error GoTo DBDesconectar_ERR
   On Error Resume Next
   
   'Cierra la base de datos
   If pConnection Is Nothing Then
      'la DB Default
      MhConnDef.Close
      Set MhConnDef = Nothing
   Else
      If pConnection Is MhConnDef Then
         'la especificada es la default
         MhConnDef.Close
         Set MhConnDef = Nothing
         Set pConnection = Nothing
      Else
        'la especificada
        pConnection.Close
        Set pConnection = Nothing
      End If
   End If
   
   ' TERMINAR
DBDesconectar_END:
    Exit Sub

    ' ERROR
DBDesconectar_ERR:
   lMsg = "Ocurrió un error al intentar cerrar la base de datos: " & vbCrLf
   For Each lErrDB In pConnection.Errors
      lMsg = lMsg & "Descrip: " & lErrDB.Description & vbCrLf
      lMsg = lMsg & "Número: " & lErrDB.Number & " (" & Hex$(lErrDB.Number) & ")" & vbCrLf
      lMsg = lMsg & "ProvidErr: " & lErrDB.SQLState & vbCrLf
   Next
   DBReportaError lMsg
   Resume DBDesconectar_END:
End Sub



' Objetivo:     Fija la base de datos por default
'
' Autor:        Teseracto - MTB
' Fecha:        2-Jul-2002
Public Property Get DefaultDB() As ADODB.Connection
Attribute DefaultDB.VB_Description = "Devuelve/Establece la conexión a la base de datos que se usa por default. Se establece automáticamente a la primera conexión realizada."
   Set DefaultDB = MhConnDef
End Property

Public Property Let DefaultDB(pConnection As ADODB.Connection)
   'Valida que exista
   If Not pConnection Is Nothing Then
      'La asigna
      Set MhConnDef = pConnection
   Else
      DBReportaError "No se puede fijar la base de datos por default a Nothing"
   End If
End Property



' Objetivo:     Fija el recordset por default
'
' Autor:        Teseracto - SDB
' Fecha:        05-Nov-2011
Public Property Get DefaultRS() As ADODB.Recordset
Attribute DefaultRS.VB_Description = "Devuelve/Establece el cursor se usa por default. Se establece automáticamente en cada apertura de un cursor."

   Set DefaultRS = MhRSDef
End Property

Public Property Let DefaultRS(pRS As ADODB.Recordset)
   'Valida que exista
   If Not pRS Is Nothing Then
      'La asigna
      Set MhRSDef = pRS
   Else
      DBReportaError "No se puede fijar el cursor por default a Nothing"
   End If
End Property



' Objetivo:     Probar una conexión
' Autor:        Teseracto - MTB
' Fecha:        8-Nov-2001
' Notas:        Realiza una consulta para verificar si la conexión funciona
'               Esto es útil solo en conexiones RDS en donde DBConectar no regresa errores
Function DBPruebaConexion(Optional pConnection As ADODB.Connection = Nothing) As Boolean
Attribute DBPruebaConexion.VB_Description = "Prueba que la conexion a la BD funcione. Usar especialmente en conexiones remotas."
 Dim lOK As Boolean
 Dim lRst As ADODB.Recordset
 
   'Inicia
   lOK = True
   
   'Toma la base de datos por default
    If pConnection Is Nothing Then Set pConnection = MhConnDef
   
   'Intenta hacer un acceso
   Set lRst = New ADODB.Recordset
   On Error GoTo Err_Test
   lRst.Open "SELECT 1", pConnection, adOpenStatic
   
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
'               Si esta función devuelve TRUE se DEBE cerrar el
'               cursor phCursor% con DBCursorTerminar()
' Autor:        Teseracto - MTB,CRM
' Fecha:        2-Jul-2002
Function DBCursorIniciar(phCursor%, pQuery$, Optional pConnection As ADODB.Connection = Nothing, Optional pOpenStatic As Boolean = True) As Boolean
Attribute DBCursorIniciar.VB_Description = "Abre un cursor o recordset. phCursor regresa el número de cursor, pOpenStatic=True especifica solo lectura. Regresa True si se abrió con éxito. Una vez usado Cerrarlo con DBCursorTerminar."
'
'USO:
'   phCursor%  (OUT)     Cursor que fué abierto, ó 0 si no se pudo
'   pQuery$     (IN)     Instrucción SQL o SP que genera el cursor
'   pConnection (IN)     Conexión a la base de datos
'SALIDA:
'   True                Si se pudo abrir el cursor
'
'EJEMPLO:
'   if DBCursorIniciar(lCursor%, "Select NomEdo from Estados")
'       While DBCursorSiguiente(lCursor%)   ' Traer cada uno de los registros
'           ' Procesar con DBCursorDato()
'       Wend
'       DBCursorTerminar lCursor%    ' Cerrar siempre que DBCursorIniciar = True
'   else
'       FNErrorBox "No se pudo consultar el catálogo de Estados"
'   endif
'
 Dim lOK As Boolean, i%
 Dim lErrDB As ADODB.Error

    ' INICIAR
    On Error GoTo DBCursorIniciar_ERR:
    lOK = True

    'Toma la base de datos por default
    If pConnection Is Nothing Then Set pConnection = MhConnDef

    ' 1. Buscar un lugar para el cursor
        phCursor% = 0
        ' 1.1. ¿Hay alguno vacío?
        If MnRSMax% > MnRSUsd% Then
            ' SI => Buscarlo
            i% = 0
            On Error Resume Next
            While ((i% + 1) <= MnRSMax%) And (phCursor% = 0)
                i% = i% + 1
                If Not MhRSUsed%(i%) Then   '*** Modificación MTB
                   phCursor% = i%
                End If
            Wend
            On Error GoTo DBCursorIniciar_ERR:
        End If

        ' 1.2. ¿No Hubo vacíos?
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
        If pOpenStatic Then
           MhRS(phCursor%).Open pQuery$, pConnection, adOpenStatic
           'SDB RS de Referencia
           Set MhRSDef = MhRS(phCursor%)
        Else
           MhRS(phCursor%).Open pQuery$, pConnection, adOpenKeyset, adLockOptimistic
           'SDB RS de Referencia
           Set MhRSDef = MhRS(phCursor%)
        End If
        
       MhRSUsed(phCursor%) = True
        
        ' 2.2. Intentar moverse (Puede estar vacío)
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
   MsMsj = "Ocurrió un error al intentar ejecutar una instrucción de SQL: "
   MsMsj = MsMsj & vbCrLf & "La instrucción de SQL fué :"
   MsMsj = MsMsj & vbCrLf & "[ " & pQuery$ & " ]" & vbCrLf
    
   If Not (pConnection Is Nothing) Then
      For Each lErrDB In pConnection.Errors
         MsMsj = MsMsj & "Descrip: " & lErrDB.Description & vbCrLf
         MsMsj = MsMsj & "Número: " & lErrDB.Number & " (" & Hex$(lErrDB.Number) & ")" & vbCrLf
         MsMsj = MsMsj & "ProvidErr: " & lErrDB.SQLState & vbCrLf
      Next
   Else
      MsMsj = MsMsj & "Descrip: " & Err.Description & vbCrLf
      MsMsj = MsMsj & "Número: " & Err.Number & " (" & Hex$(Err.Number) & ")" & vbCrLf
      MsMsj = MsMsj & "Source: " & Err.Source & vbCrLf
   End If
   DBReportaError MsMsj
   lOK = False
   DBCursorTerminar phCursor%
   Resume DBCursorIniciar_END
End Function

' Objetivo:     Posicionarse en el sig. registro, error si no pudo
'               Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar
' Autor:        Teseracto - JVO
' Fecha:        03-04-96
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
Function DBCursorSiguiente%(phCursor%)
Attribute DBCursorSiguiente.VB_Description = "Avanza el cursor, regresa True si OK y False si EOF"
 Dim lOK As Integer

   ' INICIAR
   On Error GoTo ErrSiguiente
   lOK = True

   '*** Modificación MTB ***
   'MTB: Evita que se salte el primer renglón en un recordset tipo Forward-Only
   If (MhRS(phCursor%).CursorType = adOpenForwardOnly) And _
      (MnPos(phCursor%) = -1) Then
      'No hace Nada, ya está en el primer renglón
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
'               Se debe llamar esta funcion forzosamente si se abrió el cursor exitosamente
' Autor:        Teseracto - JVO
' Fecha:        03-04-96
Sub DBCursorTerminar(phCursor%)
Attribute DBCursorTerminar.VB_Description = "Cierra un cursor abierto con DBCursorIniciar, Especificar el número de cursor en phCursor"
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'SALIDA:
'   No hay
'
'EJEMPLO:
'   if DBCursorIniciar(lCursor%, "Select NomEdo from Estados") then
'       ' Procesar Datos
'       DBCursorTerminar lCursor%    ' Cerrar siempre que DBCursorIniciar = True
'   else
'       FNErrorBox "No se pudo consultar el catálogo de Estados"
'   endif
'

    ' INICIAR
    On Error Resume Next

    ' 1. Intentar cerrar el cursor
    MhRS(phCursor%).Close

    ' 2. Ajustar variables de uso de cursores
    Set MhRS(phCursor%) = Nothing
    Set MhRSDef = Nothing
    MhRSUsed(phCursor%) = False
    MnRSUsd% = MnRSUsd% - 1
    phCursor% = 0

End Sub

' Objetivo:     Obtiene un dato de un cursor
'               Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar y que haya sido movido a un
'               registro válido con DBCursorSiguiente o DBCursorGoto
' Autor:        Teseracto - JVO
' Fecha:        03-04-96
Function DBCursorDato(phCursor%, PColumna As Variant) As Variant
Attribute DBCursorDato.VB_Description = "Obtiene un dato del cursor (en su posición actual) pColumna puede ser 0 para la 1er columna o el nombre del campo."
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'   PColumna   (IN)     Columna de la cual se desea conocer su valor,
'                       puede ser el número de columna (de 0 a Columnas -1)
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
    lDato = MhRS(phCursor).Fields(PColumna).Value      ' & "" :MTB le quité esto para que devuelva variants
    'Convierte los nulos en cadena vacía
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

' Objetivo:     Obtiene un dato de un cursor que está en formato de datos largos
'               Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar y que haya sido movido a un
'               registro válido con DBCursorSiguiente o DBCursorGoto
' Autor:        Teseracto - MTB
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'   PColumna   (IN)     Columna de la cual se desea conocer su valor,
'                       puede ser el número de columna (de 0 a Columnas -1)
'                       o puede ser el nombre de la columna
'   pSize      (IN)     Tamaño de los datos a devolver (Default (0)=Todo el campo)
'  Las llamadas sucesivas a ésta funcion van devolviendo pedazos de la info
'SALIDA:
'   Variant             Valor del campo largo o binario en el registro actual
'
'EJEMPLO:
'   lImagen = DBCursorChunk(lCursor%, "Foto")
'

Public Function DBCursorGetChunk(phCursor%, PColumna As Variant, Optional pSize As Long = 0) As Variant
Attribute DBCursorGetChunk.VB_Description = "Obtiene un Chunk de un campo tipo binario largo o imagen, pSize es el tamaño en bytes a devolver (0=todo el campo). las llamadas sucesivas van trayendo pedazos de la info. El cursor debió ser abierto con pOpenStatic=False"
 Dim lMsg As String
 Dim lDato As Variant
 Dim LEmpty As Variant

   ' INICIAR
   On Error GoTo DBCursorChunk_ERR:
   If pSize = 0 Then
      lDato = MhRS(phCursor).Fields(PColumna).GetChunk(MhRS(phCursor).Fields(PColumna).ActualSize)
   Else
      lDato = MhRS(phCursor).Fields(PColumna).GetChunk(pSize)
   End If
   'Convierte los nulos en cadena vacía
   lDato = IIf(IsNull(lDato), "", lDato)

   ' TERMINAR
DBCursorChunk_END:
   DBCursorGetChunk = lDato
   Exit Function

    ' ERROR
DBCursorChunk_ERR:
   lDato = LEmpty
   lMsg = "Ocurrió un error al intentar leer un chunk: " & vbCrLf
   lMsg = lMsg & "Descrip: " & Err.Description & vbCrLf
   lMsg = lMsg & "Número: " & Err.Number & " (" & Hex$(Err.Number) & ")" & vbCrLf
   lMsg = lMsg & "Origen: " & Err.Source & vbCrLf
   DBReportaError lMsg
   Resume DBCursorChunk_END:
End Function

Sub DBCursorPutChunk(phCursor%, PColumna As Variant, ByVal pDatos As Variant, Optional Update As Boolean = True)
Attribute DBCursorPutChunk.VB_Description = "Guarda un Chunk en un campo tipo binario o imagen, a devolver (0=todo el campo). las llamadas sucesivas van escribiendo pedazos de la info en el mismo campo. Poner Update=True solo en la última escritura. El cursor debió ser abierto con pOpenStatic=False"
 Dim lMsg As String
 
   ' INICIAR
   On Error GoTo DBCursorChunk_ERR:
   
   'Escribe el chunk
   MhRS(phCursor).Fields(PColumna).AppendChunk pDatos
   If Update Then
      MhRS(phCursor).Update
   End If

   ' TERMINAR
DBCursorChunk_END:
   Exit Sub

    ' ERROR
DBCursorChunk_ERR:
   lMsg = "Ocurrió un error al intentar guardar un chunk: " & vbCrLf
   lMsg = lMsg & "Descrip: " & Err.Description & vbCrLf
   lMsg = lMsg & "Número: " & Err.Number & " (" & Hex$(Err.Number) & ")" & vbCrLf
   lMsg = lMsg & "Origen: " & Err.Source & vbCrLf
   DBReportaError lMsg
   Resume DBCursorChunk_END
End Sub



' Objetivo:     Ejecutar un query en la base de datos
' Autor:        Teseracto - JVO
' Fecha:        03-04-96
Function DBEjecutar(pQuery$, Optional pConnection As ADODB.Connection = Nothing) As Boolean
Attribute DBEjecutar.VB_Description = "Ejecuta un comando SQL en la BD especificada por pConnection o en la Default. "
'
'USO:
'   pQuery$    (IN)     Query que se desea ejecutar
'   pConnection      (IN)     Handle de la base de datos
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
   If pConnection Is Nothing Then Set pConnection = MhConnDef

   'Intenta ejecutar el query
   pConnection.Execute pQuery$, , adCmdText + adExecuteNoRecords

   'TERMINAR
DBEjecutar_END:
   DBEjecutar = lOK
   Exit Function

   'ERROR
DBEjecutar_ERR:

   MsMsj = "Ocurrió un error al intentar ejecutar una instrucción de SQL: " & vbCrLf & _
           pQuery$ & vbCrLf
   For Each lErrDB In pConnection.Errors
      MsMsj = MsMsj & "Descrip: " & lErrDB.Description & vbCrLf
      MsMsj = MsMsj & "Número: " & lErrDB.Number & " (" & Hex$(lErrDB.Number) & ")" & vbCrLf
      MsMsj = MsMsj & "ProvidErr: " & lErrDB.SQLState & vbCrLf
   Next
   DBReportaError MsMsj
   lOK = False

   Resume DBEjecutar_END
End Function

' Objetivo:     Ejecutar un Stored Procedure que devuelve parámetros de salida o valor de retorno
' Autor:        Teseracto - MTB
' Fecha:        19-10-2005
Function DBEjecutarSP(pSPName$, pConnection As ADODB.Connection, pRetValue As Long, ParamArray pParam()) As Boolean
'
'USO:
'   pSPName$    (IN)     Nombre del Stored Procedure a ejecutar
'   pConnection (IN)     Conexión a la base de datos (Usar Nothing para acceder a la default)
'   pRetValue   (OUT)    Regresa el valor de retorno del SP
'   pParam      (IN/OUT) Parámetros a pasar/regresar al/del SP, ordenados en pares (Param,Variable) o (Param,Valor)
'SALIDA:
'   True                Si se pudo ejecutar
'
'EJEMPLO:
'   lOK = DBEjecutarSP("spMiProcedimiento",nothing,lRet,"@psNombre","Miguel","@ponEdad",lEdad)
'   La variable lRet regresa el valor de retorno y lEdad la edad de Miguel
 Dim lOK As Boolean, i%
 Dim lErrDB As ADODB.Error
 Dim lCmd As ADODB.Command
 Dim lParam As ADODB.Parameter

   'INICIAR
   On Error GoTo DBEjecutarSP_ERR:
   lOK = True

   'Toma la base de datos por default
   If pConnection Is Nothing Then Set pConnection = MhConnDef
   
   'Crea el objeto command
   Set lCmd = New ADODB.Command
   
   'Lo Inicializa
   Set lCmd.ActiveConnection = pConnection
   lCmd.CommandType = adCmdStoredProc
   lCmd.CommandText = pSPName
   
   'Obtiene de la base de datos la definición de los parámetros
   lCmd.Parameters.Refresh
   
   'Le pasa los valores a los parámetros
   For i% = LBound(pParam) To UBound(pParam) Step 2
      lCmd.Parameters(pParam(i%)).Value = pParam(i% + 1)
   Next

   'Ejecuta el SP
   lCmd.Execute
   
   'Regresa el valor de retorno del SP
   For Each lParam In lCmd.Parameters
      If lParam.Direction = adParamReturnValue Then
         pRetValue = lParam.Value
      End If
   Next
   
   'Regresa los otros parámetros devueltos por el SP (solo si son de salida)
   For i% = LBound(pParam) To UBound(pParam) Step 2
      If lCmd.Parameters(pParam(i%)).Direction = adParamInputOutput Or _
         lCmd.Parameters(pParam(i%)).Direction = adParamOutput Then
      
            pParam(i% + 1) = lCmd.Parameters(pParam(i%)).Value
      End If
   Next

   'TERMINAR
DBEjecutarSP_END:
   Set lCmd = Nothing
   DBEjecutarSP = lOK
   Exit Function

   'ERROR
DBEjecutarSP_ERR:

   MsMsj = "Ocurrió un error al intentar ejecutar un Stored Procedure: " & vbCrLf & _
           pSPName$ & vbCrLf
   For i% = LBound(pParam) To UBound(pParam) Step 2
      MsMsj = MsMsj & "   " & pParam(i%) & " = " & pParam(i + 1) & vbCrLf
   Next
   MsMsj = MsMsj & vbCrLf & "Err:" & vbCrLf
   
   MsMsj = MsMsj & "  Descrip: " & Err.Description & vbCrLf
   MsMsj = MsMsj & "  Número: " & Err.Number & " (" & Hex$(Err.Number) & ")" & vbCrLf
   MsMsj = MsMsj & "  Fuente: " & Err.Source & vbCrLf
   
   If pConnection.Errors.Count > 0 Then MsMsj = MsMsj & vbCrLf & "ADO:" & vbCrLf
   For Each lErrDB In pConnection.Errors
      MsMsj = MsMsj & "  Descrip: " & lErrDB.Description & vbCrLf
      MsMsj = MsMsj & "  Número: " & lErrDB.Number & " (" & Hex$(lErrDB.Number) & ")" & vbCrLf
      MsMsj = MsMsj & "  ProvidErr: " & lErrDB.SQLState & vbCrLf
   Next
   DBReportaError MsMsj
   lOK = False

   Resume DBEjecutarSP_END
End Function






'Ejecuta un query, en la base de datos deseada, que devuelve un renglón
'y una columna. (un solo dato)
'PARÁMETROS:
'   pQry$      (IN)     Instrucción SQL o SP que genera el cursor
'   pOK%       (OUT)    True=OK, False=Hubo error
'   pConnection      (IN)     Handle de la base de datos (por omisión la de default)
'SALIDA:
'   Dato                Resultado del query

Function DBQueryDato(pQry$, Optional ByRef pOk As Boolean, _
              Optional pConnection As ADODB.Connection = Nothing) As Variant
Attribute DBQueryDato.VB_Description = "Ejecuta un query que regresa SOLO UN dato y lo devuelve, regresa pOK=True si tuvo éxito"
 Dim lhCur%, lDato As Variant, lOK As Boolean

   'Inicia
   lOK = True
   
   'Ejecuta Query
   If DBCursorIniciar(lhCur%, pQry$, pConnection) Then
      'Se ubica en el primer renglón
      If DBCursorSiguiente(lhCur%) Then
         'Obtiene el dato de la primer columna
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


'Ejecuta un query, en la base de datos Default, que devuelve un renglón
'y Varias columnas (varios datos de un solo registro)
'PARÁMETROS:
'   pQry$      (IN)     Instrucción SQL o SP que genera el cursor
'   pVar      (OUT)     Lista de Variables que recibiran los valores
'SALIDA:
'                       True=OK, False= Hubo error

Function DBQueryDatos(pQry$, pConnection As ADODB.Connection, ParamArray pVar()) As Boolean
Attribute DBQueryDatos.VB_Description = "Ejecuta un query que devuelve un solo renglón y varias columnas, regresa los datos en el paramArray en el mismo orden en que aparecen las columnas del query."
 Dim lhCur%, lDato As Variant, lOK As Boolean, i%, j%

   'Inicia
   lOK = True
   If DBCursorIniciar(lhCur%, pQry$, pConnection) Then
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


' Objetivo:     Obtiene número de columnas del cursor.
'               Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar
' Autor:        Teseracto - JVO
' Fecha:        03-04-96
Function DBCursorCols(phCursor%) As Long
Attribute DBCursorCols.VB_Description = "Regresa el numero de columnas de un cursor"
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'SALIDA:
'   Long             Número de columnas que puede devolver el cursor
'
'EJEMPLO:
'   lNumCols = DBCursorCols(lCursor%)
'
    DBCursorCols = MhRS(phCursor).Fields.Count
End Function

' Objetivo:     Obtiene número de registros del cursor.
'               Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar
' Autor:        Teseracto - JVO
' Fecha:        03-04-96
Function DBCursorCuenta(phCursor%) As Long
Attribute DBCursorCuenta.VB_Description = "Regresa el número de registros de un cursor (es lenta para recordsets de muchos registros)"
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'SALIDA:
'   Long             Número de registros que tiene el cursor.
'
'EJEMPLO:
'   lNumCols% = DBCursorCols%(lCursor%)
'
'IMPORTANTE:
'   Esta rutina se mueve al último registro para poder determinar
'   cuántos registros hay, por lo que puede ser muy lenta si el
'   cursor tiene muchos datos.
'
 Dim LnMark As Variant
 Dim lCuenta As Long

   On Error Resume Next
   
   'Memorizamos la posición actual
   LnMark = MhRS(phCursor).Bookmark
   
   'Nos vamos al final del recordset
   MhRS(phCursor).MoveLast
   
   'Obtenemos la cuenta
   lCuenta = MhRS(phCursor).RecordCount
     
   'Tenemos posicion anterior?
   If IsEmpty(LnMark) Then
       'No, Lo ponemos al principio
       MhRS(phCursor).MoveFirst
       MhRS(phCursor).MovePrevious
   Else
       'Si, lo dejamos donde estaba
       MhRS(phCursor).Bookmark = LnMark
   End If
    
   'Regresa
   DBCursorCuenta = lCuenta
End Function


' Objetivo:     Posicionar el cursor en cierto registro.
' Nota:         Requiere que el cursor haya sido previamente abierto
'               con DBCursorIniciar
' Nota:         Si se usa TrueGrid se debe responder al evento
'               Fetch con esta función o con DBTrueGridFetch.
' Nota:         Los registros están numerados con base en cero
'               (0=1er.Reg, 1=2o.Reg, ...)
' Autor:        Teseracto - MTB,JVO
' Fecha:        30-10-96
Function DBCursorGoto(phCursor%, pRecNo&) As Boolean
Attribute DBCursorGoto.VB_Description = "Posiciona el cursor en un número de registro en particular"
'
'USO:
'   phCursor%  (IN)     Cursor, previamente abierto
'   pRecNo&    (IN)     Número de registro al que se debe mover
'SALIDA:
'   True                Si se pudo colocar en ese registro.
'
'EJEMPLO:
'   lOK = DBCursorGoto%(lCursor%, 86) 'se va al registro 86
'
 Dim LnMark As Variant
 Dim lOK As Boolean
 
    ' INICIAR
    On Error GoTo DBCursorGoto_ERR:
    lOK = True

    ' 1. Determinar posición en la que estamos
    If MnPos(phCursor%) > pRecNo& Then

        ' 1.1 Nos debemos regresar
        While MnPos(phCursor%) > pRecNo&
            ' Regresar un registro
            MhRS(phCursor).MovePrevious
            MnPos(phCursor%) = MnPos(phCursor%) - 1
        Wend
        lOK = Not MhRS(phCursor%).BOF

    ElseIf MnPos(phCursor%) < pRecNo& Then

        ' 1.2 Debemos Avanzar
        While MnPos(phCursor%) < pRecNo&
            ' Avanzar un registro
            MhRS(phCursor).MoveNext
            MnPos(phCursor%) = MnPos(phCursor%) + 1
        Wend
        lOK = Not MhRS(phCursor%).EOF
    End If

    ' TERMINAR
DBCursorGoto_FIN:
    DBCursorGoto = lOK
    Exit Function

    ' ERROR
DBCursorGoto_ERR:
    lOK = False
    Resume DBCursorGoto_FIN:

End Function


'Reporta Errores al usuario o a un archivo LOG
Private Sub DBReportaError(pMsg$)
 Dim fp As Integer
 Dim lFileName$, lCad$
 
   'Los errores van a pantalla?
   If Not mLogErrors Then
      MsgBox pMsg$, vbExclamation + vbOKOnly, "Error en TSR-DB"
      Exit Sub
   End If
   
   'Modo Sin Atención
      
   If mLogFile <> "NULL" Then
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
   End If
   
Salida:
   Exit Sub
   
FileError:
   lCad$ = "No se pudo generar el archivo " & lFileName$ & vbCr & _
            Err.Description & vbCr & _
           "El Error a reportar fué:" & vbCr & pMsg$
   MsgBox lCad$, vbExclamation + vbOKOnly, "Error en TSR_DB"
   Resume Salida
End Sub






'*************************************************************************************
'***** RUTINAS PARA EL USO DE CONTROLES ESTÁNDAR *************************************
'*************************************************************************************


' Objetivo:     Llenar un combo (o lista) con los resultados de un query.
'               La primer columna del query debe ser la clave y la
'               segunda la descripción
'
' Autor:        Teseracto - JVO
' Fecha:        03-04-96
' Modif:        JVO - 06/Dic/96     Devolver false si falla el cursor
'Function DBComboLlenar(phCombo As Control, pQuery$, Optional pConnection As ADODB.Connection = Nothing) As Boolean
Function DBComboLlenar(phCombo As Object, pQuery$, Optional pConnection As ADODB.Connection = Nothing) As Boolean
Attribute DBComboLlenar.VB_Description = "Llena un combo o lista con el resultado de un Query.\r\nLa 1er columna del query es la clave y la 2a la descripción."
'
'USO:
'   phCombo    (IN)     Combo Por llenar
'   pQuery$    (IN)     Query con los datos: 1er col. es la clave, 2da col es la Descripción
'   pConnection      (IN)     Handle de la base de datos
'SALIDA:
'   True                Se llenó correctamente el combo
'
'EJEMPLO:
'   lOK% = DBComboLlenar%(frmDatos.cmbEdos, "Select NumEdo, Nombre From Estados")
'
Dim lOK As Boolean, lhCur%

    ' INICIAR
    On Error GoTo DBComboLlenar_ERR:
    lOK = True

    'Toma la base de datos por default
    If pConnection Is Nothing Then Set pConnection = MhConnDef

    ' 1. Limpiar el control
    phCombo.Clear

    ' 2. Abrir el Cursor con los datos
    If DBCursorIniciar(lhCur%, pQuery$, pConnection) Then
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
    MsMsj = "Ocurrió un error al intentar llenar un combo: "
    MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]"
    DBReportaError MsMsj
    lOK = False
    Resume DBComboLlenar_END

End Function

' Objetivo:     Regresa la clave seleccionada en un combo
' Autor:        Teseracto - JVO
' Fecha:        10-04-96
'Function DBComboSeleccion(phCombo As Control) As String
Function DBComboSeleccion(phCombo As Object) As String
Attribute DBComboSeleccion.VB_Description = "Obtiene la Clave del elemento seleccionado dentro de un combo o lista."
'
'USO:
'   phCombo    (IN)     Combo con la selección
'SALIDA:
'   String              Clave seleccionada. "" si no hay elemento seleccionado
'
'EJEMPLO:
'   lCve$ = DBComboSeleccion$(frmDatos.cmbEdos)
'
Dim LsClave$, LsDescr$

    ' ¿Hay algo seleccionado?
    If phCombo.ListIndex = -1 Then
        ' NO
        LsClave$ = ""
    Else
        ' SI => Desarmar la llave seleccionada
        DBLlaveDesarmar (phCombo.Text), LsClave$, LsDescr$
    End If

    ' TERMINAR
    DBComboSeleccion = LsClave$

End Function


' Objetivo:     Regresa el nombre seleccionado en un combo
' Autor:        Teseracto - JVO, MTB
' Fecha:        10-04-96
'Function DBComboSeleccionN$(phCombo As Control)
Function DBComboSeleccionN$(phCombo As Object)
Attribute DBComboSeleccionN.VB_Description = "Obtiene la Descripción o Nombre del elemento seleccionado dentro de un combo o lista."
'
'USO:
'   phCombo    (IN)     Combo con la selección
'SALIDA:
'   String              Clave seleccionada. "" si no hay elemento seleccionado
'
'EJEMPLO:
'   lCve$ = DBComboSeleccion$(frmDatos.cmbEdos)
'
Dim LsClave$, LsDescr$

    ' ¿Hay algo seleccionado?
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

' Objetivo:     Seleccionar una clave o descripción en un combo
' Autor:        Teseracto - JVO
' Fecha:        10-04-96
'Sub DBComboSeleccionar(phCombo As Control, Optional PsClave$ = "", Optional PsDescr$ = "")
Sub DBComboSeleccionar(phCombo As Object, Optional PsClave$ = "", Optional PsDescr$ = "")
Attribute DBComboSeleccionar.VB_Description = "Busca un elemento dentro de un combo o lista y lo selecciona. Enviar clave o descripción a buscar."
'
'USO:
'   phCombo    (IN)     Combo con la selección
'   psClave$   (IN)     Clave por buscar. (Puede ser vacío si se envía psDescr$)
'   psDescr$   (IN)     Descripción por buscar. (Puede ser vacío si se envía psClave$)
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

    ' 2. ¿Nos envían datos?
    If PsClave$ <> "" Or PsDescr$ <> "" Then
        ' SI => Buscarlo
        For i% = 0 To phCombo.ListCount - 1

            ' 3. Obtener datos del combo
            DBLlaveDesarmar (phCombo.List(i%)), LsClave$, LsDescr$
            If ((LsClave$ = PsClave$) And LsClave$ <> "") Or _
               ((LsDescr$ = PsDescr$) And LsDescr$ <> "") Then
                ' Ya lo encontramos
                phCombo.ListIndex = i%
                Exit For
            End If
        Next
    End If

End Sub


' Objetivo:     Armar un string con una clave y una descripción
' Autor:        Teseracto - JVO
' Fecha:        10-04-96
Private Function DBLlaveArmar$(PsClave$, PsDescr$)
    DBLlaveArmar$ = PsDescr$ & Space(LLAVE_SEP) & Chr$(124) & PsClave$
End Function

' Objetivo:     Obtiene la clave y la descripción de una llave
' Autor:        Teseracto - JVO
' Fecha:        10-04-96
Private Sub DBLlaveDesarmar(psLlave$, PsClave$, PsDescr$)
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


' Objetivo:      Llenar un ListView con los resultados de un query.
'                La primer columna del query debe ser la clave y la
'                segunda la descripción, la 3a el índice del icono (o Key),
'                el resto los detalles
'
' Observaciones: El ListView a llenar, debe de teener el numero correcto de columnas
'                antes de llamar a ésta función
'
' Autor:        Teseracto - MTB
' Fecha:        07-06-99
'Function DBListViewLlenar(phList As MSComctlLib.ListView, pQuery$, ...
Function DBListViewLlenar(phList As Object, pQuery$, _
             Optional pConnection As ADODB.Connection = Nothing) As Boolean
Attribute DBListViewLlenar.VB_Description = "Llena un ListView con un query:\r\n1er Col= Clave, 2a=Descripcion, 3a=Indice o Key del Icono, 4a en adelante= Detalles.\r\nVerificar que el Listview tenga las columnas necesarias."
'
'USO:
'   phList      (IN)     ListView Por llenar
'   pQuery$     (IN)     Query con los datos: 1er col. es la clave, 2da col es la Descripción
'   pConnection (IN)     Handle de la base de datos
'SALIDA:
'   True                Se llenó correctamente el combo
'
'EJEMPLO:
'   'El control lvwEdos debe tener dos columnas: Nombre y población (Forzosamente)
'   lOK = DBListViewLlenar%(frmDatos.lvwEdos, "Select NumEdo, Nombre, 'Icono'=1, Poblacion From Estados")
'
 Dim lOK As Integer, lhCur%, lItem As ListItem
 Dim lCols%, i%

    ' INICIAR
    On Error GoTo DBListViewLlenar_ERR:
    lOK = True

    'Toma la base de datos por default
    If pConnection Is Nothing Then Set pConnection = MhConnDef

    ' 1. Limpiar el control
    phList.ListItems.Clear
    

    ' 2. Abrir el Cursor con los datos
    If DBCursorIniciar(lhCur%, pQuery$, pConnection) Then
        'Obtiene el número de columnas-detalle
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
    MsMsj = "Ocurrió un error al intentar llenar un listview: "
    MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]"
    DBReportaError MsMsj
    lOK = False
    Resume DBListViewLlenar_END

End Function



'''
'''
''''Inicia una transacción, ya sea en el espacio Jet (default)
'''' o en el espacio ODBC
'''Sub DBBeginTran(Optional pWrkODBC As Boolean = False)
'''
'''   MsgBox "Falta traducir a ADO"
'''
''''   'Inicia
''''   On Error GoTo Err_Begin
''''
''''   'Inicia la transacción
''''   If pWrkODBC Then
''''      mWrkODBC.BeginTrans
''''   Else
''''      mWrkJet.BeginTrans
''''   End If
''''
''''Salida:
''''   Exit Sub
''''
''''Err_Begin:
''''   MsMsj = "Ocurrió un error al iniciar una transacción: "
''''   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
''''   DBReportaError MsMsj
''''   Resume Salida
'''End Sub
'''
''''Termina una transacción, ya sea en el espacio Jet (default)
'''' o en el espacio ODBC
'''Sub DBCommitTran(Optional pWrkODBC As Boolean = False)
'''
'''   MsgBox "Falta traducir a ADO"
'''
''''   'Inicia
''''   On Error GoTo Err_Commit
''''
''''   'Termina la transacción
''''   If pWrkODBC Then
''''      mWrkODBC.CommitTrans
''''   Else
''''      mWrkJet.CommitTrans dbForceOSFlush
''''   End If
''''
''''Salida:
''''   Exit Sub
''''
''''Err_Commit:
''''   MsMsj = "Ocurrió un error al terminar una transacción: "
''''   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
''''   DBReportaError MsMsj
''''   Resume Salida
'''End Sub
'''
''''Revierte una transacción, ya sea en el espacio Jet (default)
'''' o en el espacio ODBC
'''Sub DBRollBack(Optional pWrkODBC As Boolean = False)
'''
'''   MsgBox "Falta traducir a ADO"
'''
''''   'Inicia
''''   On Error GoTo Err_RollBack
''''
''''   'Termina la transacción
''''   If pWrkODBC Then
''''      mWrkODBC.Rollback
''''   Else
''''      mWrkJet.Rollback
''''   End If
''''
''''Salida:
''''   Exit Sub
''''
''''Err_RollBack:
''''   MsMsj = "Ocurrió un error al revertir una transacción: "
''''   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
''''   DBReportaError MsMsj
''''   Resume Salida
'''End Sub
'''
''''Liga una tabla externa a una base jet abierta
'''Function DBLigaTablaExt(phDB%, psTableName1$, psDSN$, psTableName2$, Optional psUsr$, Optional psPwd$, Optional pODBC As Boolean = False) As Boolean
''''
''''USO:
''''   phDB%         (IN)   Handle de la base de datos a la que se va a anexar la tabla
''''   psTableName1$ (IN)   Nombre que tendrá la tabla ligada (dentro de phDB%)
''''   psDSN$        (IN)   ODBC: Data Source Name, como aparece en ODBC en Control Panel
''''                        Jet: Nombre de la base de datos con ruta
''''   psTableName2$ (IN)   Nombre original de la tabla en la base de datos externa
''''   psUsr$        (IN)   ODBC: Usuario, para firmarse en la base de datos
''''                        Jet: Tipo de la base de datos externa (ejemplo: "DBase IV" , "Excel 5.0" , etc.)
''''   psPwd$        (IN)   Sólo ODBC: Password,  para firmarse en la base de datos
''''   pODBC         (IN)   Tipo de conexión para la tabla externa. TRUE: ODBC, FALSE: Jet
''''SALIDA:
''''   True                Si se pudo conectar a la base de datos
''''
'''
'''
'''   MsgBox "Falta traducir a ADO"
'''
''''
'''' Dim lTabla As TableDef, lOK As Boolean, lConn$, lOpt As Long
''''
''''   'Inicia
''''   On Error GoTo Err_Liga
''''   lOK = True
''''
''''   'Toma la base de datos por default
''''   If phDB% = DBDEFAULT Then phDB% = MhConnDef
''''
''''   'Crea un Tabledef para la tabla externa
''''   Set lTabla = MhConn(phDB%).CreateTableDef(psTableName1$)
''''
''''   'Fija los parámetros de conexión al TableDef
''''   If pODBC Then
''''      lConn$ = "ODBC;DSN=" & psDSN$ & "" & _
''''                 ";UID=" & psUsr$ & _
''''                 ";PWD=" & psPwd$
''''      lOpt = dbAttachedODBC
''''   Else
''''      lConn$ = IIf(psUsr$ = "", ";DATABASE=", psUsr$ & ";")
''''      lConn$ = lConn$ & psDSN$
''''      lOpt = dbAttachedTable
''''   End If
''''
''''   'Fija los parámetros
''''   lTabla.Connect = lConn$
''''   'lTabla.Attributes = lOpt   'Quien sabe por que truena aquí (MTB)
''''   lTabla.SourceTableName = psTableName2$
''''
''''   'Añade el TableDef a la base de datos
''''   MhConn(phDB%).TableDefs.Append lTabla
''''
''''Salida:
''''   DBLigaTablaExt = lOK
''''   Exit Function
''''
''''Err_Liga:
''''   'El Objeto ya existe?
''''   If Err = 3012 Then
''''      'Es una tabla ligada?
''''      If MhConn(phDB%).TableDefs(psTableName1$).Attributes And lOpt Then
''''         'No hay problema, usa esa tabla
''''         lOK = True
''''         Resume Salida
''''      End If
''''   End If
''''   lOK = False
''''   MsMsj = "Ocurrió un error al intentar ligar la tabla externa:"
''''   MsMsj = MsMsj & Chr$(10) & "Conn= " & lConn$ & Chr$(10)
''''   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
''''   DBReportaError MsMsj
''''   Resume Salida
''''
'''End Function
'''
''''Quita la liga a la tabla externa
'''Sub DBDesLigaTablaExt(psTableName1$, Optional phDB% = -1)
'''
'''   MsgBox "Falta traducir a ADO"
'''
'''' Dim lOK As Boolean
''''
''''   'Toma la base de datos por default
''''   If phDB% = DBDEFAULT Then phDB% = MhConnDef
''''
''''   On Error GoTo Err_Desliga
''''   'Borra la Tabla Ligada
''''   MhConn(phDB%).TableDefs.Delete psTableName1$
''''
''''Salida:
''''   Exit Sub
''''
''''Err_Desliga:
''''   lOK = False
''''   MsMsj = "Ocurrió un error al intentar desligar una tabla externa:"
''''   MsMsj = MsMsj & Chr$(10) & "[ " & Error$ & " ]" & Chr$(10)
''''   DBReportaError MsMsj
''''   Resume Salida
''''
'''End Sub
'''
'''
