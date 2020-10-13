Attribute VB_Name = "TSR_TCP"
' TSR_TCP.bas - Teseracto (c) 2003
'      Ing. Miguel A. Torres-Orozco Bermeo.
' Rutinas para Comunicacion TCP/IP (Sockets)
'
'NOTA: Solo soporta una conexi�n al mismo tiempo
'
' USO:
'  1. Poner un control Winsock en una forma del proyecto
'     (puede ser la principal) y hacer llamadas a �ste m�dulo.
'  2. En el evento Error del control llamar a TCPUpdateErrorString

Option Explicit

'API
Public Declare Sub MemCopy Lib "kernel32.dll" Alias "RtlMoveMemory" (Destino As Any, Origen As Any, ByVal Size As Long)

'Variables de M�dulo
Private mWinsock As Winsock
Private mErrDescription As String

' Objetivo:     Conectarse a un servidor TCP/IP
' Autor:        Teseracto - MTB
' Fecha:        Jun 2003
'
' Par�ms:       pIPAddress$     (IN) - Direcci�n IP del servidor (puede ser por nombre)
'               pWinsockControl (IN) - Control Winsock que se utilizar� para la conexi�n
'               pStatusControl  (IN) - Control textbox o panel donde se desplegar�n los mensajes de estatus.
' Salida:       TRUE - Se realiz� la conexi�n exitosamente

Public Function TCPConectar(pIPAddress$, pPort&, pWinsockControl As Winsock, Optional pStatusControl As Object = Nothing) As Boolean
 Dim lOK As Boolean
 
   'Obtiene el control Winsock
   If Not pWinsockControl Is Nothing Then Set mWinsock = pWinsockControl
   
   'Si est� conectado primero se desconecta
   If (mWinsock.State <> sckClosed) Then
      mWinsock.Close
   End If
   
   'Establece la direccion y puerto del servidor remoto
   mWinsock.RemoteHost = pIPAddress$
   mWinsock.RemotePort = pPort&
   
   'Se Conecta
   mWinsock.Connect
   
   'Espera a ver que pasa
   EsperaRespuesta pStatusControl
   
   TCPConectar = (mWinsock.State = sckConnected)
End Function

' Objetivo:     Obtener la cadena de estatus de la conexi�n
' Autor:        Teseracto - MTB
' Fecha:        Jun 2003
Public Function TCPGetStatusString() As String
 Dim lState As StateConstants
 Dim lMsg$
      
   'Obtiene el estatus del control
   lState = mWinsock.State
   
   'Arma el mensaje como texto
   Select Case lState
      Case sckClosed
         lMsg$ = "Desconectado."
      Case sckOpen
         lMsg$ = "Abierto"
      Case sckListening
         lMsg$ = "Escuchando"
      Case sckConnectionPending
         lMsg$ = "Conexi�n pendiente..."
      Case sckResolvingHost
         lMsg$ = "Resolviendo Host..."
      Case sckHostResolved
         lMsg$ = "Host resuelto"
      Case sckConnecting
         lMsg$ = "Conectando..."
      Case sckConnected
         lMsg$ = "Conectado."
      Case sckClosing
         lMsg$ = "El equipo remoto ha cerrado la conexi�n..."
      Case sckError
         lMsg$ = "Error: " & mErrDescription
   End Select
   
   'Regresa el texto
   TCPGetStatusString = lMsg$
End Function

