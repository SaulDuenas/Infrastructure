Attribute VB_Name = "Reportes"
Option Explicit

'Tipo que guarda todos los parámetros del reporte de
' Devolucion y/o Compensación de IVA
Type TAnexo32
   DestinoDisco As Boolean
   Ruta As String
   Anual As Boolean
   Fecha1 As Date
   Fecha2 As Date
   FechComp As Date
   FechCompI As Date
   FechCompF As Date
   FechSaldI As Date
   FechSaldF As Date
   TipoDec As Integer 'Vale 1 Normal o 2 Complementaria
   FechFavor As Date
   Trasladado As Currency
   Retenido As Currency
   Acreditable As Currency
   Pendiente As Currency
   SaldoFavor As Currency
   Compensado As Currency
   Banco As String
   Sucursal As String
   Cuenta As String
   LocBanco As String
End Type

Private Const IVACOM = "IVACOM"
Private Const IVADEV = "IVADEV"



'Genera los Reportes de Devolución y Compensación de IVA
'Parámetros:
'   pAnexo32 -  (IN) : Trae todos los parámetros capturados del reporte
Sub ReporteIvaCom(pAnexo32 As TAnexo32)
 Dim lQry$, lNumReg1&, lNumReg2&, lNumReg3&
  
  '1. Escribe los datos capturados en la base de datos
   With pAnexo32
      lQry$ = "UPDATE System SET" & _
              "  FechComp=CDate('" & .FechComp & "')" & _
              ", FechCompI=CDate('" & .FechCompI & "')" & _
              ", FechCompF=CDate('" & .FechCompF & "')" & _
              ", FechSaldI=CDate('" & .FechSaldI & "')" & _
              ", FechSaldF=CDate('" & .FechSaldF & "')" & _
              ", TipoDec=" & .TipoDec & _
              ", FechFavor=CDate('" & .FechFavor & "')" & _
              ", Trasladado=" & .Trasladado & _
              ", Retenido=" & .Retenido & _
              ", Acreditable=" & .Acreditable & _
              ", Pendiente=" & .Pendiente & _
              ", SaldoFavor=" & .SaldoFavor & _
              ", Compensado=" & .Compensado
   End With
   If Not DBEjecutar(lQry$) Then
      FNExclamBox "No se pudo guardar los datos del Reporte en la base de datos"
      Exit Sub
   End If
   
   '2. Genera el Reporte
   If pAnexo32.DestinoDisco Then
      FNMouseEspera True
      If Not ArchivoIVA2(pAnexo32, IVACOM, lNumReg2&) Then GoTo Salida
      If Not ArchivoIVA3(pAnexo32, IVACOM, lNumReg3&) Then GoTo Salida
      If Not ArchivoIVACOM1(pAnexo32, lNumReg2&, lNumReg3&, lNumReg1&) Then GoTo Salida
      'Imprimir Etiqueta
      frmEtiqueta.Presenta pAnexo32.Fecha1, pAnexo32.Fecha2, IVACOM, lNumReg1&, lNumReg2&, lNumReg3&
   Else
      FNInfoBox "Me falta el reporte a Pantalla/Impresora"
   End If
   
Salida:
   FNMouseEspera False
End Sub

