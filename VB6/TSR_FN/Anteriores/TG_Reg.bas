Attribute VB_Name = "TG_Reg"
' CST_REG - Consultech (c) 1998
'         Ing. Miguel A. Torres-Orozco Bermeo.
' Funciones para el uso del registro de windows
Option Explicit

'Public Const SYNCHRONIZE = &H100000
'Public Const READ_CONTROL = &H20000
'Public Const STANDARD_RIGHTS_ALL = &H1F0000
'Public Const STANDARD_RIGHTS_EXECUTE = (READ_CONTROL)
'Public Const STANDARD_RIGHTS_READ = (READ_CONTROL)
'Public Const STANDARD_RIGHTS_REQUIRED = &HF0000
'Public Const STANDARD_RIGHTS_WRITE = (READ_CONTROL)
'
'Public Const KEY_QUERY_VALUE = &H1
'Public Const KEY_CREATE_LINK = &H20
'Public Const KEY_CREATE_SUB_KEY = &H4
'Public Const KEY_ENUMERATE_SUB_KEYS = &H8
'Public Const KEY_NOTIFY = &H10
'Public Const KEY_SET_VALUE = &H2
'Public Const KEY_ALL_ACCESS = ((STANDARD_RIGHTS_ALL Or KEY_QUERY_VALUE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY Or KEY_CREATE_LINK) And (Not SYNCHRONIZE))
'Public Const KEY_READ = ((STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY) And (Not SYNCHRONIZE))
'Public Const KEY_WRITE = ((STANDARD_RIGHTS_WRITE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY) And (Not SYNCHRONIZE))
'Public Const KEY_EXECUTE = ((KEY_READ) And (Not SYNCHRONIZE))



'CONSTANTES GLOBALES
'-------------------
Global Const HKEY_CLASSES_ROOT = &H80000000
Global Const HKEY_CURRENT_USER = &H80000001
Global Const HKEY_LOCAL_MACHINE = &H80000002
Global Const HKEY_USERS = &H80000003
Global Const HKEY_PERFORMANCE_DATA = &H80000004
Global Const HKEY_CURRENT_CONFIG = &H80000005
Global Const HKEY_DYN_DATA = &H80000006

'CONSTANTES LOCALES
'------------------
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
Const REG_OPTION_NON_VOLATILE = 0       ' La clave se conserva al reiniciar el sistema


'Prototipos de la API del Registro
'Funciones básicas
Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Declare Function RegCreateKeyEx Lib "advapi32.dll" Alias "RegCreateKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal Reserved As Long, ByVal lpClass As String, ByVal dwOptions As Long, ByVal samDesired As Long, ByVal lpSecurityAttributes As Long, phkResult As Long, lpdwDisposition As Long) As Long
Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
Declare Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Any, lpcbData As Long) As Long
   'Note that if you declare the lpData parameter as String, you must pass it By Value.
   'Alias útiles:
   Declare Function RegQueryValueExString Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, ByVal lpData As String, lpcbData As Long) As Long
   Declare Function RegQueryValueExLong Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Long, lpcbData As Long) As Long
   Declare Function RegQueryValueExNULL Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, ByVal lpData As Long, lpcbData As Long) As Long
Declare Function RegSetValueEx Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpData As Any, ByVal cbData As Long) As Long
   'Note that if you declare the lpData parameter as String, you must pass it By Value.
   'Alias útiles:
   Declare Function RegSetValueExString Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, ByVal lpValue As String, ByVal cbData As Long) As Long
   Declare Function RegSetValueExLong Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpValue As Long, ByVal cbData As Long) As Long