' Objetivo: Mantener actualizado el mensaje de error de conexi�n
' Autor:    Teseracto - MTB
' Fecha:    Jun 2003
'
' Par�ms:   Number     (IN) - Direcci�n IP del servidor (puede ser por nombre)
'           Description (IN) - Control Winsock que se utilizar� para la conexi�n
' Notas:
'           Este procedimiento debe llamarse en el evento Error del control winsock
' Ejemplo:
'      Private Sub tcpCtrl_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
'         'Actualiza la descripci�n del error en TSR_TCP
'         TCPUpdateErrorString Number, Description
'      End Sub
'
Public Sub TCPUpdateErrorString(ByVal Number As Integer, Description As String)
 Dim lState As StateConstants
 Dim lMsg$
   'Arma el mensaje de error en espa�ol
   Select Case Number
      Case sckOutOfMemory
         lMsg$ = "Sin memoria"
      Case sckInvalidPropertyValue
         lMsg$ = "El valor de la propiedad no es v�lido. "
      Case sckGetNotSupported
         lMsg$ = "No se puede leer la propiedad. "
      Case sckSetNotSupported
         lMsg$ = "La propiedad es de s�lo lectura. "
      'Case sckBadState
      '   lMsg$ = "Protocolo o estado de conexi�n incorrecto para la solicitud o la transacci�n requerida. "
      'Case sckInvalidArg
      '   lMsg$ = "El argumento que se pas� a una funci�n no estaba en el formato correcto o en el intervalo especificado. "
      'Case sckSuccess
      '   lMsg$ = "Correcto. "
      'Case sckUnsupported
      '   lMsg$ = "Tipo Variant no aceptado. "
      'Case sckInvalidOp
      '   lMsg$ = "La operaci�n no es v�lida en el estado actual. "
      'Case sckOutOfRange
      '   lMsg$ = "El argumento est� fuera del intervalo. "
      'Case sckWrongProtocol
      '   lMsg$ = "Protocolo err�neo para la solicitud o la transacci�n requerida. "
      Case sckOpCanceled
         lMsg$ = "Se cancel� la operaci�n. "
      Case sckInvalidArgument
         lMsg$ = "La direcci�n solicitada es una direcci�n de multidifusi�n, pero el indicador no est� activado. "
      Case sckWouldBlock
         lMsg$ = "El socket es no bloqueante y la operaci�n especificada se bloquear�. "
      Case sckInProgress
         lMsg$ = "Se est� efectuando una operaci�n de Winsock bloqueante. "
      Case sckAlreadyComplete
         lMsg$ = "Se complet� la operaci�n. No se est�n efectuando operaciones bloqueantes. "
      Case sckNotSocket
         lMsg$ = "El descriptor no es un socket. "
      Case sckMsgTooBig
         lMsg$ = "El datagrama es demasiado grande para el b�fer y se truncar�. "
      Case sckPortNotSupported
         lMsg$ = "El puerto especificado no es compatible. "
      Case sckAddressInUse
         lMsg$ = "Direcci�n en uso. "
      Case sckAddressNotAvailable
         lMsg$ = "La direcci�n no est� disponible en la m�quina local. "
      Case sckNetworkSubsystemFailed
         lMsg$ = "Error en el subsistema de red. "
      Case sckNetworkUnreachable
         lMsg$ = "El host no puede encontrar la red en este momento. "
      Case sckNetReset
         lMsg$ = "Expir� el tiempo de espera de la conexi�n antes de establecer SO_KEEPALIVE. "
      Case sckConnectAborted
         lMsg$ = "La conexi�n se ha cancelado al sobrepasar el tiempo de espera o por otro error. "
      Case sckConnectionReset
         lMsg$ = "La conexi�n se ha restablecido desde el lado remoto. "
      Case sckNoBufferSpace
         lMsg$ = "No hay espacio disponible en el b�fer. "
      Case sckAlreadyConnected
         lMsg$ = "El socket ya est� conectado. "
      Case sckNotConnected
         lMsg$ = "El socket no est� conectado. "
      Case sckSocketShutdown
         lMsg$ = "El socket se ha desactivado. "
      Case sckTimedout
         lMsg$ = "Se ha sobrepasado el tiempo de conexi�n. "
      Case sckNotInitialized
         lMsg$ = "Es necesario llamar primero a WinsockInit. "
      Case sckHostNotFound
         lMsg$ = "Respuesta autorizada: host no encontrado. "
      Case sckHostNotFoundTryAgain
         lMsg$ = "Respuesta no autorizada: host no encontrado. "
      Case sckNonRecoverableError
         lMsg$ = "Errores no recuperables. "
      Case sckNoData
         lMsg$ = "Nombre v�lido; no hay registro de datos del tipo solicitado. "
      Case sckConnectionRefused
         lMsg$ = "Se ha rechazado la solicitud de conexi�n. "
      Case Else
         lMsg$ = "Error DESCONOCIDO: " & Description
   End Select
   
   'Actualiza el mensaje de error
   mErrDescription = lMsg$
   
   'Imprime el mensaje
   Debug.Print lMsg$