'Genera los Archivos IVACOM2.TXT e IVADEV2.TXT
'Parámetros:
'   pAnexo32 -  (IN) : Trae todos los parámetros capturados del reporte
'   pFileName - (IN) : Nombre del Archivo a generar (IVACOM o IVADEV)
'   pNumReg& - (OUT) : Número de registros generados en el archivo
Private Function ArchivoIVA2(pAnexo32 As TAnexo32, pFileName$, pNumReg&) As Boolean
 Dim lQry$, lhCur%, i%, fp As Integer, lCad$, lRFCEmp$, lEjercicio$
 Dim lRegistros As Long, lOk As Boolean
 Dim lTempoFile$    'Archivo mdb con Base de datos temporal
 'Locales auxiliares
 Dim lhDBTmp%, lDato As Variant
 Dim lClave$, lFech As Variant, lRFC$, lNombre$
 Dim lFechUlt As Date, lNeto As Currency
 Dim lIVA As Currency, lNumOps As Long

 
   'Inicia
   lRegistros = 0
   lOk = True
   DBQueryDatos "SELECT RFC,Ejercicio FROM System", GDBMain, lRFCEmp$, lEjercicio$
   lEjercicio$ = Trim(lEjercicio$)
   lTempoFile$ = FNExePath & "ClipTmp" & Format(Now(), "yymmddhhnnss") & ".mdb"
   
   '1.Crea un archivo mdb externo para tablas temporales
   FileCopy FNExePath & TEMPODB_NAME, lTempoFile$
   
   '2.Abre la base de datos
   If Not DBConectar(lhDBTmp%, lTempoFile) Then
      lOk = False
      FNExclamBox "No se pudo generar tablas temporales"
      GoTo Salida
   End If
   
   
   'Arma el Query
   lQry$ = "SELECT * " & _
             "FROM Totales " & _
            "WHERE TipoEmpresa IN ('B','A','S','H') " & _
            "ORDER BY RFCNum,TipoEmpresa"
   
   'Ejecuta el Query
   If DBCursorIniciar(lhCur%, lQry$) Then
      'Barre el cursor
      Do While DBCursorSiguiente(lhCur%)
         'Obtiene la clave del Movimiento para el reporte
         Select Case DBCursorDato(lhCur%, "TipoEmpresa")
            Case "B"
               lClave = "1"
            Case "A"
               lClave = "2"
            Case "S", "H"
               lClave = "3"
         End Select
         'Obtiene el RFC
         lRFC$ = DBCursorDato(lhCur%, "RFCNum")
         
         'Obtiene los valores
         If pAnexo32.Anual Then
            'Toma los campos anuales
            lNeto = DBCursorDato(lhCur%, "Neto")
            lIVA = DBCursorDato(lhCur%, "IVA")
            lNumOps = DBCursorDato(lhCur%, "NumOps")
            lFechUlt = DBCursorDato(lhCur%, "FechUlt")
         Else
            lNeto = 0: lIVA = 0: lNumOps = 0: lFechUlt = CDate(0)
            'Toma la suma de los campos mensuales
            For i = Month(pAnexo32.Fecha1) To Month(pAnexo32.Fecha2)
               lCad$ = Format(i, "00")
                lDato = DBCursorDato(lhCur%, "Neto" & lCad$)
                lDato = IIf(lDato = "", "0", lDato)
               lNeto = lNeto + CCur(lDato)
                lDato = DBCursorDato(lhCur%, "IVA" & lCad$)
                lDato = IIf(lDato = "", "0", lDato)
               lIVA = lIVA + CCur(lDato)
                lDato = DBCursorDato(lhCur%, "NumOps" & lCad$)
                lDato = IIf(lDato = "", "0", lDato)
               lNumOps = lNumOps + CLng(lDato)
               'Se queda con la fecha mas grande
               lFech = DBCursorDato(lhCur%, "FechUlt" & lCad$)
               If lFech = "" Then lFech = CDate(0) Else lFech = CDate(lFech)
               lFechUlt = IIf(lFechUlt > lFech, lFechUlt, lFech)
            Next
            'Hay Cantidades?
            If lNeto > 0 Then
               'Existe ya un registro como éste?
               If DBQueryDato("SELECT Count(*) FROM TempIVA2" & _
                              " WHERE Clave='" & lClave & "'" & _
                                " AND RFCNum='" & FNTxtSybase(lRFC$) & "'", , _
                             lhDBTmp) > 0 Then
                  'Hace Update (acumulando)
                  lQry$ = "UPDATE TempIVA2 SET" & _
                               "  FechUlt=IIf(FechUlt > CDate('" & lFechUlt & "'), FechUlt, CDate('" & lFechUlt & "'))" & _
                               ", Neto=Neto+" & lNeto & _
                               ", IVA=IVA+" & lIVA & _
                               ", NumOps=NumOps+" & lNumOps & _
                          " WHERE Clave='" & lClave & "'" & _
                          " AND RFCNum='" & FNTxtSybase(lRFC$) & "'"
                  DBEjecutar lQry$, lhDBTmp
               Else
                  'Inserta el Registro
                  lQry$ = "INSERT INTO TempIVA2 (Clave,RFCNum,FechUlt,Neto,IVA,NumOps)" & _
                          "VALUES ('" & lClave & "'" & _
                          ", '" & FNTxtSybase(lRFC$) & "'" & _
                          ", CDate('" & lFechUlt & "')" & _
                          ", " & lNeto & "," & lIVA & "," & lNumOps & ")"
                  DBEjecutar lQry$, lhDBTmp
               End If
            End If
         End If
      Loop
      'Cierra el cursor
      DBCursorTerminar lhCur%
   Else
      lOk = False
      FNExclamBox "No se pudo leer los totales"
      DBDesconectar lhDBTmp
      GoTo Salida
   End If
   
   'Lee la tabla temporal
   lQry$ = "SELECT * FROM TempIVA2"
   'Ejecuta el Query
   If DBCursorIniciar(lhCur%, lQry$, lhDBTmp) Then
      'Crea el Archivo
      On Error GoTo FileError
      fp = FreeFile
      Open FixPath(pAnexo32.Ruta) & pFileName & "2.TXT" For Output As #fp
      lRegistros = 0
      
      'Barre el cursor
      Do While DBCursorSiguiente(lhCur%)
         'Arma el registro (parte fija)
         lCad$ = "0000" & PadR(lRFCEmp$, 13) & _
                 Format(pAnexo32.FechSaldI, "mmyyyy") & _
                 Format(pAnexo32.FechSaldF, "mmyyyy") & _
                 Format(pAnexo32.FechFavor, "ddmmyyyy") & _
                 pAnexo32.TipoDec
         'Prepara algunos datos
         lRFC$ = DBCursorDato(lhCur%, "RFCNum")
         lNombre$ = DBQueryDato("SELECT Nombre FROM Empresas WHERE RFCNum='" & lRFC$ & "'")
         
         lNumOps = DBCursorDato(lhCur%, "NumOps")
         lNeto = CCur(DBCursorDato(lhCur%, "Neto"))
         lIVA = CCur(DBCursorDato(lhCur%, "IVA"))
         'Ajusta longitudes de los números
         lNumOps = IIf(lNumOps > 999, 999, lNumOps)
         lNeto = IIf(lNeto > 999999999999#, 999999999999#, lNeto)
         lIVA = IIf(lIVA > 999999999999#, 999999999999#, lIVA)
         
         'Arma el registro (parte Variable)
         lCad$ = lCad$ & DBCursorDato(lhCur%, "Clave") & _
                 Format(DBCursorDato(lhCur%, "FechUlt"), "mmyyyy") & _
                 Format(lNumOps, "000") & _
                 PadR(lRFC$, 13) & _
                 PadR(SinPunct(lNombre$), 75) & _
                 Format(lNeto, String(12, Asc("0"))) & _
                 Format(lIVA, String(12, Asc("0")))
         'Escribe el registro en el archivo
         Print #fp, lCad$
         lRegistros = lRegistros + 1
      Loop
      
      'Cierra el archivo
      Close #fp
      On Error GoTo 0
      'Cierra el cursor
      DBCursorTerminar lhCur%
   Else
      lOk = False
      FNExclamBox "No se pudo leer la tabla temporal"
   End If
   'Se desconecta de la base temporal
   DBDesconectar lhDBTmp%
   'Borra el archivo Temporal
   Kill lTempoFile$
   
Salida:
   pNumReg& = lRegistros
   ArchivoIVA2 = lOk
   Exit Function
   
FileError:
   lOk = False
   FNExclamBox "No se pudo Generar el archivo " & pFileName & "2.TXT " & vbCr & Err.Description
   Resume Salida
End Function


'Genera los Archivos IVACOM3.TXT e IVADEV3.TXT
'Parámetros:
'   pAnexo32 -  (IN) : Trae todos los parámetros capturados del reporte
'   pFileName - (IN) : Nombre del Archivo a generar (IVACOM o IVADEV)
'   pNumReg& - (OUT) : Número de registros generados en el archivo
Private Function ArchivoIVA3(pAnexo32 As TAnexo32, pFileName$, pNumReg&) As Boolean
 Dim lQry$, lhCur%, fp As Integer, lRFCEmp$, lEjercicio$
 'Locales auxiliares
 Dim lRegistros As Long, lOk As Boolean
 Dim i%, lCad$
 Dim lNeto As Currency, lIVA As Currency
 Dim lAgente As Long, lAduana As Long, lPedimento As Long

 
   'Inicia
   lOk = True
   DBQueryDatos "SELECT RFC,Ejercicio FROM System", GDBMain, lRFCEmp$, lEjercicio$
   lEjercicio$ = Trim(lEjercicio$)
   
   'Arma el Query
   'Importaciones
   lQry$ = "SELECT '1' AS Clave, Fecha, Agente,Factura,Aduana," & _
                   "b.Nombre AS Nombre,Neto,IVA " & _
             "FROM Facturas a, Empresas b " & _
            "WHERE a.TipoEmpresa='I' " & _
              "AND a.RFCNum=b.RFCNum"
   'Exportaciones
   lQry$ = lQry$ & " UNION ALL " & _
           "SELECT '1' AS Clave, Fecha, Agente,Factura,Aduana," & _
                   "b.Nombre AS Nombre,Neto,IVA " & _
             "FROM Facturas a, Empresas b " & _
            "WHERE a.TipoEmpresa='E' " & _
              "AND a.RFCNum=b.RFCNum"
   'Ejecuta el Query
   If DBCursorIniciar(lhCur%, lQry$) Then
      'Crea el Archivo
      On Error GoTo FileError
      fp = FreeFile
      Open FixPath(pAnexo32.Ruta) & pFileName & "3.TXT" For Output As #fp
      lRegistros = 0
      
      'Barre el cursor
      Do While DBCursorSiguiente(lhCur%)
         'Arma el registro (parte fija)
         lCad$ = "0000" & PadR(lRFCEmp$, 13) & _
                 Format(pAnexo32.FechSaldI, "mmyyyy") & _
                 Format(pAnexo32.FechSaldF, "mmyyyy") & _
                 Format(pAnexo32.FechFavor, "ddmmyyyy") & _
                 pAnexo32.TipoDec
         'Prepara algunos datos
         lNeto = CCur(DBCursorDato(lhCur%, "Neto"))
         lIVA = CCur(DBCursorDato(lhCur%, "IVA"))
         lAgente = CLng(DBCursorDato(lhCur%, "Agente"))
         lAduana = CLng(DBCursorDato(lhCur%, "Aduana"))
         lPedimento = CLng(DBCursorDato(lhCur%, "Factura"))
         
         'Ajusta longitudes de los números
         lNeto = IIf(lNeto > 999999999999#, 999999999999#, lNeto)
         lIVA = IIf(lIVA > 999999999999#, 999999999999#, lIVA)
         
         'Arma el registro (parte Variable)
         lCad$ = lCad$ & DBCursorDato(lhCur%, "Clave") & _
                 Format(DBCursorDato(lhCur%, "Fecha"), "ddmmyyyy") & _
                 Format(lAgente, "0000") & _
                 Format(lPedimento, "0000000") & _
                 Format(lAduana, "000") & _
                 PadR(SinPunct(DBCursorDato(lhCur%, "Nombre")), 75) & _
                 Format(lNeto, String(12, Asc("0"))) & _
                 Format(lIVA, String(12, Asc("0")))
         'Escribe el registro en el archivo
         Print #fp, lCad$
         lRegistros = lRegistros + 1
      Loop
      
      'Cierra el archivo
      Close #fp
      On Error GoTo 0
      'Cierra el cursor
      DBCursorTerminar lhCur%
   Else
      lOk = False
      FNExclamBox "No se pudo leer las exportaciones e importaciones"
   End If
   
Salida:
   pNumReg& = lRegistros
   ArchivoIVA3 = lOk
   Exit Function
   
FileError:
   lOk = False
   FNExclamBox "No se pudo Generar el archivo " & pFileName & "3.TXT " & vbCr & Err.Description
   Resume Salida
End Function


'Genera el Archivos IVACOM1.TXT
'Parámetros:
'   pAnexo32 -  (IN) : Trae todos los parámetros capturados del reporte
'   pNumReg2& - (IN) : Número de registros de IVACOM2
'   pNumReg3& - (IN) : Número de registros de IVACOM3
'   pNumReg1& -(OUT) : Número de registros generados en el archivo
Private Function ArchivoIVACOM1(pAnexo32 As TAnexo32, pNumReg2&, pNumReg3&, pNumReg1&) As Boolean
 Dim lhCur%, fp As Integer
 'Locales auxiliares
 Dim lRegistros As Long, lOk As Boolean
 Dim lCad$
 Dim lReg2&, lReg3&, lTipoDec%
 
   'Inicia
   lOk = True
   
   If DBCursorIniciar(lhCur%, "SELECT * FROM System") Then
      DBCursorSiguiente lhCur%
      
      'Crea el Archivo
      On Error GoTo FileError
      fp = FreeFile
      Open FixPath(pAnexo32.Ruta) & "IVACOM1.TXT" For Output As #fp
      lRegistros = 0
      
      'Prepara algunos datos
      lReg2 = IIf(pNumReg2 > 9999, 9999, pNumReg2)
      lReg3 = IIf(pNumReg3 > 9999, 9999, pNumReg3)
      lTipoDec = IIf(pAnexo32.Anual, 2, 1)
      
      'Arma el registro
      lCad$ = "0000" & _
              PadR(DBCursorDato(lhCur%, "RFC"), 13) & _
              PadR(SinPunct(DBCursorDato(lhCur%, "Empresa")), 75) & _
              Format(pAnexo32.FechComp, "ddmmyyyy") & _
              Format(pAnexo32.FechCompI, "mmyyyy") & _
              Format(pAnexo32.FechCompF, "mmyyyy") & _
              Format(pAnexo32.FechSaldI, "mmyyyy") & _
              Format(pAnexo32.FechSaldF, "mmyyyy") & _
              pAnexo32.TipoDec
      lCad$ = lCad$ & _
              Format(pAnexo32.FechFavor, "ddmmyyyy") & _
              Format(pAnexo32.Trasladado, String(12, Asc("0"))) & _
              Format(pAnexo32.Retenido, String(12, Asc("0"))) & _
              Format(pAnexo32.Acreditable, String(12, Asc("0"))) & _
              Format(pAnexo32.Pendiente, String(12, Asc("0"))) & _
              Format(pAnexo32.SaldoFavor, String(12, Asc("0"))) & _
              Format(pAnexo32.Compensado, String(12, Asc("0"))) & _
              Format(pNumReg2, "0000") & _
              Format(pNumReg3, "0000") & _
              lTipoDec
      
      'Escribe el registro en el archivo
      Print #fp, lCad$
      lRegistros = lRegistros + 1
      
      'Cierra el archivo
      Close #fp
      On Error GoTo 0
      'Cierra el cursor
      DBCursorTerminar lhCur%
   Else
      lOk = False
      FNExclamBox "No se pudo leer los datos de la empresa"
   End If
   
Salida:
   pNumReg1& = lRegistros
   ArchivoIVACOM1 = lOk
   Exit Function
   
FileError:
   lOk = False
   FNExclamBox "No se pudo Generar el archivo IVACOM1.TXT " & vbCr & Err.Description
   Resume Salida
End Function



'************************************************************
'*** Funciones para el manejo de cadenas
'************************************************************

'Añade Espacios a la Izquierda.
'Devuelve una cadena de longitud pLen con espacios a la izquierda y
' con la cadena pStr$ a la derecha
Function PadL(pStr$, pLen%, Optional pChar$ = " ") As String
   If Len(pStr$) > pLen% Then
      PadL = Left(pStr$, pLen%)
   Else
      PadL = Right(String(pLen%, Asc(pChar$)) & pStr$, pLen%)
   End If
End Function

'Añade Espacios a la Derecha.
'Devuelve una cadena de longitud pLen con espacios a la derecha y
' con la cadena pStr$ a la izquierda
Function PadR(pStr$, pLen%, Optional pChar$ = " ") As String
   If Len(pStr$) > pLen% Then
      PadR = Left(pStr$, pLen%)
   Else
      PadR = Left(pStr$ & String(pLen%, Asc(pChar$)), pLen%)
   End If
End Function

'Devuelve una Cadena sin separadores
Function SinPunct(pStr$) As String
 Dim lCad$, lArray, lDelim$
 Dim i%
 Const lDelims = ",.;:'"""
   
   'Inicia
   lCad$ = pStr$
   
   'Para cada uno de los delimitadores
   For i = 1 To Len(lDelims)
      'Obtiene el delimitador
      lDelim = Mid(lDelims, i, 1)
      'Divide la Cadena en cada delimitador
      lArray = Split(lCad$, lDelim)
      'La vuelve a pegar sin delimitador
      lCad$ = Join(lArray, "")
   Next
   'Sustituye la Eñe
   lArray = Split(lCad$, "Ñ")
   lCad$ = Join(lArray, "&")
   lArray = Split(lCad$, "ñ")
   lCad$ = Join(lArray, "&")

   'Regresa
   SinPunct = lCad$
End Function

'Pone bien el \ final en un path
Function FixPath(pPath$) As String
  If Right(pPath$, 1) = "\" Then
     FixPath = pPath$
  Else
    FixPath = pPath$ & "\"
  End If
End Function