Declare Function RegDeleteKey Lib "advapi32.dll" Alias "RegDeleteKeyA" (ByVal hKey As Long, ByVal lpSubKey As String) As Long
Declare Function RegDeleteValue Lib "advapi32.dll" Alias "RegDeleteValueA" (ByVal hKey As Long, ByVal lpValueName As String) As Long
'
'
Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerialNumber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long) As Long
'
'Otras funciones relacionadas (no se usan en este módulo por lo que aparecen con comentarios)
'----------------------------
'Type FILETIME
'   dwLowDateTime As Long
'   dwHighDateTime As Long
'End Type
'Declare Function RegConnectRegistry Lib "advapi32.dll" Alias "RegConnectRegistryA" (ByVal lpMachineName As String, ByVal hKey As Long, phkResult As Long) As Long
'Declare Function RegDeleteKey Lib "advapi32.dll" Alias "RegDeleteKeyA" (ByVal hKey As Long, ByVal lpSubKey As String) As Long
'Declare Function RegDeleteValue Lib "advapi32.dll" Alias "RegDeleteValueA" (ByVal hKey As Long, ByVal lpValueName As String) As Long
'Declare Function RegEnumKeyEx Lib "advapi32.dll" Alias "RegEnumKeyExA" (ByVal hKey As Long, ByVal dwIndex As Long, ByVal lpName As String, lpcbName As Long, ByVal lpReserved As Long, ByVal lpClass As String, lpcbClass As Long, lpftLastWriteTime As FILETIME) As Long
'Declare Function RegEnumValue Lib "advapi32.dll" Alias "RegEnumValueA" (ByVal hKey As Long, ByVal dwIndex As Long, ByVal lpValueName As String, lpcbValueName As Long, ByVal lpReserved As Long, lpType As Long, lpData As Byte, lpcbData As Long) As Long
'Declare Function RegFlushKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
'Declare Function RegLoadKey Lib "advapi32.dll" Alias "RegLoadKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal lpFile As String) As Long
'Declare Function RegNotifyChangeKeyValue Lib "advapi32.dll" (ByVal hKey As Long, ByVal bWatchSubtree As Long, ByVal dwNotifyFilter As Long, ByVal hEvent As Long, ByVal fAsynchronus As Long) As Long
'Declare Function RegQueryInfoKey Lib "advapi32.dll" Alias "RegQueryInfoKeyA" (ByVal hKey As Long, ByVal lpClass As String, lpcbClass As Long, ByVal lpReserved As Long, lpcSubKeys As Long, lpcbMaxSubKeyLen As Long, lpcbMaxClassLen As Long, lpcValues As Long, lpcbMaxValueNameLen As Long, lpcbMaxValueLen As Long, lpcbSecurityDescriptor As Long, lpftLastWriteTime As FILETIME) As Long
'Declare Function RegReplaceKey Lib "advapi32.dll" Alias "RegReplaceKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal lpNewFile As String, ByVal lpOldFile As String) As Long
'Declare Function RegRestoreKey Lib "advapi32.dll" Alias "RegRestoreKeyA" (ByVal hKey As Long, ByVal lpFile As String, ByVal dwFlags As Long) As Long
'Declare Function RegSaveKey Lib "advapi32.dll" Alias "RegSaveKeyA" (ByVal hKey As Long, ByVal lpFile As String, lpSecurityAttributes As Long) As Long
'Declare Function RegUnLoadKey Lib "advapi32.dll" Alias "RegUnLoadKeyA" (ByVal hKey As Long, ByVal lpSubKey As String) As Long
'Declare Function InitiateSystemShutdown Lib "advapi32.dll" Alias "InitiateSystemShutdownA" (ByVal lpMachineName As String, ByVal lpMessage As String, ByVal dwTimeout As Long, ByVal bForceAppsClosed As Long, ByVal bRebootAfterShutdown As Long) As Long
'Declare Function AbortSystemShutdown Lib "advapi32.dll" Alias "AbortSystemShutdownA" (ByVal lpMachineName As String) As Long


'--------------------------------------------------------
' Objetivo:     Abrir una llave del registro de windows para lectura o escritura
' Parametros:   phMainKey: Handle de la llave principal del registro (KEY_*)
'               psSubKey: Cadena con la subllave (Ruta)
'               pCreateKey: True - Crea la llave
'                           False - Solo la abre (si no existe devuelve error)
' Salida:       Devuelve el Handle de la llave abierta
'               o 0 si hubo error
' Autor:        Consultech - MTB
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
' Autor:        Consultech - MTB
' Fecha:        2-08-2000
'
' Notas:        Siempre se debe de cerrar el registro si se abrió con exito
' Ejemplo:
'     lhKey = FNRegistroAbrir(HKEY_CURRENT_CONFIG, "System\CurrentControlSet\Control\Print\Printers")
'     lDefaultPrinter$ = FNRegistroLeer(lhKey, "Default")
'     FNRegistroCerrar (lhKey)
'--------------------------------------------------------
Sub FNRegistroCerrar(phKey)
 Dim lRet As Long
   'Cierra la llave, si está abierta
   If phKey <> 0 Then lRet = RegCloseKey(phKey)
End Sub



'--------------------------------------------------------
' Objetivo:     Leer una variable dentro de una llave del registro de windows
' Parametros:   phKey: Handle de la llave (abierta)
'               psVariable: Nombre de la variable
'               Salida: El valor de la variable o Empty si hubo error
' Autor:        Consultech - MTB
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
Function FNRegistroLeer(phKey As Long, psVariable$, Optional pDefault As Variant = Empty) As Variant
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
' Autor:        Consultech - MTB
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
' Autor:        Consultech - MTB
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
' Autor:        Consultech - MTB
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
' Autor:        Consultech - MTB
' Fecha:        2-08-2000
'
' Notas:       -Esta funcion NO SE RECOMIENDA si se van a leer
'               varias variables dentro de la misma llave,
'               para ello usar mejor FNRegistroLeer
'              -Solo se pueden leer variables de tipo string o long (dword)
'--------------------------------------------------------
Function FNRegistroGetVal(phMainKey As Long, psSubKey$, psVariable$, Optional pDefault As Variant = Empty) As Variant
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
' Autor:        Consultech - MTB
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
   

'--------------------------------------------------------
' Objetivo:     Leer el VolumeLabel y el Num de serie de un disco
' Parametros:   psPath$     (IN)  : Ruta que contiene el drive a probar
'               psVolLabel$ (OUT) : Regresa la etiqueta o vacio si hubo error
'               pSerialNum  (OUT) : Regresa el NumSerie o cero si hubo error
' Autor:        Consultech - MTB
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