End Sub

' Objetivo:     Cerrar la conexi�n
' Autor:        Teseracto - MTB
' Fecha:        Jun 2003
'
' Par�ms:       pStatusControl  (IN) - Control textbox o panel donde se desplegar�n los mensajes de estatus.

Public Sub TCPDesconectar(Optional pStatusControl As Object)
   'Se Desconecta
   On Error Resume Next
   If mWinsock.State <> sckClosed Then mWinsock.Close
   EsperaRespuesta pStatusControl
End Sub



' Objetivo:     Enviar una cadena de caracteres
' Autor:        Teseracto - MTB
' Fecha:        Jun 2003
'
' Par�ms:       pMsg$    (IN) - Direcci�n IP del servidor (puede ser por nombre)
' Salida:       TRUE - Se realiz� el env�o exitosamente

Public Function TCPSendString(pMsg$) As Boolean
 Dim lOK As Boolean
 Dim lIP$, lPort As Long
 
   'Inicia
   lOK = True
   On Error GoTo ErrTX_1
   
Envia:
   'Env�a el mensaje
   mWinsock.SendData pMsg$

Salida:
   TCPSendString = lOK
   Exit Function
   
Reconnect:
   On Error GoTo 0
   'Obtiene Direcci�n y puerto
   lIP = mWinsock.RemoteHost
   lPort = mWinsock.RemotePort
   
   'Trata de volver a conectarse
   lOK = TCPConectar(lIP, lPort, Nothing)
   'Se conect�?
   If lOK Then
      'Intenta volver a enviar
      On Error GoTo ErrTX_2   'No tolera un segundo error
      GoTo Envia
   Else
      lOK = False
      GoTo Salida
   End If

ErrTX_1:
   Resume Reconnect

ErrTX_2:
   lOK = False
   Resume Salida
End Function

'Env�a un arreglo de bytes
Public Function TCPSendBytes(pMsg() As Byte) As Boolean
 Dim lOK As Boolean
 Dim lIP$, lPort As Long
 
   'Inicia
   lOK = True
   On Error GoTo ErrTX_1
   
Envia:
   'Env�a el mensaje
   mWinsock.SendData pMsg

Salida:
   TCPSendBytes = lOK
   Exit Function
   
Reconnect:
   On Error GoTo 0
   
   'Obtiene Direcci�n y puerto
   lIP = mWinsock.RemoteHost
   lPort = mWinsock.RemotePort
   
   'Trata de volver a conectarse
   lOK = TCPConectar(lIP, lPort, Nothing)
   'Se conect�?
   If lOK Then
      'Intenta volver a enviar
      On Error GoTo ErrTX_2   'No tolera un segundo error
      GoTo Envia
   Else
      lOK = False
      GoTo Salida
   End If

ErrTX_1:
   Resume Reconnect

ErrTX_2:
   lOK = False
   Resume Salida
End Function


'Espera mientras el control se conecta o desconecta
Private Sub EsperaRespuesta(Optional pStatusControl As Object)
 Dim lState As StateConstants
 Dim lMsg$, lOK As Boolean
  
   'Inicia
   lOK = False
   
   Do
      'Obtiene el estatus del control
      lState = mWinsock.State
      'Debe terminar la espera en los siguientes casos
      lOK = (lState = sckClosed) Or _
            (lState = sckConnected) Or _
            (lState = sckError)
      'Imprime el mensaje del estatus
      Debug.Print "State= " & TCPGetStatusString
      If Not (pStatusControl Is Nothing) Then pStatusControl = TCPGetStatusString
      'Espera
      DoEvents
   Loop Until lOK
End Sub


